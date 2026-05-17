import '../models/arrow_model.dart';
import '../models/level_model.dart';

/// Level 8: Larger grid with more arrows
class Level8 {
  static LevelModel get data => LevelModel(
        levelNumber: 8,
        type: LevelType.regular,
        difficulty: LevelDifficulty.hard,
        gridRows: 6,
        gridCols: 6,
        arrows: [
          ArrowModel(id: 'L8_A1', row: 0, col: 0, direction: ArrowDirection.right),
          ArrowModel(id: 'L8_A2', row: 0, col: 3, direction: ArrowDirection.down),
          ArrowModel(id: 'L8_A3', row: 0, col: 5, direction: ArrowDirection.down),
          ArrowModel(id: 'L8_A4', row: 1, col: 1, direction: ArrowDirection.down),
          ArrowModel(id: 'L8_A5', row: 2, col: 3, direction: ArrowDirection.left),
          ArrowModel(id: 'L8_A6', row: 2, col: 5, direction: ArrowDirection.left),
          ArrowModel(id: 'L8_A7', row: 3, col: 0, direction: ArrowDirection.right),
          ArrowModel(id: 'L8_A8', row: 3, col: 2, direction: ArrowDirection.up),
          ArrowModel(id: 'L8_A9', row: 4, col: 4, direction: ArrowDirection.up),
          ArrowModel(id: 'L8_A10', row: 5, col: 1, direction: ArrowDirection.up),
          ArrowModel(id: 'L8_A11', row: 5, col: 3, direction: ArrowDirection.right),
          ArrowModel(id: 'L8_A12', row: 5, col: 5, direction: ArrowDirection.up),
        ],
        solutionOrder: [
          'L8_A8', 'L8_A5', 'L8_A6', 'L8_A9', 'L8_A12',
          'L8_A3', 'L8_A11', 'L8_A10', 'L8_A4', 'L8_A7',
          'L8_A1', 'L8_A2',
        ],
      );
}