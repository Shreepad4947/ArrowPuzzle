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

enum ArrowState { active, highlighted, wrong, removing, removed }

/// Represents a point on the grid.
/// IMPORTANT: For Easybrain-style arrows, use INTEGER positions
/// so points always land exactly on matrix dots.
class GridPoint {
  final double row;
  final double col;

  const GridPoint(this.row, this.col);

  Offset toOffset(double cellSize) => Offset(
        col * cellSize + cellSize / 2,
        row * cellSize + cellSize / 2,
      );

  @override
  String toString() => 'GridPoint($row, $col)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GridPoint && row == other.row && col == other.col;

  @override
  int get hashCode => row.hashCode ^ col.hashCode;
}

enum ArrowPathType { straight, lShaped, uShaped, custom }

class ArrowModel {
  final String id;
  final int row;
  final int col;
  final ArrowDirection direction;
  final List<GridPoint> pathPoints;
  final ArrowPathType pathType;
  ArrowState state;

  ArrowModel({
    required this.id,
    required this.row,
    required this.col,
    required this.direction,
    List<GridPoint>? pathPoints,
    ArrowPathType? pathType,
    this.state = ArrowState.active,
  })  : pathType = pathType ??
            (pathPoints != null && pathPoints.length > 2
                ? ArrowPathType.lShaped
                : ArrowPathType.straight),
        pathPoints = pathPoints ?? _defaultStraightPath(row, col, direction);

  /// Default STRAIGHT path: tail and tip land on adjacent grid dots
  /// Length = 1 cell (connects two matrix dots)
  static List<GridPoint> _defaultStraightPath(
      int row, int col, ArrowDirection direction) {
    final double r = row.toDouble();
    final double c = col.toDouble();

    switch (direction) {
      case ArrowDirection.up:
        // tail at (row, col) → tip at (row-1, col)
        return [GridPoint(r, c), GridPoint(r - 1, c)];
      case ArrowDirection.down:
        return [GridPoint(r, c), GridPoint(r + 1, c)];
      case ArrowDirection.left:
        return [GridPoint(r, c), GridPoint(r, c - 1)];
      case ArrowDirection.right:
        return [GridPoint(r, c), GridPoint(r, c + 1)];
      case ArrowDirection.upLeft:
        return [GridPoint(r, c), GridPoint(r - 1, c - 1)];
      case ArrowDirection.upRight:
        return [GridPoint(r, c), GridPoint(r - 1, c + 1)];
      case ArrowDirection.downLeft:
        return [GridPoint(r, c), GridPoint(r + 1, c - 1)];
      case ArrowDirection.downRight:
        return [GridPoint(r, c), GridPoint(r + 1, c + 1)];
    }
  }

  /// L-shaped factory — bend happens AT a grid dot
  factory ArrowModel.lShaped({
    required String id,
    required int row,
    required int col,
    required ArrowDirection direction,
    required GridPoint start,
    required GridPoint bend,
    required GridPoint end,
    ArrowState state = ArrowState.active,
  }) {
    return ArrowModel(
      id: id,
      row: row,
      col: col,
      direction: direction,
      pathPoints: [start, bend, end],
      pathType: ArrowPathType.lShaped,
      state: state,
    );
  }

  ArrowModel copyWith({
    String? id,
    int? row,
    int? col,
    ArrowDirection? direction,
    List<GridPoint>? pathPoints,
    ArrowPathType? pathType,
    ArrowState? state,
  }) {
    return ArrowModel(
      id: id ?? this.id,
      row: row ?? this.row,
      col: col ?? this.col,
      direction: direction ?? this.direction,
      pathPoints: pathPoints ?? this.pathPoints,
      pathType: pathType ?? this.pathType,
      state: state ?? this.state,
    );
  }

  Offset getCenter(double cellSize) {
    if (pathPoints.isEmpty) {
      return Offset(
          col * cellSize + cellSize / 2, row * cellSize + cellSize / 2);
    }
    double tx = 0, ty = 0;
    for (final p in pathPoints) {
      final o = p.toOffset(cellSize);
      tx += o.dx;
      ty += o.dy;
    }
    return Offset(tx / pathPoints.length, ty / pathPoints.length);
  }

  Offset getTip(double cellSize) =>
      pathPoints.isEmpty ? getCenter(cellSize) : pathPoints.last.toOffset(cellSize);

  Offset getTail(double cellSize) =>
      pathPoints.isEmpty ? getCenter(cellSize) : pathPoints.first.toOffset(cellSize);

  /// Slide-out direction (based on final segment of the path)
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