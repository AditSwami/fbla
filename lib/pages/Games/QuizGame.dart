import 'package:flutter/material.dart';
import 'package:fbla_2025/app_ui.dart';

class QuizGame extends StatefulWidget {
  const QuizGame({super.key, required this.terms});

  final Map<String, dynamic> terms;

  @override
  State<QuizGame> createState() => _QuizGameState();
}

class _QuizGameState extends State<QuizGame> {
  late List<Map<String, dynamic>> questions;
  int currentQuestion = 0;
  int score = 0;
  bool? isCorrect;
  bool showAnswer = false;

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

  void _checkAnswer(String selected) {
    if (showAnswer) return;

    setState(() {
      showAnswer = true;
      isCorrect = selected == questions[currentQuestion]['correct'];
      if (isCorrect!) score += 10;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && currentQuestion < questions.length - 1) {
        setState(() {
          currentQuestion++;
          showAnswer = false;
          isCorrect = null;
        });
      }
    });
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
            ...questions[currentQuestion]['options'].map<Widget>((option) {
              final bool isSelected = showAnswer && 
                  option == questions[currentQuestion]['correct'];
              final bool isWrong = showAnswer && 
                  option != questions[currentQuestion]['correct'];
              
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: showAnswer
                          ? isSelected
                              ? Colors.green.withOpacity(0.3)
                              : isWrong
                                  ? Colors.red.withOpacity(0.3)
                                  : AppUi.grey.withOpacity(0.1)
                          : AppUi.grey.withOpacity(0.1),
                      padding: const EdgeInsets.all(16),
                    ),
                    onPressed: () => _checkAnswer(option),
                    child: Text(
                      option.toString(),
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            }).toList(),
            if (currentQuestion == questions.length - 1 && showAnswer)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppUi.primary,
                  padding: const EdgeInsets.all(16),
                ),
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Finish Quiz',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
          ],
        ),
      ),
    );
  }
}