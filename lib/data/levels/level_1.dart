import '../models/arrow_model.dart';
import '../models/level_model.dart';

/// Level 1 — Tutorial  (3 × 3 grid, 3 arrows)
///
/// Visual layout:
///   col:   0    1    2
/// row 0: [  ] [  ] [  ]
/// row 1: [↑ ] [↑ ] [↓ ]
/// row 2: [  ] [  ] [  ]
///
/// Path-clear check (full-line rule):
///   A1 (r1,c0) ↑ → walks r0,c0 → empty → FREE ✓
///   A2 (r1,c1) ↑ → walks r0,c1 → empty → FREE ✓
///   A3 (r1,c2) ↓ → walks r2,c2 → empty → FREE ✓
///
/// All three are removable from the start. Any order works.
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
          ArrowModel(id: 'L1_A1', row: 1, col: 0, direction: ArrowDirection.up),
          ArrowModel(id: 'L1_A2', row: 1, col: 1, direction: ArrowDirection.up),
          ArrowModel(id: 'L1_A3', row: 1, col: 2, direction: ArrowDirection.down),
        ],
        // Any order is valid — used only by hint system
        solutionOrder: ['L1_A1', 'L1_A2', 'L1_A3'],
      );
}
