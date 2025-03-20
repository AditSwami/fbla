import 'package:flutter/material.dart';
import 'package:fbla_2025/Services/Firebase/firestore/classes.dart';
import 'package:fbla_2025/Services/Firebase/firestore/db.dart';
import 'package:fbla_2025/app_ui.dart';

class UnitScoreCard extends StatelessWidget {
  final UnitData unit;
  final ClassData clas;
  final Function(int) onScoreUpdate;

  const UnitScoreCard({
    required this.unit,
    required this.clas,
    required this.onScoreUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppUi.grey.withOpacity(0.15),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Test Score',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Current Score: ${unit.score.toStringAsFixed(0)}%',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                ElevatedButton(
                  onPressed: () => _updateScore(context),
                  child: Text('Update Score'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _updateScore(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Update Test Score'),
        content: TextField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Score (0-100)',
          ),
          onSubmitted: (value) async {
            final score = int.tryParse(value);
            if (score != null && score >= 0 && score <= 100) {
              await Firestore.updateUnitTestScore(score, unit, clas);
              onScoreUpdate(score);
              Navigator.pop(context);
            }
          },
        ),
      ),
    );
  }
}