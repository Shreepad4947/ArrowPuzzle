import '../models/level_model.dart';
import 'level_1.dart';
import 'level_2.dart';
import 'level_3.dart';

class LevelData {
  LevelData._();

  static List<LevelModel> get allLevels => [
        Level1.data,
        Level2.data,
        Level3.data,
      ];

  static int get totalLevels => allLevels.length;

  static LevelModel? getLevel(int levelNumber) {
    if (levelNumber < 1 || levelNumber > allLevels.length) {
      return null;
    }
    return allLevels[levelNumber - 1];
  }

  static bool hasLevel(int levelNumber) {
    return levelNumber >= 1 && levelNumber <= allLevels.length;
  }

  static int? getNextLevelNumber(int currentLevel) {
    if (currentLevel < allLevels.length) {
      return currentLevel + 1;
    }
    return null;
  }
}