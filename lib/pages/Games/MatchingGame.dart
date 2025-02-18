import 'package:flutter/material.dart';
import 'package:fbla_2025/app_ui.dart';

class MatchingGame extends StatefulWidget {
  const MatchingGame({super.key, required this.terms});

  final Map<String, dynamic> terms;

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
  int score = 0;
  DateTime? startTime;
  
  @override
  void initState() {
    super.initState();
    startTime = DateTime.now();
    terms = widget.terms.keys.toList()..shuffle();
    definitions = widget.terms.values.map((e) => e.toString()).toList()..shuffle();
    termMatched = List.generate(terms.length, (index) => false);
    defMatched = List.generate(definitions.length, (index) => false);
  }

  void checkMatch() {
    if (selectedTerm != null && selectedDef != null) {
      if (widget.terms[selectedTerm] == selectedDef) {
        final termIndex = terms.indexOf(selectedTerm!);
        final defIndex = definitions.indexOf(selectedDef!);
        setState(() {
          termMatched[termIndex] = true;
          defMatched[defIndex] = true;
          score += 10;
          
          // Check if all matches are complete
          if (termMatched.every((matched) => matched)) {
            _showCompletionDialog();
          }
        });
      } else {
        // Wrong match feedback
        setState(() {
          score = score > 0 ? score - 5 : 0;  // Penalty for wrong match
        });
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

  // Add after score variable
  bool isSpeedAchievement = false;
  bool isPerfectAchievement = false;

  void checkAchievements(Duration duration) {
    // Speed achievement - complete under 1 minute
    if (duration.inSeconds < 60) {
      isSpeedAchievement = true;
      score += 20;
    }
    // Perfect match achievement - no wrong attempts
    if (score == terms.length * 10) {
      isPerfectAchievement = true;
      score += 30;
    }
  }

  void _showCompletionDialog() {
    final endTime = DateTime.now();
    final duration = endTime.difference(startTime!);
    checkAchievements(duration);
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;

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
            if (isSpeedAchievement) ...[
              const SizedBox(height: 8),
              Text('🏆 Speed Demon! +20 points',
                style: TextStyle(color: AppUi.primary)),
            ],
            if (isPerfectAchievement) ...[
              const SizedBox(height: 8),
              Text('⭐ Perfect Match! +30 points',
                style: TextStyle(color: AppUi.primary)),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Return to UnitPage
            },
            child: Text('OK',
              style: TextStyle(color: AppUi.primary)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppUi.backgroundDark,
        title: Text('Matching Game', style: Theme.of(context).textTheme.titleLarge),
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
      body: Row(
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
    );
  }
}