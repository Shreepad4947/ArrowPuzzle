import 'package:flutter/material.dart';

enum ArrowDirection {
  up,
  down,
  left,
  right,
  upLeft,
  upRight,
  downLeft,
  downRight,
}

enum ArrowState {
  active,
  highlighted,
  wrong,
  removing,
  removed,
}

/// A single point in the puzzle grid used to draw maze-style arrow paths.
/// [row] and [col] are fractional grid coordinates (e.g. 1.5 = mid-cell).
class GridPoint {
  final double row;
  final double col;

  const GridPoint(this.row, this.col);

  /// Converts to a canvas [Offset] given [cellSize].
  Offset toOffset(double cellSize) {
    return Offset(
      col * cellSize + cellSize / 2,
      row * cellSize + cellSize / 2,
    );
  }
}

class ArrowModel {
  final String id;

  /// Logical grid position of the arrow (integer cell).
  final int row;
  final int col;

  final ArrowDirection direction;

  /// Path points used to draw maze-style arrows.
  /// Must have at least 2 points (tail → head).
  final List<GridPoint> pathPoints;

  // NOTE: state is non-final so it can be mutated during gameplay,
  // therefore the constructor is NOT const. Use ArrowModel(...) normally.
  ArrowState state;

  ArrowModel({
    required this.id,
    required this.row,
    required this.col,
    required this.direction,
    List<GridPoint>? pathPoints,       // optional — auto-generated if omitted
    this.state = ArrowState.active,
  }) : pathPoints = pathPoints ?? _defaultPath(row, col, direction);

  // ── Default single-cell path based on direction ───────────────────────────

  static List<GridPoint> _defaultPath(
      int row, int col, ArrowDirection direction) {
    switch (direction) {
      case ArrowDirection.up:
        return [
          GridPoint(row + 0.4, col.toDouble()),
          GridPoint(row - 0.4, col.toDouble()),
        ];
      case ArrowDirection.down:
        return [
          GridPoint(row - 0.4, col.toDouble()),
          GridPoint(row + 0.4, col.toDouble()),
        ];
      case ArrowDirection.left:
        return [
          GridPoint(row.toDouble(), col + 0.4),
          GridPoint(row.toDouble(), col - 0.4),
        ];
      case ArrowDirection.right:
        return [
          GridPoint(row.toDouble(), col - 0.4),
          GridPoint(row.toDouble(), col + 0.4),
        ];
      case ArrowDirection.upLeft:
        return [
          GridPoint(row + 0.4, col + 0.4),
          GridPoint(row - 0.4, col - 0.4),
        ];
      case ArrowDirection.upRight:
        return [
          GridPoint(row + 0.4, col - 0.4),
          GridPoint(row - 0.4, col + 0.4),
        ];
      case ArrowDirection.downLeft:
        return [
          GridPoint(row - 0.4, col + 0.4),
          GridPoint(row + 0.4, col - 0.4),
        ];
      case ArrowDirection.downRight:
        return [
          GridPoint(row - 0.4, col - 0.4),
          GridPoint(row + 0.4, col + 0.4),
        ];
    }
  }

  // ── copyWith ──────────────────────────────────────────────────────────────

  ArrowModel copyWith({
    String? id,
    int? row,
    int? col,
    ArrowDirection? direction,
    List<GridPoint>? pathPoints,
    ArrowState? state,
  }) {
    return ArrowModel(
      id: id ?? this.id,
      row: row ?? this.row,
      col: col ?? this.col,
      direction: direction ?? this.direction,
      pathPoints: pathPoints ?? this.pathPoints,
      state: state ?? this.state,
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  /// Centre of the arrow for touch detection / tutorial pointer.
  Offset getCenter(double cellSize) {
    if (pathPoints.isEmpty) {
      return Offset(
        col * cellSize + cellSize / 2,
        row * cellSize + cellSize / 2,
      );
    }
    double tx = 0, ty = 0;
    for (final p in pathPoints) {
      final o = p.toOffset(cellSize);
      tx += o.dx;
      ty += o.dy;
    }
    return Offset(tx / pathPoints.length, ty / pathPoints.length);
  }

  /// Unit vector in the arrow's direction (used for slide-out animation).
  Offset get directionOffset {
    switch (direction) {
      case ArrowDirection.up:
        return const Offset(0, -1);
      case ArrowDirection.down:
        return const Offset(0, 1);
      case ArrowDirection.left:
        return const Offset(-1, 0);
      case ArrowDirection.right:
        return const Offset(1, 0);
      case ArrowDirection.upLeft:
        return const Offset(-0.707, -0.707);
      case ArrowDirection.upRight:
        return const Offset(0.707, -0.707);
      case ArrowDirection.downLeft:
        return const Offset(-0.707, 0.707);
      case ArrowDirection.downRight:
        return const Offset(0.707, 0.707);
    }
  }

  double get rotationAngle {
    switch (direction) {
      case ArrowDirection.up:
        return -3.14159 / 2;
      case ArrowDirection.down:
        return 3.14159 / 2;
      case ArrowDirection.left:
        return 3.14159;
      case ArrowDirection.right:
        return 0;
      case ArrowDirection.upLeft:
        return -3.14159 * 3 / 4;
      case ArrowDirection.upRight:
        return -3.14159 / 4;
      case ArrowDirection.downLeft:
        return 3.14159 * 3 / 4;
      case ArrowDirection.downRight:
        return 3.14159 / 4;
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArrowModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
