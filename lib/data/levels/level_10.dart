import '../models/arrow_model.dart';
import '../models/level_model.dart';

/// Level 10: Boss level - large and complex
class Level10 {
  static LevelModel get data => LevelModel(
        levelNumber: 10,
        type: LevelType.regular,
        difficulty: LevelDifficulty.hard,
        gridRows: 7,
        gridCols: 7,
        arrows: [
          ArrowModel(id: 'L10_A1', row: 0, col: 0, direction: ArrowDirection.right),
          ArrowModel(id: 'L10_A2', row: 0, col: 3, direction: ArrowDirection.right),
          ArrowModel(id: 'L10_A3', row: 0, col: 6, direction: ArrowDirection.down),
          ArrowModel(id: 'L10_A4', row: 1, col: 1, direction: ArrowDirection.down),
          ArrowModel(id: 'L10_A5', row: 1, col: 5, direction: ArrowDirection.left),
          ArrowModel(id: 'L10_A6', row: 2, col: 3, direction: ArrowDirection.up),
          ArrowModel(id: 'L10_A7', row: 3, col: 0, direction: ArrowDirection.down),
          ArrowModel(id: 'L10_A8', row: 3, col: 2, direction: ArrowDirection.right),
          ArrowModel(id: 'L10_A9', row: 3, col: 4, direction: ArrowDirection.down),
          ArrowModel(id: 'L10_A10', row: 3, col: 6, direction: ArrowDirection.left),
          ArrowModel(id: 'L10_A11', row: 4, col: 1, direction: ArrowDirection.up),
          ArrowModel(id: 'L10_A12', row: 5, col: 3, direction: ArrowDirection.left),
          ArrowModel(id: 'L10_A13', row: 5, col: 5, direction: ArrowDirection.up),
          ArrowModel(id: 'L10_A14', row: 6, col: 0, direction: ArrowDirection.right),
          ArrowModel(id: 'L10_A15', row: 6, col: 6, direction: ArrowDirection.up),
        ],
        solutionOrder: [
          'L10_A6', 'L10_A5', 'L10_A10', 'L10_A15', 'L10_A3',
          'L10_A2', 'L10_A1', 'L10_A11', 'L10_A4', 'L10_A8',
          'L10_A12', 'L10_A14', 'L10_A7', 'L10_A13', 'L10_A9',
        ],
      );
}