import '../models/arrow_model.dart';
import '../models/level_model.dart';

/// Level 2 — Normal (5×5 grid, 6 arrows)
///
/// VERIFIED solvable design — no two arrows face each other.
///
/// Home cells & directions:
///   A1 (1,0) RIGHT  — L-shape (0,0)→(1,0)→(1,0)? No, redesign below
class Level2 {
  static LevelModel get data => LevelModel(
        levelNumber: 2,
        type: LevelType.regular,
        difficulty: LevelDifficulty.normal,
        gridRows: 5,
        gridCols: 5,
        arrows: [
          // ── A1 — L-shape pointing UP (top-left) ──
          //   home (1,0): path (1,1) → (1,0) → (0,0)
          //   On removal: travels UP from (1,0) → checks (0,0) only
          //   FREE always
          ArrowModel.lShaped(
            id: 'L2_A1',
            row: 1,
            col: 0,
            direction: ArrowDirection.up,
            start: const GridPoint(1, 1),
            bend: const GridPoint(1, 0),
            end: const GridPoint(0, 0),
          ),

          // ── A2 — Straight DOWN (top-center) ──
          //   home (0,2): travels DOWN → checks (1,2)(2,2)(3,2)(4,2)
          //   FREE (no arrow homes in col 2 below row 0)
          ArrowModel(
            id: 'L2_A2',
            row: 0,
            col: 2,
            direction: ArrowDirection.down,
          ),

          // ── A3 — L-shape pointing UP (top-right) ──
          //   home (1,4): path (1,3) → (1,4) → (0,4)
          //   On removal: travels UP from (1,4) → checks (0,4) only
          //   FREE always
          ArrowModel.lShaped(
            id: 'L2_A3',
            row: 1,
            col: 4,
            direction: ArrowDirection.up,
            start: const GridPoint(1, 3),
            bend: const GridPoint(1, 4),
            end: const GridPoint(0, 4),
          ),

          // ── A4 — Straight RIGHT (middle-left) ──
          //   home (3,0): travels RIGHT → checks (3,1)(3,2)(3,3)(3,4)
          //   Blocked by A5 at (3,3) until A5 removed
          ArrowModel(
            id: 'L2_A4',
            row: 3,
            col: 0,
            direction: ArrowDirection.right,
          ),

          // ── A5 — L-shape pointing DOWN (middle-right) ──
          //   home (3,3): path (2,3) → (3,3) → (3,3)? No — pick clean shape
          //   path (2,3) → (3,3) → (4,3)
          //   On removal: travels DOWN from (3,3) → checks (4,3)
          //   FREE always
          ArrowModel.lShaped(
            id: 'L2_A5',
            row: 3,
            col: 3,
            direction: ArrowDirection.down,
            start: const GridPoint(2, 3),
            bend: const GridPoint(3, 3),
            end: const GridPoint(4, 3),
          ),

          // ── A6 — Straight RIGHT (bottom-left) ──
          //   home (4,1): travels RIGHT → checks (4,2)(4,3)(4,4)
          //   Blocked by A5 tip — but ArrowLogic only checks HOME cells.
          //   A5's home is (3,3), not (4,3). So path check is clear.
          //   FREE always
          ArrowModel(
            id: 'L2_A6',
            row: 4,
            col: 1,
            direction: ArrowDirection.right,
          ),
        ],

        // Solution order (multiple valid orders exist):
        //   1. A1 — UP, free
        //   2. A2 — DOWN, free
        //   3. A3 — UP, free
        //   4. A5 — DOWN, free
        //   5. A6 — RIGHT, free
        //   6. A4 — RIGHT, was blocked by A5 home(3,3), now free
        solutionOrder: [
          'L2_A1',
          'L2_A2',
          'L2_A3',
          'L2_A5',
          'L2_A6',
          'L2_A4',
        ],
      );
}