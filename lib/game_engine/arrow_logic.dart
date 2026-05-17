import '../data/models/arrow_model.dart';

/// Core puzzle logic for the Arrow Puzzle game.
class ArrowLogic {
  ArrowLogic._();

  // ─── Core removal check ──────────────────────────────────────────────────

  /// Returns true if [arrow] can currently be removed.
  /// An arrow escapes starting from its TIP (the last point in pathPoints)
  /// in its [direction].
  static bool canBeRemoved(
    ArrowModel arrow,
    List<ArrowModel> allArrows,
    int gridRows,
    int gridCols,
  ) {
    if (arrow.state != ArrowState.active &&
        arrow.state != ArrowState.highlighted) return false;

    final offset = _getDirOffset(arrow.direction);

    // The tip is the last point in pathPoints
    if (arrow.pathPoints.isEmpty) return false;
    final GridPoint tip = arrow.pathPoints.last;

    int checkRow = tip.row.toInt() + offset.$1;
    int checkCol = tip.col.toInt() + offset.$2;

    // Check every cell in the escape direction from the tip to the edge
    while (checkRow >= 0 &&
        checkRow < gridRows &&
        checkCol >= 0 &&
        checkCol < gridCols) {
      final int r = checkRow;
      final int c = checkCol;

      // Check if this cell is occupied by ANY segment of ANY OTHER active arrow
      final bool blocked = allArrows.any((other) {
        if (other.id == arrow.id) return false;
        if (other.state != ArrowState.active &&
            other.state != ArrowState.highlighted) return false;

        // Check if ANY point in the other arrow's path matches this cell
        return other.pathPoints.any((p) => p.row.toInt() == r && p.col.toInt() == c);
      });

      if (blocked) return false;

      checkRow += offset.$1;
      checkCol += offset.$2;
    }

    return true; // Path is clear
  }

  // ─── Helpers ─────────────────────────────────────────────────────────────

  static List<ArrowModel> findRemovableArrows(
    List<ArrowModel> allArrows,
    int gridRows,
    int gridCols,
  ) {
    return allArrows
        .where((a) =>
            a.state == ArrowState.active || a.state == ArrowState.highlighted)
        .where((a) => canBeRemoved(a, allArrows, gridRows, gridCols))
        .toList();
  }

  static bool isStuck(List<ArrowModel> allArrows, int gridRows, int gridCols) {
    final active = allArrows
        .where((a) =>
            a.state == ArrowState.active || a.state == ArrowState.highlighted)
        .toList();
    if (active.isEmpty) return false;
    return findRemovableArrows(allArrows, gridRows, gridCols).isEmpty;
  }

  static bool isCompleted(List<ArrowModel> allArrows) => allArrows.every(
      (a) => a.state == ArrowState.removed || a.state == ArrowState.removing);

  static ArrowModel? getHintArrow(
    List<ArrowModel> arrows,
    int gridRows,
    int gridCols,
  ) {
    final removable = findRemovableArrows(arrows, gridRows, gridCols);
    if (removable.isEmpty) return null;
    return removable.first;
  }

  static (int, int) _getDirOffset(ArrowDirection d) {
    switch (d) {
      case ArrowDirection.up:
        return (-1, 0);
      case ArrowDirection.down:
        return (1, 0);
      case ArrowDirection.left:
        return (0, -1);
      case ArrowDirection.right:
        return (0, 1);
      case ArrowDirection.upLeft:
        return (-1, -1);
      case ArrowDirection.upRight:
        return (-1, 1);
      case ArrowDirection.downLeft:
        return (1, -1);
      case ArrowDirection.downRight:
        return (1, 1);
    }
  }
}
