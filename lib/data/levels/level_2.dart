import '../models/arrow_model.dart';
import '../models/level_model.dart';

/// Level 2 — Normal (5 × 4 grid)
///
/// Grid layout (row, col):
///
///        col0   col1   col2   col3
/// row0  [    ] [    ] [    ] [    ]
/// row1  [    ] [    ] [ A2←] [    ]
/// row2  [ A1→] [ A3↑] [ A4↓] [    ]
/// row3  [    ] [    ] [    ] [    ]
/// row4  [    ] [    ] [ A5→] [    ]
///
/// Free-removal analysis (start of game):
///   A1 (r2,c0) → RIGHT → checks r2,c1 = A3 (active) → BLOCKED initially
///   A2 (r1,c2) → LEFT  → checks r1,c1 (empty)       → FREE ✓
///   A3 (r2,c1) → UP    → checks r1,c1 (empty)       → FREE ✓
///   A4 (r2,c2) → DOWN  → checks r3,c2 (empty)       → FREE ✓
///   A5 (r4,c2) → RIGHT → checks r4,c3 (empty)       → FREE ✓
///
/// Once A3 is removed → A1 becomes FREE.
/// Many valid removal orders exist.
class Level2 {
  static LevelModel get data => LevelModel(
        levelNumber: 2,
        type: LevelType.regular,
        difficulty: LevelDifficulty.normal,
        gridRows: 5,
        gridCols: 4,
        arrows: [
          // A1 — (row2, col0) pointing RIGHT — blocked by A3 initially
          ArrowModel(
            id: 'L2_A1',
            row: 2,
            col: 0,
            direction: ArrowDirection.right,
            pathPoints: const [
              GridPoint(2, 0.35),
              GridPoint(2, 0.65),
            ],
          ),

          // A2 — (row1, col2) pointing LEFT — free immediately
          ArrowModel(
            id: 'L2_A2',
            row: 1,
            col: 2,
            direction: ArrowDirection.left,
            pathPoints: const [
              GridPoint(1, 2.65),
              GridPoint(1, 1.35),
            ],
          ),

          // A3 — (row2, col1) pointing UP — free immediately
          ArrowModel(
            id: 'L2_A3',
            row: 2,
            col: 1,
            direction: ArrowDirection.up,
            pathPoints: const [
              GridPoint(2.65, 1),
              GridPoint(1.35, 1),
            ],
          ),

          // A4 — (row2, col2) pointing DOWN — free immediately
          ArrowModel(
            id: 'L2_A4',
            row: 2,
            col: 2,
            direction: ArrowDirection.down,
            pathPoints: const [
              GridPoint(2.35, 2),
              GridPoint(3.65, 2),
            ],
          ),

          // A5 — (row4, col2) pointing RIGHT — free immediately
          ArrowModel(
            id: 'L2_A5',
            row: 4,
            col: 2,
            direction: ArrowDirection.right,
            pathPoints: const [
              GridPoint(4, 2.35),
              GridPoint(4, 3.65),
            ],
          ),
        ],

        // Reference order for hint system; many valid orders exist.
        solutionOrder: ['L2_A2', 'L2_A3', 'L2_A4', 'L2_A5', 'L2_A1'],
      );
}
