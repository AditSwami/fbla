import 'package:shared_preferences/shared_preferences.dart';  // Updated import

class ProgressService {
  static const String _scoreKey = 'user_scores';
  static const String _achievementsKey = 'user_achievements';

  static Future<void> saveScore(String unitId, String gameType, int score) async {
    final prefs = await SharedPreferences.getInstance();
    final scores = prefs.getStringList(_scoreKey) ?? [];
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    scores.add('$unitId:$gameType:$score:$timestamp');
    await prefs.setStringList(_scoreKey, scores);
  }

  static Future<List<int>> getUnitScores(String unitId) async {
    final prefs = await SharedPreferences.getInstance();
    final scores = prefs.getStringList(_scoreKey) ?? [];
    
    // Filter scores for this unit and extract just the score values
    final unitScores = scores
        .where((score) => score.startsWith('$unitId:'))
        .map((score) {
          final parts = score.split(':');
          return int.parse(parts[2]); // Score is the third element
        })
        .toList();
    
    return unitScores.isEmpty ? [] : unitScores;
  }

  static Future<void> unlockAchievement(String achievement) async {
    final prefs = await SharedPreferences.getInstance();
    final achievements = prefs.getStringList(_achievementsKey) ?? [];
    if (!achievements.contains(achievement)) {
      achievements.add(achievement);
      await prefs.setStringList(_achievementsKey, achievements);
    }
  }

  // Add method to clear all scores (useful for testing)
  static Future<void> clearAllScores() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_scoreKey);
  }
}