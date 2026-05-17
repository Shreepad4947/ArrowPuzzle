import '../models/arrow_model.dart';
import '../models/level_model.dart';

class Level3 {
  static LevelModel get data => LevelModel(
        levelNumber: 3,
        type: LevelType.regular,
        difficulty: LevelDifficulty.normal,
        gridRows: 5,
        gridCols: 5,
        showTutorial: false,
        arrows: [
          // Snake 1: Top row. Tip at (0,4) escapes Right.
          ArrowModel(
            id: 'L3_S1',
            row: 0, col: 0,
            direction: ArrowDirection.right,
            pathPoints: [
              const GridPoint(0, 0),
              const GridPoint(0, 1),
              const GridPoint(0, 2),
              const GridPoint(0, 3),
              const GridPoint(0, 4),
            ],
          ),
          // Snake 2: Interlocking middle-left. Tip at (2,0) escapes Left.
          ArrowModel(
            id: 'L3_S2',
            row: 1, col: 0,
            direction: ArrowDirection.left,
            pathPoints: [
              const GridPoint(1, 0),
              const GridPoint(1, 1),
              const GridPoint(1, 2),
              const GridPoint(2, 2),
              const GridPoint(2, 1),
              const GridPoint(2, 0),
            ],
          ),
          // Snake 3: Right column corner. Tip at (4,4) escapes Down.
          ArrowModel(
            id: 'L3_S3',
            row: 1, col: 3,
            direction: ArrowDirection.down,
            pathPoints: [
              const GridPoint(1, 3),
              const GridPoint(1, 4),
              const GridPoint(2, 4),
              const GridPoint(3, 4),
              const GridPoint(4, 4),
            ],
          ),
          // Snake 4: Bottom-left winding. Tip at (4,0) escapes Left.
          ArrowModel(
            id: 'L3_S4',
            row: 2, col: 3,
            direction: ArrowDirection.left,
            pathPoints: [
              const GridPoint(2, 3),
              const GridPoint(3, 3),
              const GridPoint(4, 3),
              const GridPoint(4, 2),
              const GridPoint(4, 1),
              const GridPoint(4, 0),
            ],
          ),
          // Snake 5: Remaining middle dots. Tip at (3,2) escapes Right.
          // Blocked by S3 and S4.
          ArrowModel(
            id: 'L3_S5',
            row: 3, col: 0,
            direction: ArrowDirection.right,
            pathPoints: [
              const GridPoint(3, 0),
              const GridPoint(3, 1),
              const GridPoint(3, 2),
            ],
          ),
        ],
        solutionOrder: ['L3_S1', 'L3_S2', 'L3_S3', 'L3_S4', 'L3_S5'],
      );
}
