import '../data/models/arrow_model.dart';

class ArrowLogic {
  ArrowLogic._();

  /// CORRECT RULE: An arrow can be removed if it does NOT point 
  /// directly at another active arrow (in adjacent position)
  /// OR if it points toward the edge/empty space
  ///
  /// This allows for branching paths and free ends to be removed
  static bool canBeRemoved(
    ArrowModel arrow,
    List<ArrowModel> allArrows,
    int gridRows,
    int gridCols,
  ) {
    if (arrow.state != ArrowState.active) return false;

    // Get what's immediately in front of this arrow
    final offset = _getDirOffset(arrow.direction);
    final frontRow = arrow.row + offset.$1;
    final frontCol = arrow.col + offset.$2;

    // Check bounds
    if (frontRow < 0 || frontRow >= gridRows || 
        frontCol < 0 || frontCol >= gridCols) {
      // Points outside grid -> CAN remove (points to edge)
      return true;
    }

    // Check if another ACTIVE arrow sits directly in front
    final blockerExists = allArrows.any((a) =>
        a.id != arrow.id &&
        a.state == ArrowState.active &&
        a.row == frontRow &&
        a.col == frontCol);

    // If blocked by another arrow -> CANNOT remove yet
    // If clear -> CAN remove
    return !blockerExists;
  }

  /// Find all currently removable arrows (free ends)
  static List<ArrowModel> findRemovableArrows(
    List<ArrowModel> allArrows,
    int gridRows,
    int gridCols,
  ) {
    return allArrows
        .where((a) => a.state == ArrowState.active)
        .where((a) => canBeRemoved(a, allArrows, gridRows, gridCols))
        .toList();
  }

  /// Check stuck state (no moves available but arrows remain)
  static bool isStuck(List<ArrowModel> allArrows, int gridRows, int gridCols) {
    final activeCount = allArrows.where((a) => a.state == ArrowState.active).length;
    if (activeCount == 0) return false; // Completed, not stuck
    return findRemovableArrows(allArrows, gridRows, gridCols).isEmpty;
  }

  static bool isCompleted(List<ArrowModel> allArrows) =>
      allArrows.every((a) => a.state != ArrowState.active);

  /// Get hint - find any removable arrow (prefer those at end of paths)
  static ArrowModel? getHintArrow(List<ArrowModel> arrows) {
    final removable = arrows.where((a) => a.state == ArrowState.active).toList();
    
    // Simple heuristic: prefer arrows that are "leaf nodes" (fewer neighbors)
    // For now, just return the first removable found via detailed scan
    for (final arrow in removable) {
      final blockers = _countBlockersInAllDirections(arrow, arrows);
      // Leaf node (only 0-1 neighbors) is likely the end of a path
      if (blockers <= 1) {
        return arrow;
      }
    }
    
    // Fallback
    return removable.isNotEmpty ? removable.first : null;
  }

  static int _countBlockersInAllDirections(ArrowModel arrow, List<ArrowModel> all) {
    int count = 0;
    for (final dir in ArrowDirection.values) {
      final offset = _getDirOffset(dir);
      final r = arrow.row + offset.$1;
      final c = arrow.col + offset.$2;
      if (anyActiveAt(r, c, all, arrow.id)) count++;
    }
    return count;
  }

  static bool anyActiveAt(int r, int c, List<ArrowModel> all, String excludeId) {
    return any((ArrowModel a) => a.id != excludeId && a.state == ArrowState.active && a.row == r && a.col == c);
  }

  static (int, int) _getDirOffset(ArrowDirection d) {
    switch (d) {
      case ArrowDirection.up: return (-1, 0);
      case ArrowDirection.down: return (1, 0);
      case ArrowDirection.left: return (0, -1);
      case ArrowDirection.right: return (0, 1);
      case ArrowDirection.upLeft: return (-1, -1);
      case ArrowDirection.upRight: return (-1, 1);
      case ArrowDirection.downLeft: return (1, -1);
      case ArrowDirection.downRight: return (1, 1);
    }
  }
}