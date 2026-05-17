import '../data/models/arrow_model.dart';

class ArrowLogic {
  ArrowLogic._();

  /// CORE RULE: An arrow can be removed if the cell it is pointing AT
  /// (the very next cell in its direction) does NOT contain another active arrow.
  /// If it points outside the grid, it is also free (edge escape).
  static bool canBeRemoved(
    ArrowModel arrow,
    List<ArrowModel> allArrows,
    int gridRows,
    int gridCols,
  ) {
    if (arrow.state != ArrowState.active &&
        arrow.state != ArrowState.highlighted) return false;

    final offset = _getDirOffset(arrow.direction);
    final frontRow = arrow.row + offset.$1;
    final frontCol = arrow.col + offset.$2;

    // Points outside grid → free to remove (escapes the board)
    if (frontRow < 0 ||
        frontRow >= gridRows ||
        frontCol < 0 ||
        frontCol >= gridCols) {
      return true;
    }

    // Check if another ACTIVE arrow sits directly in the target cell
    final blockerExists = allArrows.any(
      (a) =>
          a.id != arrow.id &&
          (a.state == ArrowState.active ||
              a.state == ArrowState.highlighted) &&
          a.row == frontRow &&
          a.col == frontCol,
    );

    return !blockerExists; // can remove only if nothing blocks
  }

  /// All currently removable arrows (clear-path arrows)
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

  /// True when arrows still remain but none can be removed
  static bool isStuck(
      List<ArrowModel> allArrows, int gridRows, int gridCols) {
    final active = allArrows
        .where((a) =>
            a.state == ArrowState.active || a.state == ArrowState.highlighted)
        .toList();
    if (active.isEmpty) return false;
    return findRemovableArrows(allArrows, gridRows, gridCols).isEmpty;
  }

  static bool isCompleted(List<ArrowModel> allArrows) =>
      allArrows.every((a) =>
          a.state == ArrowState.removed || a.state == ArrowState.removing);

  /// Hint: return the first removable arrow
  static ArrowModel? getHintArrow(
    List<ArrowModel> arrows,
    int gridRows,
    int gridCols,
  ) {
    final removable = findRemovableArrows(arrows, gridRows, gridCols);
    if (removable.isEmpty) return null;

    // Prefer arrows that escape the board (point to edge)
    for (final arrow in removable) {
      final offset = _getDirOffset(arrow.direction);
      final fr = arrow.row + offset.$1;
      final fc = arrow.col + offset.$2;
      if (fr < 0 || fr >= gridRows || fc < 0 || fc >= gridCols) {
        return arrow;
      }
    }

    return removable.first;
  }

  static (int, int) _getDirOffset(ArrowDirection d) {
    switch (d) {
      case ArrowDirection.up:       return (-1, 0);
      case ArrowDirection.down:     return (1, 0);
      case ArrowDirection.left:     return (0, -1);
      case ArrowDirection.right:    return (0, 1);
      case ArrowDirection.upLeft:   return (-1, -1);
      case ArrowDirection.upRight:  return (-1, 1);
      case ArrowDirection.downLeft: return (1, -1);
      case ArrowDirection.downRight:return (1, 1);
    }
  }
}
