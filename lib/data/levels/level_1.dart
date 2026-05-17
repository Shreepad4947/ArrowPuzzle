import '../models/arrow_model.dart';
import '../models/level_model.dart';

/// Level 1 — Tutorial (3 × 3 grid)
///
/// Layout:
///   col:   0        1        2
/// row 0: [ empty ] [ empty ] [ empty ]
/// row 1: [ ↑ A1 ] [ ↑ A2 ] [ ↓ A3 ]
/// row 2: [ empty ] [ empty ] [ empty ]
///
/// Free-removal rules:
///   A1 (row1,col0) → UP   → checks row0,col0 (empty) → FREE ✓
///   A2 (row1,col1) → UP   → checks row0,col1 (empty) → FREE ✓
///   A3 (row1,col2) → DOWN → checks row2,col2 (empty) → FREE ✓
///
/// All three are free from the start — player may remove in ANY order.
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
          // A1 — left column, pointing up
          ArrowModel(
            id: 'L1_A1',
            row: 1,
            col: 0,
            direction: ArrowDirection.up,
            pathPoints: const [
              GridPoint(1.65, 0), // tail (lower)
              GridPoint(0.35, 0), // head (upper)
            ],
          ),

          // A2 — centre column, pointing up
          ArrowModel(
            id: 'L1_A2',
            row: 1,
            col: 1,
            direction: ArrowDirection.up,
            pathPoints: const [
              GridPoint(1.65, 1),
              GridPoint(0.35, 1),
            ],
          ),

          // A3 — right column, pointing down
          ArrowModel(
            id: 'L1_A3',
            row: 1,
            col: 2,
            direction: ArrowDirection.down,
            pathPoints: const [
              GridPoint(1.35, 2),
              GridPoint(1.65, 2),
            ],
          ),
        ],

        // Any order is valid; used only by the hint system.
        solutionOrder: ['L1_A1', 'L1_A2', 'L1_A3'],
      );
}
