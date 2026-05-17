import '../models/arrow_model.dart';
import '../models/level_model.dart';

class Level1 {
  static LevelModel get data => LevelModel(
        levelNumber: 1,
        type: LevelType.tutorial,
        difficulty: LevelDifficulty.easy,
        gridRows: 3,
        gridCols: 3,
        showTutorial: true,
        tutorialMessage: 'Swipe to clear vertical arrows!',
        arrows: [
          // Column 0: Vertical Upward (covers 3 dots)
          ArrowModel(
            id: 'L1_V1',
            row: 2,
            col: 0,
            direction: ArrowDirection.up,
            pathPoints: [
              const GridPoint(2, 0),
              const GridPoint(1, 0),
              const GridPoint(0, 0),
            ],
          ),
          // Column 1: Vertical Downward (covers 3 dots)
          ArrowModel(
            id: 'L1_V2',
            row: 0,
            col: 1,
            direction: ArrowDirection.down,
            pathPoints: [
              const GridPoint(0, 1),
              const GridPoint(1, 1),
              const GridPoint(2, 1),
            ],
          ),
          // Column 2: Vertical Downward (covers 3 dots)
          ArrowModel(
            id: 'L1_V3',
            row: 0,
            col: 2,
            direction: ArrowDirection.down,
            pathPoints: [
              const GridPoint(0, 2),
              const GridPoint(1, 2),
              const GridPoint(2, 2),
            ],
          ),
        ],
        solutionOrder: ['L1_V1', 'L1_V2', 'L1_V3'],
      );
}
