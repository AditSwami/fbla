import 'dart:async';

import 'package:fbla_2025/Services/Firebase/firestore/classes.dart';
import 'package:fbla_2025/Services/progress_service.dart';
import 'package:fbla_2025/components/Buttons/button.dart';
import 'package:fbla_2025/pages/TermsAndDefs/UnitPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fbla_2025/app_ui.dart';

class MatchingGame extends StatefulWidget {
  const MatchingGame({
    super.key, 
    required this.terms,
    required this.unit,  // Add this
    required this.clas,  // Add this
  });

  final Map<String, dynamic> terms;
  final UnitData unit; // Add this
  final ClassData clas;

  @override
  State<MatchingGame> createState() => _MatchingGameState();
}

class _MatchingGameState extends State<MatchingGame> {
  List<String> terms = [];
  List<String> definitions = [];
  String? selectedTerm;
  String? selectedDef;
  List<bool> termMatched = [];
  List<bool> defMatched = [];
  // Add these variables at the start of _MatchingGameState
  int score = 0;
  DateTime? startTime;
  int maxScore = 100; // Maximum possible score
  int timeLimit = 180; // 3 minutes time limit in seconds
  // Add this variable to track current time
  late ValueNotifier<int> _secondsElapsed;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startTime = DateTime.now();
    _secondsElapsed = ValueNotifier<int>(0);
    _startTimer();
    terms = widget.terms.keys.toList()..shuffle();
    definitions = widget.terms.values.map((e) => e.toString()).toList()..shuffle();
    termMatched = List.generate(terms.length, (index) => false);
    defMatched = List.generate(definitions.length, (index) => false);
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _secondsElapsed.value = DateTime.now().difference(startTime!).inSeconds;
    });
  }

  void checkMatch() {
    if (selectedTerm != null && selectedDef != null) {
      if (widget.terms[selectedTerm] == selectedDef) {
        final termIndex = terms.indexOf(selectedTerm!);
        final defIndex = definitions.indexOf(selectedDef!);
        setState(() {
          termMatched[termIndex] = true;
          defMatched[defIndex] = true;
          
          // Check if all matches are complete
          if (termMatched.every((matched) => matched)) {
            _calculateFinalScore();
            _showCompletionDialog();
          }
        });
      } else {
        // Wrong match feedback
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Try again!'),
            backgroundColor: Colors.red.withOpacity(0.7),
            duration: const Duration(seconds: 1),
          ),
        );
      }
      setState(() {
        selectedTerm = null;
        selectedDef = null;
      });
    }
  }

  void _calculateFinalScore() {
    final endTime = DateTime.now();
    final duration = endTime.difference(startTime!);
    final secondsTaken = duration.inSeconds;

    // Calculate score based on time taken
    if (secondsTaken <= timeLimit) {
      // Score decreases linearly as time increases
      score = ((timeLimit - secondsTaken) * maxScore ~/ timeLimit).clamp(0, maxScore);
    } else {
      // Minimum score of 10 if time limit exceeded
      score = 10;
    }

    // Add bonus points for quick completion
    if (secondsTaken < 60) {
      score += 20; // Speed bonus
    } else if (secondsTaken < 120) {
      score += 10; // Medium speed bonus
    }
  }

  void _showCompletionDialog() {
    final endTime = DateTime.now();
    final duration = endTime.difference(startTime!);
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;

    // Save the score
    ProgressService.saveScore(widget.unit.id, 'match', score);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppUi.backgroundDark,
        title: Text('Congratulations!', 
          style: Theme.of(context).textTheme.titleLarge),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Time: ${minutes}m ${seconds}s'),
            const SizedBox(height: 8),
            Text('Score: $score'),
            if (duration.inSeconds < 60) ...[
              const SizedBox(height: 8),
              Text('🏆 Speed Demon! +20 points',
                style: TextStyle(color: AppUi.primary)),
            ] else if (duration.inSeconds < 120) ...[
              const SizedBox(height: 8),
              Text('⚡ Quick Matcher! +10 points',
                style: TextStyle(color: AppUi.primary)),
            ],
          ],
        ),
        actions: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppUi.primary
            ),
            child: TextButton(
              onPressed: () {
                // Replace OK button in dialog
                Button(
                  height: 40,
                  width: 80,
                  color: AppUi.primary,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.push(
                      context, 
                      CupertinoPageRoute(builder: (context) => Unitpage(unit: widget.unit, clas: widget.clas)));
                  },
                  child: Text('OK',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: AppUi.backgroundDark
                    ),
                  ),
                );
              },
              child: Text('OK',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: AppUi.backgroundDark
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  @override
  void dispose() {
    _timer?.cancel();
    _secondsElapsed.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppUi.backgroundDark,
        centerTitle: false,
        title: Text('Matching', style: Theme.of(context).textTheme.titleLarge),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                'Score: $score',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Timer display
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Center(
              child: ValueListenableBuilder<int>(
                valueListenable: _secondsElapsed,
                builder: (context, seconds, child) {
                  final minutes = seconds ~/ 60;
                  final remainingSeconds = seconds % 60;
                  return Text(
                    'Time: ${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: seconds > timeLimit 
                          ? Colors.red 
                          : AppUi.offWhite,
                    ),
                  );
                },
              ),
            ),
          ),
          // Existing game content
          Expanded(
            child: Row(
              children: [
                // Terms Column
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: terms.length,
                    itemBuilder: (context, index) {
                      if (termMatched[index]) return const SizedBox.shrink();
                      return Card(
                        color: selectedTerm == terms[index] 
                            ? AppUi.primary.withOpacity(0.3)
                            : AppUi.grey.withOpacity(0.1),
                        child: ListTile(
                          title: Text(terms[index]),
                          onTap: () {
                            setState(() {
                              selectedTerm = terms[index];
                              checkMatch();
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
                // Definitions Column
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: definitions.length,
                    itemBuilder: (context, index) {
                      if (defMatched[index]) return const SizedBox.shrink();
                      return Card(
                        color: selectedDef == definitions[index]
                            ? AppUi.primary.withOpacity(0.3)
                            : AppUi.grey.withOpacity(0.1),
                        child: ListTile(
                          title: Text(definitions[index]),
                          onTap: () {
                            setState(() {
                              selectedDef = definitions[index];
                              checkMatch();
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}