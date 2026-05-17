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
    // ── 1. Draw dots on EVERY grid cell (full matrix background) ──────────────
    _drawFullGridDots(canvas);

    // ── 2. Draw each arrow on top ─────────────────────────────────────────────
    for (final arrow in arrows) {
      if (arrow.state == ArrowState.removed) continue;

      double opacity = 1.0;
      Offset slideOffset = Offset.zero;

      if (arrow.state == ArrowState.removing) {
        final progress = removeAnimations[arrow.id] ?? 0.0;
        opacity = 1.0 - progress;
        slideOffset = arrow.directionOffset * cellSize * 1.8 * progress;
      }

      Color color;
      switch (arrow.state) {
        case ArrowState.active:
          color = AppColors.arrowDefault;
          break;
        case ArrowState.highlighted:
          color = AppColors.arrowHint;
          break;
        case ArrowState.wrong:
          color = AppColors.arrowWrong;
          break;
        case ArrowState.removing:
          color = AppColors.arrowDefault;
          break;
        case ArrowState.removed:
          continue;
      }

      _drawMazeArrow(
        canvas,
        arrow,
        color.withOpacity(opacity),
        slideOffset,
        arrow.state == ArrowState.highlighted,
      );
    }
  }

  // ── Full-grid dot pattern ──────────────────────────────────────────────────

  /// Draws a dot at the centre of EVERY cell in the grid matrix,
  /// so the background always looks like a full dotted grid regardless
  /// of which arrows are present.
  void _drawFullGridDots(Canvas canvas) {
    final paint = Paint()
      ..color = AppColors.primaryLight.withOpacity(0.38)
      ..style = PaintingStyle.fill;

    const double dotRadius = 2.2;

    for (int row = 0; row < gridRows; row++) {
      for (int col = 0; col < gridCols; col++) {
        final cx = col * cellSize + cellSize / 2;
        final cy = row * cellSize + cellSize / 2;
        canvas.drawCircle(Offset(cx, cy), dotRadius, paint);
      }
    }
  }

  // ── Arrow drawing ──────────────────────────────────────────────────────────

  void _drawMazeArrow(
    Canvas canvas,
    ArrowModel arrow,
    Color color,
    Offset slideOffset,
    bool isHighlighted,
  ) {
    final points = arrow.pathPoints;
    if (points.length < 2) return;

    final offsets =
        points.map((p) => p.toOffset(cellSize) + slideOffset).toList();

    if (isHighlighted) {
      _drawGlow(canvas, offsets, color);
    }

    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path()..moveTo(offsets.first.dx, offsets.first.dy);
    for (int i = 1; i < offsets.length; i++) {
      path.lineTo(offsets[i].dx, offsets[i].dy);
    }
    canvas.drawPath(path, linePaint);

    _drawFilledArrowHead(canvas, offsets, color);
  }

  void _drawGlow(Canvas canvas, List<Offset> offsets, Color color) {
    final glowPaint = Paint()
      ..color = color.withOpacity(0.28)
      ..strokeWidth = 11
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);

    final path = Path()..moveTo(offsets.first.dx, offsets.first.dy);
    for (int i = 1; i < offsets.length; i++) {
      path.lineTo(offsets[i].dx, offsets[i].dy);
    }
    canvas.drawPath(path, glowPaint);
  }

  void _drawFilledArrowHead(
    Canvas canvas,
    List<Offset> offsets,
    Color color,
  ) {
    if (offsets.length < 2) return;

    final tip = offsets.last;
    final beforeTip = offsets[offsets.length - 2];

    final dx = tip.dx - beforeTip.dx;
    final dy = tip.dy - beforeTip.dy;
    final angle = math.atan2(dy, dx);

    const double headLength = 14;
    const double headWidth = 16;

    final backCenter = Offset(
      tip.dx - math.cos(angle) * headLength,
      tip.dy - math.sin(angle) * headLength,
    );
    final perp = angle + math.pi / 2;

    final p1 = tip;
    final p2 = Offset(
      backCenter.dx + math.cos(perp) * headWidth / 2,
      backCenter.dy + math.sin(perp) * headWidth / 2,
    );
    final p3 = Offset(
      backCenter.dx - math.cos(perp) * headWidth / 2,
      backCenter.dy - math.sin(perp) * headWidth / 2,
    );

    final headPath = Path()
      ..moveTo(p1.dx, p1.dy)
      ..lineTo(p2.dx, p2.dy)
      ..lineTo(p3.dx, p3.dy)
      ..close();

    canvas.drawPath(
        headPath, Paint()..color = color..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(covariant ArrowPainter oldDelegate) => true;
}
