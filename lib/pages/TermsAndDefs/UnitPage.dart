import 'package:fbla_2025/Services/Firebase/firestore/classes.dart';
import 'package:fbla_2025/app_ui.dart';
import 'package:fbla_2025/components/TermsBox.dart';
import 'package:fbla_2025/pages/Games/CrosswordGame.dart';
import 'package:fbla_2025/pages/Games/MatchingGame.dart';
import 'package:fbla_2025/pages/Games/QuizGame.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Unitpage extends StatefulWidget {
  Unitpage({super.key, required this.unit});

  UnitData unit;

  @override
  State<Unitpage> createState() => _UnitpageState();
}

class _UnitpageState extends State<Unitpage> {
  Map<String, dynamic> termsAndDefs = {};
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    termsAndDefs = Map<String, dynamic>.from(widget.unit.terms);
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
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 35.0, top: 10),
              child: CircleAvatar(
                radius: 20,
              ),
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
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MatchingGame(terms: termsAndDefs),
                        ),
                      ),
                    ),
                    _gameButton(
                      'Crossword',
                      Icons.edit_square,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CrosswordGame(terms: termsAndDefs),
                        ),
                      ),
                    ),
                    _gameButton(
                      'Quiz',
                      Icons.quiz_rounded,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuizGame(terms: termsAndDefs),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
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
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: AppUi.primary,
              size: 32,
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
}