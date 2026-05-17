import '../models/arrow_model.dart';
import '../models/level_model.dart';

class Level2 {
  static LevelModel get data => LevelModel(
        levelNumber: 2,
        type: LevelType.regular,
        difficulty: LevelDifficulty.normal,
        gridRows: 3,
        gridCols: 3,
        arrows: [
          // Snake 1: Winding path. Tip at (2,0) escapes Down.
          ArrowModel(
            id: 'L2_S1',
            row: 0,
            col: 0,
            direction: ArrowDirection.down,
            pathPoints: [
              const GridPoint(0, 0),
              const GridPoint(0, 1),
              const GridPoint(1, 1),
              const GridPoint(1, 0),
              const GridPoint(2, 0),
            ],
          ),
          // Snake 2: L-shape. Tip at (2,1) escapes Left.
          // Blocked by S1 at (2,0).
          ArrowModel(
            id: 'L2_S2',
            row: 0,
            col: 2,
            direction: ArrowDirection.left,
            pathPoints: [
              const GridPoint(0, 2),
              const GridPoint(1, 2),
              const GridPoint(2, 2),
              const GridPoint(2, 1),
            ],
          ),
        ],
        solutionOrder: ['L2_S1', 'L2_S2'],
      );
}
