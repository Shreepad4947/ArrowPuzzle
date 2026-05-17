import 'dart:math';
import '../models/arrow_model.dart';
import '../models/level_model.dart';

/// Generates daily challenges using the date as a seed,
/// so every user sees the same puzzle each day.
///
/// Uses the CORRECT full-path rule:
///   An arrow can be removed only if its ENTIRE PATH to the grid
///   edge is clear (no active arrow anywhere along that line).
class DailyChallengeService {
  static LevelModel generateDailyChallenge(DateTime date) {
    final seed = date.year * 10000 + date.month * 100 + date.day;
    final random = Random(seed);

    final arrowCount = 12 + random.nextInt(9); // 12–20 arrows
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
    if (arrowCount <= 9)  return 4;
    if (arrowCount <= 16) return 5;
    if (arrowCount <= 25) return 6;
    return 7;
  }

  /// Builds a solvable puzzle using reverse construction:
  /// Start from an empty grid and place arrows one by one, each time
  /// ensuring the puzzle remains solvable.
  static LevelModel _generatePuzzle({
    required int arrowCount,
    required int gridRows,
    required int gridCols,
    required Random random,
    required int levelNumber,
    required LevelType type,
    required LevelDifficulty difficulty,
  }) {
    // Only 4 cardinal directions (matching Easybrain style)
    const directions = [
      ArrowDirection.up,
      ArrowDirection.down,
      ArrowDirection.left,
      ArrowDirection.right,
    ];

    final List<ArrowModel> arrows = [];
    final Set<String> occupied = {};
    int idCounter = 0;

    for (int attempt = 0; attempt < arrowCount * 10 && arrows.length < arrowCount; attempt++) {
      final row = random.nextInt(gridRows);
      final col = random.nextInt(gridCols);
      final posKey = '$row,$col';
      if (occupied.contains(posKey)) continue;

      // Pick a direction that either points to edge or to an existing arrow
      final dir = _pickDirection(row, col, gridRows, gridCols, arrows, random, directions);

      final arrow = ArrowModel(
        id: 'dc_${idCounter++}',
        row: row,
        col: col,
        direction: dir,
      );

      // Only add if the puzzle stays solvable
      final testArrows = [...arrows, arrow];
      if (_isSolvable(testArrows, gridRows, gridCols)) {
        arrows.add(arrow);
        occupied.add(posKey);
      }
    }

    // Compute a valid removal order
    final solution = _computeSolution(List<ArrowModel>.from(arrows), gridRows, gridCols);

    return LevelModel(
      levelNumber: levelNumber,
      type: type,
      difficulty: difficulty,
      gridRows: gridRows,
      gridCols: gridCols,
      arrows: arrows,
      solutionOrder: solution,
    );
  }

  static ArrowDirection _pickDirection(
    int row, int col, int gridRows, int gridCols,
    List<ArrowModel> existingArrows, Random random,
    List<ArrowDirection> directions,
  ) {
    final shuffled = List<ArrowDirection>.from(directions)..shuffle(random);

    // Prefer directions pointing to an edge (easiest to remove initially)
    for (final dir in shuffled) {
      final offset = _offset(dir);
      final nr = row + offset.$1;
      final nc = col + offset.$2;
      if (nr < 0 || nr >= gridRows || nc < 0 || nc >= gridCols) return dir;
    }

    // Then prefer directions whose full path is currently clear
    for (final dir in shuffled) {
      if (_canBeRemoved(
          ArrowModel(id: '_test', row: row, col: col, direction: dir),
          existingArrows, gridRows, gridCols)) {
        return dir;
      }
    }

    return shuffled.first;
  }

  // ── Full-path removal check (matches ArrowLogic exactly) ─────────────────

  static bool _canBeRemoved(
    ArrowModel arrow,
    List<ArrowModel> allArrows,
    int gridRows,
    int gridCols,
  ) {
    final off = _offset(arrow.direction);
    int r = arrow.row + off.$1;
    int c = arrow.col + off.$2;

    while (r >= 0 && r < gridRows && c >= 0 && c < gridCols) {
      if (allArrows.any((a) => a.id != arrow.id && a.row == r && a.col == c)) {
        return false;
      }
      r += off.$1;
      c += off.$2;
    }
    return true;
  }

  static List<ArrowModel> _findRemovable(
      List<ArrowModel> arrows, int gridRows, int gridCols) {
    return arrows.where((a) => _canBeRemoved(a, arrows, gridRows, gridCols)).toList();
  }

  static bool _isSolvable(List<ArrowModel> arrows, int gridRows, int gridCols) {
    return _dfs(List<ArrowModel>.from(arrows), gridRows, gridCols);
  }

  static bool _dfs(List<ArrowModel> arrows, int gridRows, int gridCols) {
    if (arrows.isEmpty) return true;
    final removable = _findRemovable(arrows, gridRows, gridCols);
    if (removable.isEmpty) return false;
    for (final a in removable) {
      final next = arrows.where((x) => x.id != a.id).toList();
      if (_dfs(next, gridRows, gridCols)) return true;
    }
    return false;
  }

  static List<String> _computeSolution(
      List<ArrowModel> arrows, int gridRows, int gridCols) {
    final solution = <String>[];
    final remaining = List<ArrowModel>.from(arrows);

    while (remaining.isNotEmpty) {
      final removable = _findRemovable(remaining, gridRows, gridCols);
      if (removable.isEmpty) {
        // Fallback — add remaining in order (shouldn't happen if solvable)
        solution.addAll(remaining.map((a) => a.id));
        break;
      }
      final pick = removable.first;
      solution.add(pick.id);
      remaining.removeWhere((a) => a.id == pick.id);
    }

    return solution;
  }

  static (int, int) _offset(ArrowDirection d) {
    switch (d) {
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
}
