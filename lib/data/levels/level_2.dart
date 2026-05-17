import '../models/arrow_model.dart';
import '../models/level_model.dart';

/// Level 2 — Normal  (5 × 5 grid, 6 arrows)
///
/// Visual layout:
///   col:  0    1    2    3    4
/// row 0: [  ] [  ] [  ] [  ] [  ]
/// row 1: [  ] [↑ ] [←A2] [  ] [  ]
/// row 2: [→A1] [↑A3] [↓A4] [  ] [  ]
/// row 3: [  ] [  ] [  ] [→A5] [  ]
/// row 4: [  ] [↑A6] [  ] [  ] [  ]
///
/// Full-path analysis (ENTIRE path to edge must be clear):
///
///   A1 (r2,c0) → RIGHT:
///     checks c1=A3(active) → BLOCKED initially
///     Free after A3 is removed.
///
///   A2 (r1,c2) ← LEFT:
///     checks c1(r1,c1)=empty, c0(r1,c0)=empty → FREE ✓
///
///   A3 (r2,c1) ↑ UP:
///     checks r1,c1=empty, r0,c1=empty → FREE ✓
///
///   A4 (r2,c2) ↓ DOWN:
///     checks r3,c2=empty, r4,c2=empty → FREE ✓
///
///   A5 (r3,c3) → RIGHT:
///     checks c4(empty) → FREE ✓
///
///   A6 (r4,c1) ↑ UP:
///     checks r3,c1=empty, r2,c1=A3(active) → BLOCKED initially
///     Free after A3 is removed.
///
/// Valid removal orders (many exist), e.g.:
///   A2 → A3 → A1 → A4 → A5 → A6
///   A4 → A2 → A5 → A3 → A1 → A6
class Level2 {
  static LevelModel get data => LevelModel(
        levelNumber: 2,
        type: LevelType.regular,
        difficulty: LevelDifficulty.normal,
        gridRows: 5,
        gridCols: 5,
        arrows: [
          // A1 — blocked by A3 initially; free once A3 removed
          ArrowModel(id: 'L2_A1', row: 2, col: 0, direction: ArrowDirection.right),

          // A2 — free immediately (left path clear)
          ArrowModel(id: 'L2_A2', row: 1, col: 2, direction: ArrowDirection.left),

          // A3 — free immediately (up path clear)
          ArrowModel(id: 'L2_A3', row: 2, col: 1, direction: ArrowDirection.up),

          // A4 — free immediately (down path clear — A6 is at c1, not c2)
          ArrowModel(id: 'L2_A4', row: 2, col: 2, direction: ArrowDirection.down),

          // A5 — free immediately (right path: c4 is empty)
          ArrowModel(id: 'L2_A5', row: 3, col: 3, direction: ArrowDirection.right),

          // A6 — blocked by A3 (same column); free once A3 removed
          ArrowModel(id: 'L2_A6', row: 4, col: 1, direction: ArrowDirection.up),
        ],
        // Reference order for hint system (many valid orders exist)
        solutionOrder: ['L2_A2', 'L2_A4', 'L2_A5', 'L2_A3', 'L2_A1', 'L2_A6'],
      );
}
