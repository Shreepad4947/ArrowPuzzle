import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/arrow_model.dart';

/// Paints Easybrain-style arrows:
///  • Tails and tips land EXACTLY on matrix grid dots
///  • Continuous polyline body with sharp 90° corners
///  • Thin premium stroke
///  • Travels along its own path on removal
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

  // ── PREMIUM STYLE CONSTANTS ──────────────────────────────────────────
  static const double _dotRadius = 2.0;          // small grid dots
  static const double _strokeWidthRatio = 0.065; // thin stroke
  static const double _headLengthRatio = 0.22;
  static const double _headWidthRatio = 0.15;

  // NOTE: NO _pathPadding — tails and tips land exactly on grid dots ✓

  @override
  void paint(Canvas canvas, Size size) {
    _drawFullGridDots(canvas);

    for (final ArrowModel arrow in arrows) {
      if (arrow.state == ArrowState.removed) continue;

      if (arrow.state == ArrowState.removing &&
          !removeAnimations.containsKey(arrow.id)) {
        continue;
      }

      _paintArrow(canvas, arrow);
    }
  }

  void _drawFullGridDots(Canvas canvas) {
    final Paint paint = Paint()
      ..color = AppColors.primaryLight.withOpacity(0.28)
      ..style = PaintingStyle.fill;

    for (int row = 0; row < gridRows; row++) {
      for (int col = 0; col < gridCols; col++) {
        canvas.drawCircle(
          Offset(
            col * cellSize + cellSize / 2,
            row * cellSize + cellSize / 2,
          ),
          _dotRadius,
          paint,
        );
      }
    }
  }

  void _paintArrow(Canvas canvas, ArrowModel arrow) {
    // ✅ Use raw path points — NO shrinking. Tails/tips on grid dots.
    final List<Offset> originalPoints =
        arrow.pathPoints.map((gp) => gp.toOffset(cellSize)).toList();

    if (originalPoints.length < 2) return;

    double opacity = 1.0;
    double travelDistance = 0.0;

    if (arrow.state == ArrowState.removing) {
      final double progress = removeAnimations[arrow.id] ?? 0.0;
      opacity = (1.0 - progress * 0.3).clamp(0.0, 1.0);

      final double pathLength = _computePathLength(originalPoints);
      final double extraExit = cellSize * 1.5;
      travelDistance = (pathLength + extraExit) * progress;
    }

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

    final Color color = baseColor.withOpacity(opacity);

    canvas.save();

    if (arrow.state == ArrowState.highlighted) {
      _drawContinuousGlow(canvas, originalPoints, color);
    }

    if (arrow.state == ArrowState.removing) {
      _drawAnimatedArrow(canvas, arrow, originalPoints, travelDistance, color);
    } else {
      _drawStaticArrow(canvas, originalPoints, color);
    }

    canvas.restore();
  }

  void _drawStaticArrow(Canvas canvas, List<Offset> points, Color color) {
    _drawContinuousPath(canvas, points, color, withArrowHead: true);
  }

  void _drawAnimatedArrow(
    Canvas canvas,
    ArrowModel arrow,
    List<Offset> originalPoints,
    double travelDistance,
    Color color,
  ) {
    final List<Offset> extendedPoints = List<Offset>.from(originalPoints);
    final Offset dir = arrow.directionOffset;
    final Offset lastPoint = extendedPoints.last;
    extendedPoints.add(lastPoint + Offset(dir.dx, dir.dy) * cellSize * 3);

    final double totalOriginalLength = _computePathLength(originalPoints);

    final List<Offset> visiblePath = _extractSubPath(
      extendedPoints,
      travelDistance,
      totalOriginalLength + travelDistance,
    );

    if (visiblePath.length < 2) return;

    _drawContinuousPath(canvas, visiblePath, color, withArrowHead: true);
  }

  void _drawContinuousPath(
    Canvas canvas,
    List<Offset> points,
    Color color, {
    bool withArrowHead = false,
  }) {
    if (points.length < 2) return;

    final double strokeWidth = cellSize * _strokeWidthRatio;
    final Paint bodyPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.miter;

    final List<Offset> drawPoints = List<Offset>.from(points);

    if (withArrowHead) {
      final Offset last = drawPoints.last;
      final Offset prev = drawPoints[drawPoints.length - 2];
      final Offset segDir = last - prev;
      final double segLen = segDir.distance;

      if (segLen > 0) {
        final double shortenBy = cellSize * _headLengthRatio * 0.55;
        drawPoints[drawPoints.length - 1] =
            last - (segDir / segLen) * math.min(shortenBy, segLen * 0.6);
      }
    }

    final Path path = Path()..moveTo(drawPoints.first.dx, drawPoints.first.dy);
    for (int i = 1; i < drawPoints.length; i++) {
      path.lineTo(drawPoints[i].dx, drawPoints[i].dy);
    }
    canvas.drawPath(path, bodyPaint);

    if (withArrowHead) {
      _drawArrowHead(canvas, points[points.length - 2], points.last, color);
    }
  }

  void _drawArrowHead(Canvas canvas, Offset prev, Offset tip, Color color) {
    final Offset dir = tip - prev;
    final double len = dir.distance;
    if (len == 0) return;

    final Offset unitDir = dir / len;
    final Offset unitPerp = Offset(-unitDir.dy, unitDir.dx);

    final double headLength = cellSize * _headLengthRatio;
    final double headHalfWidth = cellSize * _headWidthRatio;

    final Offset baseLeft = tip - unitDir * headLength + unitPerp * headHalfWidth;
    final Offset baseRight =
        tip - unitDir * headLength - unitPerp * headHalfWidth;

    final Path headPath = Path()
      ..moveTo(tip.dx, tip.dy)
      ..lineTo(baseLeft.dx, baseLeft.dy)
      ..lineTo(baseRight.dx, baseRight.dy)
      ..close();

    final Paint headPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawPath(headPath, headPaint);
  }

  void _drawContinuousGlow(Canvas canvas, List<Offset> points, Color color) {
    final Paint glowPaint = Paint()
      ..color = color.withOpacity(0.18)
      ..strokeWidth = cellSize * 0.22
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, cellSize * 0.12);

    final Path glowPath = Path()..moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      glowPath.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(glowPath, glowPaint);
  }

  double _computePathLength(List<Offset> points) {
    double total = 0;
    for (int i = 1; i < points.length; i++) {
      total += (points[i] - points[i - 1]).distance;
    }
    return total;
  }

  Offset? _pointAtDistance(List<Offset> points, double distance) {
    if (distance < 0) return points.first;
    double accum = 0;
    for (int i = 1; i < points.length; i++) {
      final double segLen = (points[i] - points[i - 1]).distance;
      if (accum + segLen >= distance) {
        final double t = (distance - accum) / segLen;
        return Offset.lerp(points[i - 1], points[i], t);
      }
      accum += segLen;
    }
    return points.last;
  }

  List<Offset> _extractSubPath(
      List<Offset> points, double startDist, double endDist) {
    if (startDist >= endDist) return [];

    final List<Offset> result = [];
    double accum = 0;
    bool started = false;

    final Offset? startPoint = _pointAtDistance(points, startDist);
    if (startPoint == null) return [];
    result.add(startPoint);

    for (int i = 1; i < points.length; i++) {
      final double segLen = (points[i] - points[i - 1]).distance;
      final double segEnd = accum + segLen;

      if (!started && segEnd > startDist) {
        started = true;
      }

      if (started) {
        if (segEnd >= endDist) {
          final Offset? endPoint = _pointAtDistance(points, endDist);
          if (endPoint != null) result.add(endPoint);
          break;
        } else if (segEnd > startDist) {
          result.add(points[i]);
        }
      }

      accum += segLen;
    }

    return result;
  }

  @override
  bool shouldRepaint(covariant ArrowPainter oldDelegate) {
    return oldDelegate.arrows != arrows ||
        oldDelegate.removeAnimations != removeAnimations ||
        oldDelegate.cellSize != cellSize;
  }
}