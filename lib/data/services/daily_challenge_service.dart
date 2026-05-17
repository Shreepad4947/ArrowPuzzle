import 'dart:math';
import '../models/arrow_model.dart';
import '../models/level_model.dart';

/// Generates daily challenges using the date as a seed,
/// so all users see the same puzzle each day.
class DailyChallengeService {
  /// Generate a daily challenge for the given date.
  static LevelModel generateDailyChallenge(DateTime date) {
    final seed = date.year * 10000 + date.month * 100 + date.day;
    final random = Random(seed);

    final arrowCount = 15 + random.nextInt(11); // 15–25 arrows
    final gridSize = _calculateGridSize(arrowCount);

    return _generatePuzzle(
      arrowCount: arrowCount,
      gridRows: gridSize,
      gridCols: gridSize,
      random: random,
      levelNumber: 0,
      type: LevelType.daily,
      difficulty: LevelDifficulty.normal,
    );
  }

  static int _calculateGridSize(int arrowCount) {
    if (arrowCount <= 10) return 5;
    if (arrowCount <= 20) return 7;
    if (arrowCount <= 35) return 9;
    return 11;
  }

  /// Generate a solvable puzzle using reverse construction.
  static LevelModel _generatePuzzle({
    required int arrowCount,
    required int gridRows,
    required int gridCols,
    required Random random,
    required int levelNumber,
    required LevelType type,
    required LevelDifficulty difficulty,
  }) {
    final List<ArrowModel> arrows = [];
    final Set<String> occupiedPositions = {};

    final directions = ArrowDirection.values;

    for (int i = 0; i < arrowCount; i++) {
      int row, col;
      String posKey;
      int attempts = 0;

      // Find an unoccupied cell
      do {
        row = random.nextInt(gridRows);
        col = random.nextInt(gridCols);
        posKey = '$row,$col';
        attempts++;
        if (attempts > 100) break;
      } while (occupiedPositions.contains(posKey));

      if (attempts > 100) break;

      occupiedPositions.add(posKey);

      final ArrowDirection direction;
      if (i == 0) {
        direction = directions[random.nextInt(directions.length)];
      } else {
        direction = _findValidDirection(
          row, col, gridRows, gridCols, arrows, random,
        );
      }

      // pathPoints is optional — ArrowModel auto-generates a default path
      // based on (row, col, direction) when omitted.
      arrows.add(ArrowModel(
        id: 'arrow_$i',
        row: row,
        col: col,
        direction: direction,
      ));
    }

    // Compute the valid removal order under the free-removal rule.
    final validSolution =
        _computeSolution(List<ArrowModel>.from(arrows), gridRows, gridCols);

    return LevelModel(
      levelNumber: levelNumber,
      type: type,
      difficulty: difficulty,
      gridRows: gridRows,
      gridCols: gridCols,
      arrows: arrows,
      solutionOrder: validSolution,
    );
  }

  static ArrowDirection _findValidDirection(
    int row,
    int col,
    int gridRows,
    int gridCols,
    List<ArrowModel> existingArrows,
    Random random,
  ) {
    final directions = List<ArrowDirection>.from(ArrowDirection.values)
      ..shuffle(random);

    for (final dir in directions) {
      final offset = _getDirectionOffset(dir);
      final targetRow = row + offset.$1;
      final targetCol = col + offset.$2;

      // Prefer edge escape
      if (targetRow < 0 ||
          targetRow >= gridRows ||
          targetCol < 0 ||
          targetCol >= gridCols) {
        return dir;
      }

      // Or pointing at an existing arrow (creates a dependency chain)
      final pointsToArrow = existingArrows.any(
        (a) => a.row == targetRow && a.col == targetCol,
      );
      if (pointsToArrow) return dir;
    }

    return directions.first;
  }

  static (int, int) _getDirectionOffset(ArrowDirection direction) {
    switch (direction) {
      case ArrowDirection.up:        return (-1, 0);
      case ArrowDirection.down:      return (1, 0);
      case ArrowDirection.left:      return (0, -1);
      case ArrowDirection.right:     return (0, 1);
      case ArrowDirection.upLeft:    return (-1, -1);
      case ArrowDirection.upRight:   return (-1, 1);
      case ArrowDirection.downLeft:  return (1, -1);
      case ArrowDirection.downRight: return (1, 1);
    }
  }

  /// Compute a valid removal order using a greedy approach (free-removal rule).
  static List<String> _computeSolution(
    List<ArrowModel> arrows,
    int gridRows,
    int gridCols,
  ) {
    final solution = <String>[];
    final remaining = List<ArrowModel>.from(arrows);

    while (remaining.isNotEmpty) {
      ArrowModel? removable;

      for (final arrow in remaining) {
        if (_canBeRemoved(arrow, remaining, gridRows, gridCols)) {
          removable = arrow;
          break;
        }
      }

      if (removable != null) {
        solution.add(removable.id);
        remaining.remove(removable);
      } else {
        // Fallback: add remaining in current order (edge case safety)
        for (final arrow in remaining) {
          solution.add(arrow.id);
        }
        break;
      }
    }

    return solution;
  }

  /// An arrow can be removed if the IMMEDIATE next cell in its direction
  /// is empty (no other arrow) or off the grid.
  /// This matches the same rule used in ArrowLogic.canBeRemoved().
  static bool _canBeRemoved(
    ArrowModel arrow,
    List<ArrowModel> allArrows,
    int gridRows,
    int gridCols,
  ) {
    final offset = _getDirectionOffset(arrow.direction);
    final frontRow = arrow.row + offset.$1;
    final frontCol = arrow.col + offset.$2;

    // Off-grid → free
    if (frontRow < 0 ||
        frontRow >= gridRows ||
        frontCol < 0 ||
        frontCol >= gridCols) {
      return true;
    }

    // Blocked if another arrow sits immediately in front
    final blocked = allArrows.any(
      (a) => a.id != arrow.id && a.row == frontRow && a.col == frontCol,
    );

    return !blocked;
  }
}
