import '../models/arrow_model.dart';
import '../models/level_model.dart';

/// Level 9: Complex with diagonal arrows
class Level9 {
  static LevelModel get data => LevelModel(
        levelNumber: 9,
        type: LevelType.regular,
        difficulty: LevelDifficulty.hard,
        gridRows: 6,
        gridCols: 6,
        arrows: [
          ArrowModel(id: 'L9_A1', row: 0, col: 0, direction: ArrowDirection.downRight),
          ArrowModel(id: 'L9_A2', row: 0, col: 3, direction: ArrowDirection.down),
          ArrowModel(id: 'L9_A3', row: 0, col: 5, direction: ArrowDirection.downLeft),
          ArrowModel(id: 'L9_A4', row: 1, col: 1, direction: ArrowDirection.right),
          ArrowModel(id: 'L9_A5', row: 1, col: 4, direction: ArrowDirection.down),
          ArrowModel(id: 'L9_A6', row: 2, col: 2, direction: ArrowDirection.down),
          ArrowModel(id: 'L9_A7', row: 3, col: 0, direction: ArrowDirection.upRight),
          ArrowModel(id: 'L9_A8', row: 3, col: 3, direction: ArrowDirection.left),
          ArrowModel(id: 'L9_A9', row: 4, col: 1, direction: ArrowDirection.right),
          ArrowModel(id: 'L9_A10', row: 4, col: 5, direction: ArrowDirection.up),
          ArrowModel(id: 'L9_A11', row: 5, col: 2, direction: ArrowDirection.up),
          ArrowModel(id: 'L9_A12', row: 5, col: 4, direction: ArrowDirection.upLeft),
          ArrowModel(id: 'L9_A13', row: 2, col: 5, direction: ArrowDirection.left),
        ],
        solutionOrder: [
          'L9_A8', 'L9_A6', 'L9_A11', 'L9_A9', 'L9_A4',
          'L9_A7', 'L9_A12', 'L9_A13', 'L9_A10', 'L9_A5',
          'L9_A3', 'L9_A2', 'L9_A1',
        ],
      );
}