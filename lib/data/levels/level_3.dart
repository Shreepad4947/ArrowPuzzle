import '../models/arrow_model.dart';
import '../models/level_model.dart';

class Level3 {
  static LevelModel get data => LevelModel(
        levelNumber: 3,
        type: LevelType.regular,
        difficulty: LevelDifficulty.normal,
        gridRows: 5,
        gridCols: 5,
        arrows: [
          /// Left vertical down arrow
          ArrowModel(
            id: 'L3_A1',
            row: 2,
            col: 0,
            direction: ArrowDirection.down,
            pathPoints: const [
              GridPoint(1, 0),
              GridPoint(3, 0),
            ],
          ),

          /// Inner left up arrow
          ArrowModel(
            id: 'L3_A2',
            row: 2,
            col: 1,
            direction: ArrowDirection.up,
            pathPoints: const [
              GridPoint(3.4, 1),
              GridPoint(1.2, 1),
            ],
          ),

          /// Top maze arrow pointing right
          ArrowModel(
            id: 'L3_A3',
            row: 0,
            col: 2,
            direction: ArrowDirection.right,
            pathPoints: const [
              GridPoint(0, 1),
              GridPoint(0, 4),
              GridPoint(1, 4),
            ],
          ),

          /// Center down arrow
          ArrowModel(
            id: 'L3_A4',
            row: 2,
            col: 2,
            direction: ArrowDirection.down,
            pathPoints: const [
              GridPoint(1, 2),
              GridPoint(3, 2),
            ],
          ),

          /// Small U-shaped up arrow
          ArrowModel(
            id: 'L3_A5',
            row: 2,
            col: 3,
            direction: ArrowDirection.up,
            pathPoints: const [
              GridPoint(3, 3),
              GridPoint(2, 3),
              GridPoint(2, 3.6),
              GridPoint(1.2, 3.6),
            ],
          ),

          /// Right up arrow
          ArrowModel(
            id: 'L3_A6',
            row: 2,
            col: 4,
            direction: ArrowDirection.up,
            pathPoints: const [
              GridPoint(3.4, 4),
              GridPoint(1.2, 4),
            ],
          ),

          /// Bottom left-to-right arrow
          ArrowModel(
            id: 'L3_A7',
            row: 4,
            col: 1,
            direction: ArrowDirection.right,
            pathPoints: const [
              GridPoint(4, 0),
              GridPoint(4, 2),
            ],
          ),

          /// Bottom middle arrow pointing left
          ArrowModel(
            id: 'L3_A8',
            row: 3,
            col: 3,
            direction: ArrowDirection.left,
            pathPoints: const [
              GridPoint(3.5, 3.5),
              GridPoint(3.5, 2.3),
            ],
          ),
        ],

        solutionOrder: [
          'L3_A8',
          'L3_A7',
          'L3_A6',
          'L3_A5',
          'L3_A4',
          'L3_A3',
          'L3_A2',
          'L3_A1',
        ],
      );
}