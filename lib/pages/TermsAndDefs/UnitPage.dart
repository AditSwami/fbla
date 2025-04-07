import 'package:fbla_2025/Services/Firebase/firestore/classes.dart';
import 'package:fbla_2025/Services/Firebase/firestore/db.dart';
import 'package:fbla_2025/Services/progress_service.dart';
import 'package:fbla_2025/app_ui.dart';
import 'package:fbla_2025/components/Buttons/button.dart';
import 'package:fbla_2025/components/terms/TermsBox.dart';
import 'package:fbla_2025/pages/Games/CrosswordGame.dart';
import 'package:fbla_2025/pages/Games/MatchingGame.dart';
import 'package:fbla_2025/pages/Games/WordSearch.dart';
import 'package:fbla_2025/pages/Games/QuizGame.dart';
import 'package:fbla_2025/pages/TermsAndDefs/Add_Terms.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Unitpage extends StatefulWidget {
  Unitpage({super.key, required this.unit, required this.clas});

  UnitData unit;

  ClassData clas;

  @override
  State<Unitpage> createState() => _UnitpageState();
}

class _UnitpageState extends State<Unitpage> {
  Map<String, dynamic> termsAndDefs = {};
  int currentIndex = 0;

  // Add after termsAndDefs declaration
  List<int> unitScores = [];

  @override
  void initState() {
    super.initState();
    termsAndDefs = Map<String, dynamic>.from(widget.unit.terms);
    _loadUnitScores();
  }

  Future<void> _refreshPage() async {
    // Refresh terms
    final updatedTerms = await Firestore.getUnitTerms(widget.clas.id, widget.unit.id);
    if (mounted && updatedTerms != null) {
      setState(() {
        widget.unit.terms = updatedTerms;
        termsAndDefs = Map<String, dynamic>.from(updatedTerms);
      });
    }
    await _loadUnitScores();
  }

  Future<void> _loadUnitScores() async {
    final scores = await ProgressService.getUnitScores(widget.unit.id);
    if (mounted) {  // Add this check
      setState(() {
        unitScores = scores;
      });
    }
  }

  // Add before the AppBar in build method
  Widget _buildProgressHeader() {
    final averageScore = unitScores.isEmpty 
        ? 0 
        : unitScores.reduce((a, b) => a + b) ~/ unitScores.length;
    
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Average Score: $averageScore',
                style: Theme.of(context).textTheme.titleMedium),
              Text('Games Played: ${unitScores.length}',
                style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
          const SizedBox(
            width: 90,
          ),
        ],
      ),
    );
  }
    
  @override
  Widget build(BuildContext context) {
    final entries = termsAndDefs.entries.toList();
    
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        toolbarHeight: 60,
        backgroundColor: AppUi.backgroundDark,
        title: Text(
          widget.unit.name,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: false,
        // Add to AppBar actions
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Button(
              height: 35,
              width: 35,
              color: AppUi.primary,
              onTap: () => Navigator.push(
                context,
                CupertinoPageRoute(builder: (context) => AddTermsPage(unit: widget.unit, clas: widget.clas,)),
              ),
              child: Icon(Icons.add, color: AppUi.offWhite, size: 28),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 30.0, left: 4),
            child: Button(
              height: 35,
              width: 35,
              color: AppUi.primary,
              onTap: _showStudyTips,  // Changed this line
              child: Icon(Icons.question_mark, color: AppUi.offWhite, size: 20),
            ),
          ),
        ],
      ),
      // Add in build method after AppBar
      body: Semantics(
        label: 'Unit study page for ${widget.unit.name}',
        child: RefreshIndicator(
          color: AppUi.primary,
          backgroundColor: AppUi.backgroundDark,
          onRefresh: _refreshPage,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(), // Add this
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 35.0, top: 25),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: AppUi.grey
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, top: 16),
                      child: Text(
                        widget.clas.creator,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ],
                ),
                if (entries.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0, left: 35),
                    child: Termsbox(
                      term: entries[currentIndex].key.toString(),
                      def: entries[currentIndex].value.toString(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: currentIndex > 0 ? Colors.white : Colors.grey,
                        ),
                        onPressed: currentIndex > 0
                            ? () {
                                setState(() {
                                  currentIndex--;
                                });
                              }
                            : null,
                      ),
                      const SizedBox(width: 40),
                      IconButton(
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          color: currentIndex < entries.length - 1 
                              ? Colors.white 
                              : Colors.grey,
                        ),
                        onPressed: currentIndex < entries.length - 1
                            ? () {
                                setState(() {
                                  currentIndex++;
                                });
                              }
                            : null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _gameButton(
                          'Match',
                          Icons.grid_view_rounded,
                          () => _navigateToGame(MatchingGame(
                            terms: termsAndDefs,
                            unit: widget.unit,
                            clas: widget.clas,
                          )),
                        ),
                        _gameButton(
                          'Crossword',
                          Icons.edit_square,
                          () => _navigateToGame(CrosswordGame(
                            terms: termsAndDefs,
                          )),
                        ),
                        _gameButton(
                          'Quiz',
                          Icons.quiz_rounded,
                          () => _navigateToGame(QuizGame(
                            terms: termsAndDefs,
                            unit: widget.unit,
                            clas: widget.clas,
                          )),
                        ),
                        _gameButton(
                          'Search',
                          Icons.search_rounded,
                          () => _navigateToGame(WordSearch(
                            terms: termsAndDefs,
                            unit: widget.unit,
                            clas: widget.clas,
                          )),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppUi.grey.withValues(alpha: .1),
                      border: Border.all(
                        color: AppUi.grey.withOpacity(0.2),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Column(
                      children: [
                        _buildProgressHeader(),
                        Divider(
                          color: AppUi.grey.withOpacity(0.2),
                          thickness: 1,
                          indent: 20,
                          endIndent: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: _buildUnitScoreCard(),
                        ),  // Keep the score card
                      ],
                    )
                  ),
                ),
                const SizedBox(
                  height: 80
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _navigateToGame(Widget game) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => game),
    );
    
    if (result != null && game is QuizGame) {
      setState(() {
        widget.unit.testScore = (widget.unit.testScore + result) ~/ 2;
      });
    }
    
    // Reload unit scores for other games
    await _loadUnitScores();
    setState(() {});
  }

  void _showStudyTips() {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: AppUi.backgroundDark,
              title: Text('Study Tips', 
                style: Theme.of(context).textTheme.titleLarge),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTip('Use flashcards for quick review'),
                  _buildTip('Play matching game to reinforce connections'),
                  _buildTip('Take quizzes to test your knowledge'),
                  _buildTip('Try crosswords for word recognition'),
                ],
              ),
              actions: [
                Button(
                  height: 40,
                  width: 70,
                  child: Center(
                    child: Text('Got it!', 
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ),
                  onTap: () => Navigator.pop(context),
                )
              ],
            ),
          );
        }
      
        Widget _buildTip(String tip) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Icon(Icons.tips_and_updates, 
                  color: AppUi.primary, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(tip, 
                    style: Theme.of(context).textTheme.bodyMedium),
                ),
              ],
            ),
          );
        }

  Widget _gameButton(String label, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppUi.grey.withOpacity(0.1),
              border: Border.all(
                color: AppUi.grey.withOpacity(0.2),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: AppUi.offWhite,
              size: 24,  // Made icon smaller
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

   Widget _buildUnitScoreCard() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35.0),
        child: Container(
          decoration: BoxDecoration(
            color: AppUi.grey.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Test Score',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${widget.unit.score.toStringAsFixed(0)}%',
                      style: Theme.of(context).textTheme.bodyLarge
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }
}