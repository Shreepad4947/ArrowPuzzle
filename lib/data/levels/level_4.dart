import '../models/arrow_model.dart';
import '../models/level_model.dart';

/// Level 4: More complex cross pattern
class Level4 {
  static LevelModel get data => LevelModel(
        levelNumber: 4,
        type: LevelType.regular,
        difficulty: LevelDifficulty.normal,
        gridRows: 5,
        gridCols: 5,
        arrows: [
          ArrowModel(id: 'L4_A1', row: 0, col: 2, direction: ArrowDirection.down),
          ArrowModel(id: 'L4_A2', row: 1, col: 0, direction: ArrowDirection.right),
          ArrowModel(id: 'L4_A3', row: 1, col: 2, direction: ArrowDirection.up),
          ArrowModel(id: 'L4_A4', row: 1, col: 4, direction: ArrowDirection.left),
          ArrowModel(id: 'L4_A5', row: 2, col: 1, direction: ArrowDirection.up),
          ArrowModel(id: 'L4_A6', row: 2, col: 3, direction: ArrowDirection.down),
          ArrowModel(id: 'L4_A7', row: 3, col: 2, direction: ArrowDirection.right),
          ArrowModel(id: 'L4_A8', row: 4, col: 2, direction: ArrowDirection.up),
        ],
        solutionOrder: [
          'L4_A3', 'L4_A5', 'L4_A2', 'L4_A8', 'L4_A7', 'L4_A6', 'L4_A4', 'L4_A1'
        ],
      );
}