import '../models/arrow_model.dart';
import '../models/level_model.dart';

/// Level 5: Spiral-like pattern
class Level5 {
  static LevelModel get data => LevelModel(
        levelNumber: 5,
        type: LevelType.regular,
        difficulty: LevelDifficulty.normal,
        gridRows: 5,
        gridCols: 5,
        arrows: [
          ArrowModel(id: 'L5_A1', row: 0, col: 0, direction: ArrowDirection.right),
          ArrowModel(id: 'L5_A2', row: 0, col: 2, direction: ArrowDirection.right),
          ArrowModel(id: 'L5_A3', row: 0, col: 4, direction: ArrowDirection.down),
          ArrowModel(id: 'L5_A4', row: 2, col: 4, direction: ArrowDirection.down),
          ArrowModel(id: 'L5_A5', row: 4, col: 4, direction: ArrowDirection.left),
          ArrowModel(id: 'L5_A6', row: 4, col: 2, direction: ArrowDirection.left),
          ArrowModel(id: 'L5_A7', row: 4, col: 0, direction: ArrowDirection.up),
          ArrowModel(id: 'L5_A8', row: 2, col: 0, direction: ArrowDirection.up),
          ArrowModel(id: 'L5_A9', row: 2, col: 2, direction: ArrowDirection.right),
        ],
        solutionOrder: [
          'L5_A9', 'L5_A8', 'L5_A7', 'L5_A6', 'L5_A5',
          'L5_A4', 'L5_A3', 'L5_A2', 'L5_A1',
        ],
      );
}