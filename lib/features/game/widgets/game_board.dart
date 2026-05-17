import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../data/models/arrow_model.dart';
import 'arrow_painter.dart';

class GameBoard extends StatefulWidget {
  final List<ArrowModel> arrows;
  final int gridRows;
  final int gridCols;
  final bool showTutorial;
  final String? tutorialMessage;
  final Function(String arrowId) onArrowTapped;

  const GameBoard({
    super.key,
    required this.arrows,
    required this.gridRows,
    required this.gridCols,
    this.showTutorial = false,
    this.tutorialMessage,
    required this.onArrowTapped,
  });

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> with TickerProviderStateMixin {
  final Map<String, AnimationController> _removeControllers = {};
  final Map<String, double> _removeAnimations = {};

  @override
  void didUpdateWidget(GameBoard oldWidget) {
    super.didUpdateWidget(oldWidget);
    for (final ArrowModel arrow in widget.arrows) {
      if (arrow.state == ArrowState.removing &&
          !_removeControllers.containsKey(arrow.id)) {
        _startRemoveAnimation(arrow.id);
      }
    }
  }

  void _startRemoveAnimation(String arrowId) {
    final AnimationController controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );

    controller.addListener(() {
      if (mounted) {
        setState(() => _removeAnimations[arrowId] = controller.value);
      }
    });

    controller.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        _removeControllers.remove(arrowId);
        _removeAnimations.remove(arrowId);
        controller.dispose();
      }
    });

    _removeControllers[arrowId] = controller;
    controller.forward();
  }

  @override
  void dispose() {
    for (final c in _removeControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final double cellSizeW = constraints.maxWidth / widget.gridCols;
      final double cellSizeH = constraints.maxHeight / widget.gridRows;
      final double cellSize = math.min(cellSizeW, cellSizeH).clamp(40.0, 80.0);

      final double boardWidth = cellSize * widget.gridCols;
      final double boardHeight = cellSize * widget.gridRows;

      return Center(
        child: SizedBox(
          width: boardWidth,
          height: boardHeight,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapDown: (TapDownDetails details) =>
                      _handleTap(details.localPosition, cellSize),
                  child: CustomPaint(
                    size: Size(boardWidth, boardHeight),
                    painter: ArrowPainter(
                      arrows: widget.arrows,
                      gridRows: widget.gridRows,
                      gridCols: widget.gridCols,
                      cellSize: cellSize,
                      removeAnimations: _removeAnimations,
                    ),
                  ),
                ),
              ),

              if (widget.showTutorial && widget.tutorialMessage != null)
                _buildTutorialOverlay(cellSize),
            ],
          ),
        ),
      );
    });
  }

  // ── PATH-BASED TAP DETECTION ────────────────────────────────────────
  //
  // Instead of cell-based matching, we measure the distance from the tap
  // point to each arrow's actual path. The arrow with the closest path
  // (within a hit threshold) is selected.

  void _handleTap(Offset tapPosition, double cellSize) {
    final double hitThreshold = cellSize * 0.45; // generous tap area

    ArrowModel? closestArrow;
    double closestDistance = double.infinity;

    for (final ArrowModel arrow in widget.arrows) {
      if (arrow.state != ArrowState.active &&
          arrow.state != ArrowState.highlighted) {
        continue;
      }

      // Get the arrow's path as canvas offsets
      final List<Offset> points =
          arrow.pathPoints.map((gp) => gp.toOffset(cellSize)).toList();

      // Find minimum distance from tap to any segment of the path
      double minDist = double.infinity;
      for (int i = 0; i < points.length - 1; i++) {
        final double d = _distanceToSegment(tapPosition, points[i], points[i + 1]);
        if (d < minDist) minDist = d;
      }

      if (minDist < closestDistance && minDist <= hitThreshold) {
        closestDistance = minDist;
        closestArrow = arrow;
      }
    }

    if (closestArrow != null) {
      debugPrint(
          'Tapped at $tapPosition → arrow ${closestArrow.id} (dist: ${closestDistance.toStringAsFixed(1)})');
      widget.onArrowTapped(closestArrow.id);
    }
  }

  /// Perpendicular distance from point P to line segment AB.
  double _distanceToSegment(Offset p, Offset a, Offset b) {
    final double dx = b.dx - a.dx;
    final double dy = b.dy - a.dy;
    final double lengthSq = dx * dx + dy * dy;

    if (lengthSq == 0) return (p - a).distance;

    // Project P onto AB, clamped to [0, 1]
    double t = ((p.dx - a.dx) * dx + (p.dy - a.dy) * dy) / lengthSq;
    t = t.clamp(0.0, 1.0);

    final Offset projection = Offset(a.dx + t * dx, a.dy + t * dy);
    return (p - projection).distance;
  }

  Widget _buildTutorialOverlay(double cellSize) {
    final List<ArrowModel> activeArrows = widget.arrows
        .where((ArrowModel a) => a.state == ArrowState.active)
        .toList();

    if (activeArrows.isEmpty) return const SizedBox.shrink();

    final ArrowModel targetArrow = activeArrows.first;
    final double cx = targetArrow.col * cellSize + cellSize / 2;
    final double cy = targetArrow.row * cellSize + cellSize / 2;

    return Positioned(
      left: cx - 60,
      top: cy + cellSize * 0.55,
      child: Column(
        children: [
          const Icon(Icons.touch_app_rounded,
              color: Color(0xFF5F6470), size: 38),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF2D8CEB),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              widget.tutorialMessage!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}