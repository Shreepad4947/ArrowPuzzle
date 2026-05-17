import '../data/models/arrow_model.dart';
import '../data/models/level_model.dart';
import 'arrow_logic.dart';

/// Validates that a level is solvable and the solution is correct
class LevelValidator {
  LevelValidator._();

  /// Validate that the given solution order actually works
  static bool validateSolution(LevelModel level) {
    final arrows =
        level.arrows.map((a) => a.copyWith(state: ArrowState.active)).toList();

    for (final arrowId in level.solutionOrder) {
      // Find the arrow
      final arrowIndex = arrows.indexWhere((a) => a.id == arrowId);
      if (arrowIndex == -1) return false;

      final arrow = arrows[arrowIndex];

      // Check if it can be removed
      if (!ArrowLogic.canBeRemoved(
        arrow,
        arrows,
        level.gridRows,
        level.gridCols,
      )) {
        return false; // Solution step is invalid
      }

      // Remove it
      arrows[arrowIndex] = arrow.copyWith(state: ArrowState.removed);
    }

    // Check all arrows are removed
    return ArrowLogic.isCompleted(arrows);
  }

  /// Check if a level has at least one valid solution
  static bool isSolvable(LevelModel level) {
    return validateSolution(level);
  }

  /// Validate all levels
  static Map<int, bool> validateAllLevels(List<LevelModel> levels) {
    final results = <int, bool>{};
    for (final level in levels) {
      results[level.levelNumber] = validateSolution(level);
    }
    return results;
  }
}