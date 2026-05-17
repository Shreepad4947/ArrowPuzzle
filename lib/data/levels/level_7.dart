import '../models/arrow_model.dart';
import '../models/level_model.dart';

/// Level 7: Complex interconnected pattern
class Level7 {
  static LevelModel get data => LevelModel(
        levelNumber: 7,
        type: LevelType.regular,
        difficulty: LevelDifficulty.normal,
        gridRows: 6,
        gridCols: 5,
        arrows: [
          ArrowModel(id: 'L7_A1', row: 0, col: 1, direction: ArrowDirection.right),
          ArrowModel(id: 'L7_A2', row: 0, col: 3, direction: ArrowDirection.down),
          ArrowModel(id: 'L7_A3', row: 1, col: 0, direction: ArrowDirection.down),
          ArrowModel(id: 'L7_A4', row: 1, col: 2, direction: ArrowDirection.left),
          ArrowModel(id: 'L7_A5', row: 2, col: 4, direction: ArrowDirection.down),
          ArrowModel(id: 'L7_A6', row: 3, col: 0, direction: ArrowDirection.right),
          ArrowModel(id: 'L7_A7', row: 3, col: 2, direction: ArrowDirection.up),
          ArrowModel(id: 'L7_A8', row: 4, col: 1, direction: ArrowDirection.right),
          ArrowModel(id: 'L7_A9', row: 4, col: 3, direction: ArrowDirection.up),
          ArrowModel(id: 'L7_A10', row: 5, col: 4, direction: ArrowDirection.left),
        ],
        solutionOrder: [
          'L7_A4', 'L7_A7', 'L7_A9', 'L7_A10', 'L7_A5',
          'L7_A2', 'L7_A1', 'L7_A8', 'L7_A6', 'L7_A3',
        ],
      );
}