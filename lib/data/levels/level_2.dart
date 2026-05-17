import '../models/arrow_model.dart';
import '../models/level_model.dart';

class Level2 {
  static LevelModel get data => LevelModel(
        levelNumber: 2,
        type: LevelType.regular,
        difficulty: LevelDifficulty.normal,
        gridRows: 5,
        gridCols: 4,
        arrows: [
          /// Outer L-shaped arrow: up then right
          ArrowModel(
            id: 'L2_A1',
            row: 2,
            col: 0,
            direction: ArrowDirection.right,
            pathPoints: const [
              GridPoint(4, 0),
              GridPoint(0, 0),
              GridPoint(0, 2.2),
            ],
          ),

          /// Top inner arrow pointing left
          ArrowModel(
            id: 'L2_A2',
            row: 1,
            col: 2,
            direction: ArrowDirection.left,
            pathPoints: const [
              GridPoint(1, 3),
              GridPoint(1, 1),
            ],
          ),

          /// Inner up arrow
          ArrowModel(
            id: 'L2_A3',
            row: 2,
            col: 1,
            direction: ArrowDirection.up,
            pathPoints: const [
              GridPoint(3.4, 1),
              GridPoint(2, 1),
            ],
          ),

          /// Small center down arrow
          ArrowModel(
            id: 'L2_A4',
            row: 2,
            col: 2,
            direction: ArrowDirection.down,
            pathPoints: const [
              GridPoint(2, 2),
              GridPoint(3.3, 2),
            ],
          ),

          /// Bottom arrow pointing right
          ArrowModel(
            id: 'L2_A5',
            row: 4,
            col: 2,
            direction: ArrowDirection.right,
            pathPoints: const [
              GridPoint(4, 1),
              GridPoint(4, 3),
            ],
          ),
        ],

        /// Stable manual solution.
        solutionOrder: [
          'L2_A5',
          'L2_A4',
          'L2_A3',
          'L2_A2',
          'L2_A1',
        ],
      );
}