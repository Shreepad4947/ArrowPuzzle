import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/arrow_model.dart';

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

  @override
  void paint(Canvas canvas, Size size) {
    _drawFullGridDots(canvas);
    for (final ArrowModel arrow in arrows) {
      _paintArrow(canvas, arrow);
    }
  }

  void _drawFullGridDots(Canvas canvas) {
    final Paint paint = Paint()
      ..color = AppColors.primaryLight.withOpacity(0.35)
      ..style = PaintingStyle.fill;

    const double dotRadius = 2.5;

    for (int row = 0; row < gridRows; row++) {
      for (int col = 0; col < gridCols; col++) {
        canvas.drawCircle(
          Offset(
            col * cellSize + cellSize / 2,
            row * cellSize + cellSize / 2,
          ),
          dotRadius,
          paint,
        );
      }
    }
  }

  void _paintArrow(Canvas canvas, ArrowModel arrow) {

    // ✅ FIX 1: Skip removed arrows immediately - no ghost rendering
    if (arrow.state == ArrowState.removed) return;

    double opacity = 1.0;
    Offset slideOffset = Offset.zero;

    if (arrow.state == ArrowState.removing) {
      final double progress = removeAnimations[arrow.id] ?? 0.0;

      // ✅ FIX 2: If progress is 0.0 and state is removing,
      // it means animation hasn't started yet OR removeAnimations
      // map was lost on rebuild.
      // We check: if state is removing but no animation key exists,
      // treat as fully removed (invisible) to prevent ghost flash.
      if (!removeAnimations.containsKey(arrow.id)) {
        // ✅ FIX 3: Arrow is mid-removal but animation map is gone
        // (happens on rebuild). Don't draw it at all.
        return;
      }

      opacity = (1.0 - progress).clamp(0.0, 1.0);

      // ✅ FIX 4: If fully transparent, skip drawing entirely
      if (opacity <= 0.01) return;

      final Offset dir = _directionVector(arrow.direction);
      slideOffset = Offset(
        dir.dx * cellSize * 2.0 * progress,
        dir.dy * cellSize * 2.0 * progress,
      );
    }

    // Pick colour based on state
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
        // Already handled above, but needed for exhaustive switch
        return;
    }

    final Color color = baseColor.withOpacity(opacity);

    final double cx = arrow.col * cellSize + cellSize / 2 + slideOffset.dx;
    final double cy = arrow.row * cellSize + cellSize / 2 + slideOffset.dy;

    canvas.save();
    canvas.translate(cx, cy);

    if (arrow.state == ArrowState.highlighted) {
      _drawGlow(canvas, color, cellSize);
    }

    _drawSingleCellArrow(canvas, arrow.direction, color, cellSize);
    canvas.restore();
  }

  void _drawSingleCellArrow(
    Canvas canvas,
    ArrowDirection direction,
    Color color,
    double cellSize,
  ) {
    final double angle = _directionAngle(direction);
    final double halfBody = cellSize * 0.28;

    canvas.save();
    canvas.rotate(angle);

    final double tailX = -halfBody;
    final double tipX = halfBody;

    // Body line
    final Paint bodyPaint = Paint()
      ..color = color
      ..strokeWidth = cellSize * 0.13
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final double bodyEndX = tipX - cellSize * 0.12;
    canvas.drawLine(Offset(tailX, 0), Offset(bodyEndX, 0), bodyPaint);

    // Arrowhead (filled triangle)
    final double headBaseX = tipX - cellSize * 0.22;
    final double headHalfW = cellSize * 0.14;

    final Path headPath = Path()
      ..moveTo(tipX, 0)
      ..lineTo(headBaseX, headHalfW)
      ..lineTo(headBaseX, -headHalfW)
      ..close();

    final Paint headPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawPath(headPath, headPaint);
    canvas.restore();
  }

  void _drawGlow(Canvas canvas, Color color, double cellSize) {
    final Paint glowPaint = Paint()
      ..color = color.withOpacity(0.22)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, cellSize * 0.18);

    canvas.drawCircle(Offset.zero, cellSize * 0.38, glowPaint);
  }

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
  bool shouldRepaint(covariant ArrowPainter oldDelegate) {
    // ✅ FIX 5: More precise repaint check
    return oldDelegate.arrows != arrows ||
        oldDelegate.removeAnimations != removeAnimations ||
        oldDelegate.cellSize != cellSize;
  }
}