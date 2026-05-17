import '../data/models/arrow_model.dart';
import '../data/models/level_model.dart';
import 'arrow_logic.dart';

/// Validates levels are solvable under the official full-path-clear rule.
/// Uses DFS to verify at least one valid removal order exists.
class LevelValidator {
  LevelValidator._();

  static bool isSolvable(LevelModel level) {
    final arrows =
        level.arrows.map((a) => a.copyWith(state: ArrowState.active)).toList();
    return _dfs(arrows, level.gridRows, level.gridCols);
  }

  static bool _dfs(List<ArrowModel> arrows, int gridRows, int gridCols) {
    if (ArrowLogic.isCompleted(arrows)) return true;
    final removable = ArrowLogic.findRemovableArrows(arrows, gridRows, gridCols);
    if (removable.isEmpty) return false;
    for (final arrow in removable) {
      final next = List<ArrowModel>.from(arrows);
      final idx = next.indexWhere((a) => a.id == arrow.id);
      next[idx] = next[idx].copyWith(state: ArrowState.removed);
      if (_dfs(next, gridRows, gridCols)) return true;
    }
    return false;
  }

  static Map<int, bool> validateAllLevels(List<LevelModel> levels) {
    return {for (final l in levels) l.levelNumber: isSolvable(l)};
  }
}
