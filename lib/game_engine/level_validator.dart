import '../data/models/arrow_model.dart';
import '../data/models/level_model.dart';
import 'arrow_logic.dart';

/// Validates that a level is solvable under the FREE-REMOVAL rule:
/// any arrow whose path is clear (nothing blocking in front) may be removed.
/// The validator uses DFS to confirm at least ONE valid removal order exists.
class LevelValidator {
  LevelValidator._();

  /// Returns true if the level can be fully cleared under the free-removal rule.
  static bool isSolvable(LevelModel level) {
    final arrows =
        level.arrows.map((a) => a.copyWith(state: ArrowState.active)).toList();
    return _dfs(arrows, level.gridRows, level.gridCols);
  }

  static bool _dfs(
      List<ArrowModel> arrows, int gridRows, int gridCols) {
    // All removed → solved
    if (ArrowLogic.isCompleted(arrows)) return true;

    final removable =
        ArrowLogic.findRemovableArrows(arrows, gridRows, gridCols);

    if (removable.isEmpty) return false; // stuck

    for (final arrow in removable) {
      final next = List<ArrowModel>.from(arrows);
      final idx = next.indexWhere((a) => a.id == arrow.id);
      next[idx] = next[idx].copyWith(state: ArrowState.removed);

      if (_dfs(next, gridRows, gridCols)) return true;
    }

    return false;
  }

  /// Validate all levels, returns map of levelNumber → isSolvable
  static Map<int, bool> validateAllLevels(List<LevelModel> levels) {
    return {
      for (final level in levels) level.levelNumber: isSolvable(level),
    };
  }
}
