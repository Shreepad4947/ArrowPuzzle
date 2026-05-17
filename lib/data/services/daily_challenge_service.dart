import 'dart:math';
import '../models/arrow_model.dart';
import '../models/level_model.dart';

class DailyChallengeService {
  static LevelModel generateDailyChallenge(DateTime date) {
    final seed = date.year * 10000 + date.month * 100 + date.day;
    final random = Random(seed);

    const int rows = 4;
    const int cols = 4;

    return _generatePuzzle(
      gridRows: rows,
      gridCols: cols,
      random: random,
      levelNumber: 0,
      type: LevelType.daily,
      difficulty: LevelDifficulty.normal,
    );
  }

  static LevelModel _generatePuzzle({
    required int gridRows,
    required int gridCols,
    required Random random,
    required int levelNumber,
    required LevelType type,
    required LevelDifficulty difficulty,
  }) {
    final List<ArrowModel> arrows = [];
    final Set<(int, int)> visited = {};
    int idCounter = 0;

    final List<(int, int)> allPoints = [];
    for (int r = 0; r < gridRows; r++) {
      for (int c = 0; c < gridCols; c++) {
        allPoints.add((r, c));
      }
    }
    allPoints.shuffle(random);

    for (final startPoint in allPoints) {
      if (visited.contains(startPoint)) continue;

      final List<GridPoint> path = [
        GridPoint(startPoint.$1.toDouble(), startPoint.$2.toDouble())
      ];
      visited.add(startPoint);

      int targetLength = 1 + random.nextInt(4);
      while (path.length < targetLength) {
        final last = path.last;
        final neighbors = _getUnvisitedNeighbors(
            (last.row.toInt(), last.col.toInt()), visited, gridRows, gridCols);
        if (neighbors.isEmpty) break;

        final next = neighbors[random.nextInt(neighbors.length)];
        path.add(GridPoint(next.$1.toDouble(), next.$2.toDouble()));
        visited.add(next);
      }

      final dir = ArrowDirection.values[random.nextInt(4)];

      arrows.add(ArrowModel(
        id: 'dc_${idCounter++}',
        row: startPoint.$1,
        col: startPoint.$2,
        direction: dir,
        pathPoints: path,
      ));
    }

    final solution = arrows.map((a) => a.id).toList();

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

  static List<(int, int)> _getUnvisitedNeighbors(
      (int, int) p, Set<(int, int)> visited, int rows, int cols) {
    final List<(int, int)> res = [];
    final potentials = [
      (p.$1 - 1, p.$2),
      (p.$1 + 1, p.$2),
      (p.$1, p.$2 - 1),
      (p.$1, p.$2 + 1)
    ];
    for (final pt in potentials) {
      if (pt.$1 >= 0 &&
          pt.$1 < rows &&
          pt.$2 >= 0 &&
          pt.$2 < cols &&
          !visited.contains(pt)) {
        res.add(pt);
      }
    }
    return res;
  }
}
