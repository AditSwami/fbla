import 'package:fbla_2025/Services/Firebase/firestore/classes.dart';
import 'package:fbla_2025/Services/Firebase/firestore/db.dart';
import 'package:fbla_2025/components/Buttons/button.dart';
import 'package:fbla_2025/pages/TermsAndDefs/UnitPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fbla_2025/app_ui.dart';

class QuizGame extends StatefulWidget {
  const QuizGame({
    super.key, 
    required this.terms,
    required this.unit,   // Add unit parameter
    required this.clas,   // Add class parameter
  });

  final Map<String, dynamic> terms;
  final UnitData unit;    // Add unit field
  final ClassData clas;   // Add class field

  @override
  State<QuizGame> createState() => _QuizGameState();
}

class _QuizGameState extends State<QuizGame> {
  late List<Map<String, dynamic>> questions;
  int currentQuestion = 0;
  int score = 0;
  bool? isCorrect;
  bool showAnswer = false;
  Object? selected;  // Change to Object? which can properly handle null
  
  void _checkAnswer(String selected) {
    if (showAnswer) return;

    setState(() {
      showAnswer = true;
      this.selected = selected;  // Store the selected answer
      isCorrect = selected == questions[currentQuestion]['correct'];
      if (isCorrect!) score += 10;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && currentQuestion < questions.length - 1) {
        setState(() {
          currentQuestion++;
          showAnswer = false;
          isCorrect = null;
          selected = "";  // This should now work properly
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    questions = _generateQuestions();
  }

  List<Map<String, dynamic>> _generateQuestions() {
    final terms = widget.terms.entries.toList();
    terms.shuffle();
    
    return List.generate(terms.length, (index) {
      final correct = terms[index];
      final otherTerms = List.of(terms)..remove(correct);
      otherTerms.shuffle();
      
      final options = [
        correct.value,
        ...otherTerms.take(3).map((e) => e.value),
      ]..shuffle();

      return {
        'term': correct.key,
        'correct': correct.value,
        'options': options,
      };
    });
  }

  Future<void> _onQuizComplete(int score) async {
    int currentScore = widget.unit.testScore;
    int newAverage = (currentScore + score) ~/ 2;

    await Firestore.updateUnitTestScore(newAverage, widget.unit, widget.clas);
    
    setState(() {
      widget.unit.testScore = newAverage;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppUi.backgroundDark,
        title: Text('Quiz Complete!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Your Score: $score%'),
            Text('New Average Score: $newAverage%'),
          ],
        ),
        actions: [
          Button(
            height: 40,
            width: 80,
            color: AppUi.primary,
            onTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => Unitpage(
                    unit: widget.unit,
                    clas: widget.clas,
                  ),
                ),
              );
            },
            child: Text(
              'OK',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: AppUi.backgroundDark
              ),
            ),
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
        title: Text('Quiz', style: Theme.of(context).textTheme.titleLarge),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(
              value: (currentQuestion + 1) / questions.length,
              backgroundColor: AppUi.grey.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(AppUi.primary),
            ),
            const SizedBox(height: 32),
            Text(
              'What is the definition of:',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              questions[currentQuestion]['term'].toString(),
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            // Replace question bank buttons
            ...questions[currentQuestion]['options'].map<Widget>((option) {
            final bool isCorrectAnswer = option == questions[currentQuestion]['correct'];
            final bool isSelectedAnswer = option == selected;
            
            Color? backgroundColor = AppUi.grey.withOpacity(0.1);
            if (showAnswer) {
            if (isCorrectAnswer) {
            backgroundColor = Colors.green.withOpacity(0.7);
            } else if (isSelectedAnswer && !isCorrectAnswer) {
            backgroundColor = Colors.red.withOpacity(0.7);
            }
            }
            
            return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Button(
            color: backgroundColor,
            onTap: () => _checkAnswer(option),
            child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
            option.toString(),
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
            ),
            ),
            ),
            );
            }).toList(),
            
            // Replace Finish Quiz button
            if (currentQuestion == questions.length - 1 && showAnswer)
            Button(
            color: AppUi.primary,
            onTap: () async {
            await _onQuizComplete(score);
            Navigator.pop(context, score);
            Navigator.pushAndRemoveUntil(
            context, 
            CupertinoPageRoute(
            builder: (context) => Unitpage(
            unit: widget.unit,
            clas: widget.clas,
            ),
            ), 
            (route) => route.isFirst
            );
            },
            child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
            'Finish Quiz',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: AppUi.backgroundDark
            ),
            ),
            ),
            ),
          ],
        ),
      ),
    );
  }
}