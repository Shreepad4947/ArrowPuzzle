import '../data/models/arrow_model.dart';

/// Core puzzle logic for the Arrow Puzzle game.
///
/// OFFICIAL RULE (from Easybrain's Arrow Puzzle):
///   An arrow can be removed if its ENTIRE PATH from its cell to the
///   grid edge is clear — no other active arrow anywhere along that line.
///   It is NOT just the immediate next cell.
class ArrowLogic {
  ArrowLogic._();

  // ─── Core removal check ──────────────────────────────────────────────────

  /// Returns true if [arrow] can currently be removed.
  /// Walks the full path in the arrow's direction to the grid edge.
  /// If ANY active arrow occupies any cell along that path → blocked.
  static bool canBeRemoved(
    ArrowModel arrow,
    List<ArrowModel> allArrows,
    int gridRows,
    int gridCols,
  ) {
    if (arrow.state != ArrowState.active &&
        arrow.state != ArrowState.highlighted) return false;

    final offset = _getDirOffset(arrow.direction);
    int checkRow = arrow.row + offset.$1;
    int checkCol = arrow.col + offset.$2;

    // Walk every cell in the arrow's direction until we leave the grid
    while (checkRow >= 0 &&
        checkRow < gridRows &&
        checkCol >= 0 &&
        checkCol < gridCols) {
      final blocked = allArrows.any(
        (a) =>
            a.id != arrow.id &&
            (a.state == ArrowState.active ||
                a.state == ArrowState.highlighted) &&
            a.row == checkRow &&
            a.col == checkCol,
      );
      if (blocked) return false; // Something is blocking the path

      checkRow += offset.$1;
      checkCol += offset.$2;
    }

    return true; // Clear all the way to the edge
  }

  // ─── Helpers ─────────────────────────────────────────────────────────────

  /// Returns all arrows that can currently be removed.
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

  /// True when arrows remain but none can be removed (puzzle is stuck).
  static bool isStuck(
      List<ArrowModel> allArrows, int gridRows, int gridCols) {
    final active = allArrows
        .where((a) =>
            a.state == ArrowState.active || a.state == ArrowState.highlighted)
        .toList();
    if (active.isEmpty) return false;
    return findRemovableArrows(allArrows, gridRows, gridCols).isEmpty;
  }

  /// True when every arrow has been removed.
  static bool isCompleted(List<ArrowModel> allArrows) => allArrows.every(
      (a) => a.state == ArrowState.removed || a.state == ArrowState.removing);

  /// Returns a good hint arrow — prefers arrows whose path exits the board.
  static ArrowModel? getHintArrow(
    List<ArrowModel> arrows,
    int gridRows,
    int gridCols,
  ) {
    final removable = findRemovableArrows(arrows, gridRows, gridCols);
    if (removable.isEmpty) return null;

    // Prefer arrows that point directly off the board edge
    for (final arrow in removable) {
      final offset = _getDirOffset(arrow.direction);
      final nextRow = arrow.row + offset.$1;
      final nextCol = arrow.col + offset.$2;
      if (nextRow < 0 ||
          nextRow >= gridRows ||
          nextCol < 0 ||
          nextCol >= gridCols) {
        return arrow;
      }
    }

    return removable.first;
  }

  // ─── Direction offset ─────────────────────────────────────────────────────

  static (int, int) _getDirOffset(ArrowDirection d) {
    switch (d) {
      case ArrowDirection.up:        return (-1, 0);
      case ArrowDirection.down:      return (1, 0);
      case ArrowDirection.left:      return (0, -1);
      case ArrowDirection.right:     return (0, 1);
      // Diagonals kept for compatibility but not used in standard levels
      case ArrowDirection.upLeft:    return (-1, -1);
      case ArrowDirection.upRight:   return (-1, 1);
      case ArrowDirection.downLeft:  return (1, -1);
      case ArrowDirection.downRight: return (1, 1);
    }
  }
}
