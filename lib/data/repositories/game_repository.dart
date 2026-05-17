import '../models/game_state_model.dart';
import '../models/level_model.dart';
import 'level_repository.dart';
import 'user_repository.dart';

class GameRepository {
  final LevelRepository levelRepository;
  final UserRepository userRepository;

  GameRepository({
    required this.levelRepository,
    required this.userRepository,
  });

  GameStateModel createGameSession(int levelNumber) {
    final totalLevels = levelRepository.getTotalLevels();

    int safeLevelNumber = levelNumber;

    if (safeLevelNumber < 1) {
      safeLevelNumber = 1;
    }

    if (safeLevelNumber > totalLevels) {
      safeLevelNumber = totalLevels;
    }

    final level = levelRepository.getLevel(safeLevelNumber);

    if (level == null) {
      throw Exception('Level $safeLevelNumber not found');
    }

    final freshLevel = level.freshCopy();

    return GameStateModel(
      level: freshLevel,
      currentArrows: List.from(freshLevel.arrows),
      hintsRemaining: userRepository.hintsAvailable,
    );
  }

  GameStateModel createDailyChallengeSession(DateTime date) {
    final level = levelRepository.getDailyChallenge(date);
    final freshLevel = level.freshCopy();

    return GameStateModel(
      level: freshLevel,
      currentArrows: List.from(freshLevel.arrows),
      hintsRemaining: userRepository.hintsAvailable,
    );
  }

  int getCurrentLevel() {
    final totalLevels = levelRepository.getTotalLevels();
    final savedLevel = userRepository.currentLevel;

    if (savedLevel < 1) return 1;
    if (savedLevel > totalLevels) return totalLevels;

    return savedLevel;
  }

  bool hasNextLevel(int currentLevel) {
    return levelRepository.hasLevel(currentLevel + 1);
  }

  int getTotalLevels() {
    return levelRepository.getTotalLevels();
  }
}