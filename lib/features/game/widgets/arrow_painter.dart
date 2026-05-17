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
    _drawBackgroundDots(canvas);

    for (final arrow in arrows) {
      if (arrow.state == ArrowState.removed) {
        continue;
      }

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

  void _drawBackgroundDots(Canvas canvas) {
    for (final arrow in arrows) {
      _drawDottedPath(canvas, arrow.pathPoints);
    }
  }

  void _drawDottedPath(Canvas canvas, List<GridPoint> points) {
    if (points.length < 2) return;

    final paint = Paint()
      ..color = AppColors.primaryLight.withOpacity(0.35)
      ..style = PaintingStyle.fill;

    const double spacing = 14;
    const double dotRadius = 1.4;

    for (int i = 0; i < points.length - 1; i++) {
      final start = points[i].toOffset(cellSize);
      final end = points[i + 1].toOffset(cellSize);

      final dx = end.dx - start.dx;
      final dy = end.dy - start.dy;
      final distance = math.sqrt(dx * dx + dy * dy);

      if (distance == 0) continue;

      final steps = math.max(1, (distance / spacing).floor());

      for (int s = 0; s <= steps; s++) {
        final t = s / steps;
        final x = start.dx + dx * t;
        final y = start.dy + dy * t;

        canvas.drawCircle(
          Offset(x, y),
          dotRadius,
          paint,
        );
      }
    }
  }

  void _drawMazeArrow(
    Canvas canvas,
    ArrowModel arrow,
    Color color,
    Offset slideOffset,
    bool isHighlighted,
  ) {
    final points = arrow.pathPoints;
    if (points.length < 2) return;

    final offsets = points.map((p) => p.toOffset(cellSize) + slideOffset).toList();

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

    final perpendicularAngle = angle + math.pi / 2;

    final p1 = tip;
    final p2 = Offset(
      backCenter.dx + math.cos(perpendicularAngle) * headWidth / 2,
      backCenter.dy + math.sin(perpendicularAngle) * headWidth / 2,
    );
    final p3 = Offset(
      backCenter.dx - math.cos(perpendicularAngle) * headWidth / 2,
      backCenter.dy - math.sin(perpendicularAngle) * headWidth / 2,
    );

    final headPath = Path()
      ..moveTo(p1.dx, p1.dy)
      ..lineTo(p2.dx, p2.dy)
      ..lineTo(p3.dx, p3.dy)
      ..close();

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawPath(headPath, paint);
  }

  @override
  bool shouldRepaint(covariant ArrowPainter oldDelegate) {
    return true;
  }
}