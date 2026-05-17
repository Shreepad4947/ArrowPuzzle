import '../levels/level_data.dart';
import '../models/level_model.dart';
import '../services/daily_challenge_service.dart';

class LevelRepository {
  /// Get a level by its number (1-based)
  LevelModel? getLevel(int levelNumber) {
    return LevelData.getLevel(levelNumber);
  }

  /// Get all levels
  List<LevelModel> getAllLevels() {
    return LevelData.allLevels;
  }

  /// Get total number of levels
  int getTotalLevels() {
    return LevelData.totalLevels;
  }

  /// Check if a level exists
  bool hasLevel(int levelNumber) {
    return LevelData.hasLevel(levelNumber);
  }

  /// Get next level number
  int? getNextLevel(int currentLevel) {
    return LevelData.getNextLevelNumber(currentLevel);
  }

  /// Get daily challenge for a specific date
  LevelModel getDailyChallenge(DateTime date) {
    return DailyChallengeService.generateDailyChallenge(date);
  }

  /// Get today's daily challenge
  LevelModel getTodaysDailyChallenge() {
    return getDailyChallenge(DateTime.now());
  }
}