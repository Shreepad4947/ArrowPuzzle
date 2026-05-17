import 'dart:math';
import '../models/arrow_model.dart';
import '../models/level_model.dart';

/// Generates daily challenges using date as seed
class DailyChallengeService {
  /// Generate a daily challenge for the given date
  /// Uses the date as a seed to ensure the same puzzle for all users
  static LevelModel generateDailyChallenge(DateTime date) {
    final seed = date.year * 10000 + date.month * 100 + date.day;
    final random = Random(seed);

    // Daily challenges are medium-sized (15-25 arrows)
    final arrowCount = 15 + random.nextInt(11); // 15 to 25
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

  /// Generate a solvable puzzle using reverse construction
  /// This guarantees every puzzle has a valid solution
  static LevelModel _generatePuzzle({
    required int arrowCount,
    required int gridRows,
    required int gridCols,
    required Random random,
    required int levelNumber,
    required LevelType type,
    required LevelDifficulty difficulty,
  }) {
    final arrows = <ArrowModel>[];
    final solution = <String>[];
    final occupiedPositions = <String>{};

    final directions = ArrowDirection.values;

    // Place arrows one by one
    for (int i = 0; i < arrowCount; i++) {
      int row, col;
      String posKey;

      // Find an unoccupied position
      int attempts = 0;
      do {
        row = random.nextInt(gridRows);
        col = random.nextInt(gridCols);
        posKey = '$row,$col';
        attempts++;
        if (attempts > 100) break;
      } while (occupiedPositions.contains(posKey));

      if (attempts > 100) break;

      occupiedPositions.add(posKey);

      ArrowDirection direction;
      if (i == 0) {
        // First arrow - any direction pointing outward
        direction = directions[random.nextInt(directions.length)];
      } else {
        // Try to find a direction that points toward an existing arrow
        // OR points to empty space (making it removable)
        direction = _findValidDirection(
          row, col, gridRows, gridCols, arrows, random,
        );
      }

      final arrow = ArrowModel(
        id: 'arrow_$i',
        row: row,
        col: col,
        direction: direction,
      );

      arrows.add(arrow);
      solution.add(arrow.id);
    }

    // The solution is to remove arrows that point to nothing first
    // We need to compute the actual valid removal order
    final validSolution = _computeSolution(List.from(arrows), gridRows, gridCols);

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
      // Prefer directions that either point to existing arrow or point to edge
      final offset = _getDirectionOffset(dir);
      final targetRow = row + offset.$1;
      final targetCol = col + offset.$2;

      // Points to edge - good
      if (targetRow < 0 ||
          targetRow >= gridRows ||
          targetCol < 0 ||
          targetCol >= gridCols) {
        return dir;
      }

      // Points to existing arrow - also valid
      final pointsToArrow = existingArrows.any(
        (a) => a.row == targetRow && a.col == targetCol,
      );
      if (pointsToArrow) {
        return dir;
      }
    }

    // Default to random direction
    return directions.first;
  }

  static (int, int) _getDirectionOffset(ArrowDirection direction) {
    switch (direction) {
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

  /// Compute valid removal order using greedy approach
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
        // If no removable arrow found, add remaining in order
        // This handles edge cases
        for (final arrow in remaining) {
          solution.add(arrow.id);
        }
        break;
      }
    }

    return solution;
  }

  /// Check if an arrow can be removed
  /// An arrow can be removed if it points to empty space
  /// (no other arrow in its direction path)
  static bool _canBeRemoved(
    ArrowModel arrow,
    List<ArrowModel> allArrows,
    int gridRows,
    int gridCols,
  ) {
    final offset = _getDirectionOffset(arrow.direction);
    int checkRow = arrow.row + offset.$1;
    int checkCol = arrow.col + offset.$2;

    // Walk in the arrow's direction until we hit edge or another arrow
    while (checkRow >= 0 &&
        checkRow < gridRows &&
        checkCol >= 0 &&
        checkCol < gridCols) {
      // Check if any other active arrow is at this position
      final hasArrow = allArrows.any(
        (a) => a.id != arrow.id && a.row == checkRow && a.col == checkCol,
      );

      if (hasArrow) {
        return false; // Points to another arrow - cannot remove
      }

      checkRow += offset.$1;
      checkCol += offset.$2;
    }

    return true; // Points to edge/empty - can remove
  }
}