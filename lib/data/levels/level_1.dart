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
        tutorialMessage: 'Tap to remove',
        arrows: [
          ArrowModel(
            id: 'L1_A1',
            row: 1,
            col: 0,
            direction: ArrowDirection.up,
            pathPoints: const [
              GridPoint(2.3, 0),
              GridPoint(0.3, 0),
            ],
          ),
          ArrowModel(
            id: 'L1_A2',
            row: 1,
            col: 1,
            direction: ArrowDirection.up,
            pathPoints: const [
              GridPoint(2.3, 1),
              GridPoint(0.3, 1),
            ],
          ),
          ArrowModel(
            id: 'L1_A3',
            row: 1,
            col: 2,
            direction: ArrowDirection.down,
            pathPoints: const [
              GridPoint(0.3, 2),
              GridPoint(2.3, 2),
            ],
          ),
        ],

        /// Middle arrow first, exactly like your screenshot.
        solutionOrder: [
          'L1_A2',
          'L1_A1',
          'L1_A3',
        ],
      );
}