import '../models/arrow_model.dart';
import '../models/level_model.dart';

/// Level 1 — Tutorial (3×3 grid, 3 arrows)
///
/// Purpose: Teach the player the basic tap-to-remove mechanic.
///
/// Layout (visual):
///
///   col:   0      1      2
///   row 0: .      ●━A1   .         A1: straight UP
///                 ↑                     home (1,1), tail (1,1) → tip (0,1)
///   row 1: ●━A2   .      ●━A3
///          └━→            ←━┐      A2: L-shape RIGHT (tail bottom, bend center, tip right)
///                                       home (1,0), tail (2,0)→bend (1,0)→tip (1,1)?
///                                       Wait — (1,1) conflicts with A1 tail.
///   row 2: .      .      .
///
/// Let me redesign for ZERO overlaps:
///
///   col:   0      1      2
///   row 0: ●━A1   .      ●━A3      A1: straight DOWN at (0,0) → (1,0)
///          ↓                  ←     A3: L-shape LEFT, tail(0,2)→bend(0,2)? No.
///   row 1: .      ●━A2   .          A2: straight UP at (2,1) → (1,1)
///                 ↑
///   row 2: .      .      .
///
/// Final clean layout:
///
///   A1: Straight DOWN at home (0,0)    → path (0,0) → (1,0)
///   A2: Straight UP   at home (2,1)    → path (2,1) → (1,1)
///   A3: L-shape LEFT  at home (0,2)    → path (1,2) → (0,2) → (0,1)? — conflicts none
///
/// Verification (no shared grid dots):
///   A1 uses: (0,0), (1,0)
///   A2 uses: (2,1), (1,1)
///   A3 uses: (1,2), (0,2), (0,1)
///   All 7 dots are unique ✓
///
/// Solvability (all FREE from start):
///   A1 DOWN  from (0,0) → checks (1,0)(2,0) — no other arrow homes there ✓
///   A2 UP    from (2,1) → checks (1,1)(0,1) — no other arrow homes there ✓
///   A3 LEFT  from (0,2) → checks (0,1)(0,0) — A1 home at (0,0) blocks!
///
///   Hmm — A1 home (0,0) blocks A3.
///   After A1 removed, A3 is free.
///   So order: A1 first (or A2 first), then A3.
///   ✅ Solvable!
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
          // ── A1 — Straight DOWN (top-left) ──
          //   home (0,0), tail (0,0) → tip (1,0)
          //   On removal: travels DOWN → checks (1,0)(2,0) — FREE always
          ArrowModel(
            id: 'L1_A1',
            row: 0,
            col: 0,
            direction: ArrowDirection.down,
          ),

          // ── A2 — Straight UP (right side) ──
          //   home (2,1), tail (2,1) → tip (1,1)
          //   On removal: travels UP → checks (1,1)(0,1) — FREE always
          ArrowModel(
            id: 'L1_A2',
            row: 2,
            col: 1,
            direction: ArrowDirection.up,
          ),

          // ── A3 — L-shape pointing LEFT (top-right) ──
          //   home (0,2), path tail(1,2) → bend(0,2) → tip(0,1)
          //   On removal: travels LEFT from (0,2) → checks (0,1)(0,0)
          //   Blocked by A1 at (0,0) until A1 is removed.
          ArrowModel.lShaped(
            id: 'L1_A3',
            row: 0,
            col: 2,
            direction: ArrowDirection.left,
            start: const GridPoint(1, 2), // tail dot
            bend: const GridPoint(0, 2),  // bend dot
            end: const GridPoint(0, 1),   // tip dot
          ),
        ],

        // Valid solution order (multiple work):
        //   1. A1 — free
        //   2. A2 — free
        //   3. A3 — now (0,0) clear, free
        solutionOrder: ['L1_A1', 'L1_A2', 'L1_A3'],
      );
}