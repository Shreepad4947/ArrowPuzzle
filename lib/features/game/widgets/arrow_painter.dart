import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/arrow_model.dart';

/// Paints the full game board:
///  1. Dot grid — a small dot at the centre of EVERY cell (full matrix)
///  2. Arrows   — one clean, single-cell directional arrow per ArrowModel
///
/// Visual style matches Easybrain's Arrow Puzzle:
///  • Thick rounded line body
///  • Bold filled triangle arrowhead
///  • Slides out in its direction when removed
///  • Yellow glow when hinted
///  • Red tint when wrong tap
class ArrowPainter extends CustomPainter {
  final List<ArrowModel> arrows;
  final int gridRows;
  final int gridCols;
  final double cellSize;
  final Map<String, double> removeAnimations;

  ArrowPainter({
    required this.arrows,
    required this.gridRows,
    required this.gridCols,
    required this.cellSize,
    this.removeAnimations = const {},
  });

  // ── Paint entry ─────────────────────────────────────────────────────────

  @override
  void paint(Canvas canvas, Size size) {
    _drawFullGridDots(canvas);
    for (final arrow in arrows) {
      if (arrow.state == ArrowState.removed) continue;
      _paintArrow(canvas, arrow);
    }
  }

  // ── Dot grid ────────────────────────────────────────────────────────────

  /// Draws a small dot at the centre of every grid cell.
  void _drawFullGridDots(Canvas canvas) {
    final paint = Paint()
      ..color = AppColors.primaryLight.withOpacity(0.35)
      ..style = PaintingStyle.fill;

    const double dotRadius = 2.5;

    for (int row = 0; row < gridRows; row++) {
      for (int col = 0; col < gridCols; col++) {
        canvas.drawCircle(
          Offset(col * cellSize + cellSize / 2, row * cellSize + cellSize / 2),
          dotRadius,
          paint,
        );
      }
    }
  }

  // ── Arrow painting ───────────────────────────────────────────────────────

  void _paintArrow(Canvas canvas, ArrowModel arrow) {
    // Animation offset for slide-out
    double opacity = 1.0;
    Offset slideOffset = Offset.zero;

    if (arrow.state == ArrowState.removing) {
      final progress = removeAnimations[arrow.id] ?? 0.0;
      opacity = (1.0 - progress).clamp(0.0, 1.0);
      final dir = _directionVector(arrow.direction);
      slideOffset = Offset(
        dir.dx * cellSize * 2.0 * progress,
        dir.dy * cellSize * 2.0 * progress,
      );
    }

    // Pick colour
    final Color baseColor;
    switch (arrow.state) {
      case ArrowState.active:
        baseColor = AppColors.arrowDefault;
        break;
      case ArrowState.highlighted:
        baseColor = AppColors.arrowHint;
        break;
      case ArrowState.wrong:
        baseColor = AppColors.arrowWrong;
        break;
      case ArrowState.removing:
        baseColor = AppColors.arrowDefault;
        break;
      case ArrowState.removed:
        return;
    }

    final color = baseColor.withOpacity(opacity);

    // Centre of the cell in canvas coordinates
    final cx = arrow.col * cellSize + cellSize / 2 + slideOffset.dx;
    final cy = arrow.row * cellSize + cellSize / 2 + slideOffset.dy;
    final center = Offset(cx, cy);

    canvas.save();
    canvas.translate(cx, cy);

    if (arrow.state == ArrowState.highlighted) {
      _drawGlow(canvas, color, cellSize);
    }

    _drawSingleCellArrow(canvas, arrow.direction, color, cellSize);
    canvas.restore();

    // Debug: draw cell outline (remove in production)
    // _drawCellDebug(canvas, arrow, cellSize);
  }

  /// Draws a clean single-cell arrow centred at (0,0) in local coordinates.
  /// Matches Easybrain style: thick body + bold filled arrowhead.
  void _drawSingleCellArrow(
    Canvas canvas,
    ArrowDirection direction,
    Color color,
    double cellSize,
  ) {
    final angle = _directionAngle(direction);
    final halfBody = cellSize * 0.28; // half-length of arrow body
    const double headLen = 0.0; // arrowhead is at tip, no extra extension

    // In local space, arrow goes from -halfBody to +halfBody along X axis,
    // then we rotate to the correct direction.
    canvas.save();
    canvas.rotate(angle);

    final tailX = -halfBody;
    final tipX  =  halfBody;

    // ── Body line ────────────────────────────────────────────────
    final bodyPaint = Paint()
      ..color = color
      ..strokeWidth = cellSize * 0.13
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Body stops slightly before the tip so the head looks clean
    final bodyEndX = tipX - cellSize * 0.12;
    canvas.drawLine(Offset(tailX, 0), Offset(bodyEndX, 0), bodyPaint);

    // ── Arrowhead (filled triangle) ──────────────────────────────
    final headBaseX = tipX - cellSize * 0.22;
    final headHalfW = cellSize * 0.14;

    final headPath = Path()
      ..moveTo(tipX, 0)                         // tip
      ..lineTo(headBaseX,  headHalfW)           // bottom-left
      ..lineTo(headBaseX, -headHalfW)           // top-left
      ..close();

    final headPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawPath(headPath, headPaint);
    canvas.restore();
  }

  // ── Glow effect for hint ────────────────────────────────────────────────

  void _drawGlow(Canvas canvas, Color color, double cellSize) {
    final glowPaint = Paint()
      ..color = color.withOpacity(0.22)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, cellSize * 0.18);

    canvas.drawCircle(Offset.zero, cellSize * 0.38, glowPaint);
  }

  // ── Direction helpers ───────────────────────────────────────────────────

  /// Rotation angle so the arrow points in the correct direction.
  /// Base orientation is RIGHT (0 radians).
  double _directionAngle(ArrowDirection d) {
    switch (d) {
      case ArrowDirection.right:     return 0;
      case ArrowDirection.down:      return math.pi / 2;
      case ArrowDirection.left:      return math.pi;
      case ArrowDirection.up:        return -math.pi / 2;
      case ArrowDirection.upRight:   return -math.pi / 4;
      case ArrowDirection.downRight: return math.pi / 4;
      case ArrowDirection.downLeft:  return 3 * math.pi / 4;
      case ArrowDirection.upLeft:    return -3 * math.pi / 4;
    }
  }

  /// Unit direction vector for slide-out animation.
  Offset _directionVector(ArrowDirection d) {
    switch (d) {
      case ArrowDirection.up:        return const Offset(0, -1);
      case ArrowDirection.down:      return const Offset(0, 1);
      case ArrowDirection.left:      return const Offset(-1, 0);
      case ArrowDirection.right:     return const Offset(1, 0);
      case ArrowDirection.upLeft:    return const Offset(-0.707, -0.707);
      case ArrowDirection.upRight:   return const Offset(0.707, -0.707);
      case ArrowDirection.downLeft:  return const Offset(-0.707, 0.707);
      case ArrowDirection.downRight: return const Offset(0.707, 0.707);
    }
  }

  @override
  bool shouldRepaint(covariant ArrowPainter oldDelegate) => true;
}
