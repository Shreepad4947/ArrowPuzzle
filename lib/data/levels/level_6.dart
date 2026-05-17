import '../models/arrow_model.dart';
import '../models/level_model.dart';

/// Level 6: Diagonal arrows introduction
class Level6 {
  static LevelModel get data => LevelModel(
        levelNumber: 6,
        type: LevelType.regular,
        difficulty: LevelDifficulty.normal,
        gridRows: 5,
        gridCols: 5,
        arrows: [
          ArrowModel(id: 'L6_A1', row: 0, col: 0, direction: ArrowDirection.downRight),
          ArrowModel(id: 'L6_A2', row: 0, col: 4, direction: ArrowDirection.downLeft),
          ArrowModel(id: 'L6_A3', row: 2, col: 2, direction: ArrowDirection.up),
          ArrowModel(id: 'L6_A4', row: 2, col: 0, direction: ArrowDirection.right),
          ArrowModel(id: 'L6_A5', row: 2, col: 4, direction: ArrowDirection.left),
          ArrowModel(id: 'L6_A6', row: 4, col: 0, direction: ArrowDirection.upRight),
          ArrowModel(id: 'L6_A7', row: 4, col: 4, direction: ArrowDirection.upLeft),
          ArrowModel(id: 'L6_A8', row: 4, col: 2, direction: ArrowDirection.up),
          ArrowModel(id: 'L6_A9', row: 1, col: 2, direction: ArrowDirection.down),
        ],
        solutionOrder: [
          'L6_A3', 'L6_A9', 'L6_A8', 'L6_A4', 'L6_A5',
          'L6_A6', 'L6_A7', 'L6_A1', 'L6_A2',
        ],
      );
}