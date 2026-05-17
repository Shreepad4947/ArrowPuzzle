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

/// A point in the puzzle matrix/grid.
/// This is used to draw maze-like arrows as paths.
class GridPoint {
  final double row;
  final double col;

  const GridPoint(this.row, this.col);

  Offset toOffset(double cellSize) {
    return Offset(
      col * cellSize + cellSize / 2,
      row * cellSize + cellSize / 2,
    );
  }
}

class ArrowModel {
  final String id;

  /// Main logical position. Kept for compatibility.
  final int row;
  final int col;

  final ArrowDirection direction;

  /// Path points used to draw maze-style arrows.
  /// Example:
  /// [
  ///   GridPoint(3, 0),
  ///   GridPoint(0, 0),
  ///   GridPoint(0, 2),
  /// ]
  ///
  /// This draws an L-shaped arrow.
  final List<GridPoint> pathPoints;

  ArrowState state;

  ArrowModel({
    required this.id,
    required this.row,
    required this.col,
    required this.direction,
    List<GridPoint>? pathPoints,
    this.state = ArrowState.active,
  }) : pathPoints = pathPoints ?? _defaultPath(row, col, direction);

  static List<GridPoint> _defaultPath(
    int row,
    int col,
    ArrowDirection direction,
  ) {
    switch (direction) {
      case ArrowDirection.up:
        return [
          GridPoint(row + 0.6, col.toDouble()),
          GridPoint(row - 0.6, col.toDouble()),
        ];
      case ArrowDirection.down:
        return [
          GridPoint(row - 0.6, col.toDouble()),
          GridPoint(row + 0.6, col.toDouble()),
        ];
      case ArrowDirection.left:
        return [
          GridPoint(row.toDouble(), col + 0.6),
          GridPoint(row.toDouble(), col - 0.6),
        ];
      case ArrowDirection.right:
        return [
          GridPoint(row.toDouble(), col - 0.6),
          GridPoint(row.toDouble(), col + 0.6),
        ];
      case ArrowDirection.upLeft:
        return [
          GridPoint(row + 0.5, col + 0.5),
          GridPoint(row - 0.5, col - 0.5),
        ];
      case ArrowDirection.upRight:
        return [
          GridPoint(row + 0.5, col - 0.5),
          GridPoint(row - 0.5, col + 0.5),
        ];
      case ArrowDirection.downLeft:
        return [
          GridPoint(row - 0.5, col + 0.5),
          GridPoint(row + 0.5, col - 0.5),
        ];
      case ArrowDirection.downRight:
        return [
          GridPoint(row - 0.5, col - 0.5),
          GridPoint(row + 0.5, col + 0.5),
        ];
    }
  }

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

  Offset getCenter(double cellSize) {
    if (pathPoints.isEmpty) {
      return Offset(
        col * cellSize + cellSize / 2,
        row * cellSize + cellSize / 2,
      );
    }

    double totalX = 0;
    double totalY = 0;

    for (final point in pathPoints) {
      final offset = point.toOffset(cellSize);
      totalX += offset.dx;
      totalY += offset.dy;
    }

    return Offset(
      totalX / pathPoints.length,
      totalY / pathPoints.length,
    );
  }

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