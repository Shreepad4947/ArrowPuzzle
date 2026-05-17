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
  bool _tutorialDismissed = false;

  @override
  void didUpdateWidget(GameBoard oldWidget) {
    super.didUpdateWidget(oldWidget);
    for (final ArrowModel arrow in widget.arrows) {
      if (arrow.state == ArrowState.removing) {
        if (!_tutorialDismissed) {
          setState(() {
            _tutorialDismissed = true;
          });
        }
        
        if (!_removeControllers.containsKey(arrow.id)) {
          _startRemoveAnimation(arrow.id);
        }
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
      final double cellSize = math.min(cellSizeW, cellSizeH).clamp(40.0, 100.0);

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

              if (widget.showTutorial && widget.tutorialMessage != null && !_tutorialDismissed)
                IgnorePointer(
                  child: _buildTutorialOverlay(cellSize, boardWidth, boardHeight),
                ),
            ],
          ),
        ),
      );
    });
  }

  void _handleTap(Offset tapPosition, double cellSize) {
    final double hitThreshold = cellSize * 0.5; 

    ArrowModel? closestArrow;
    double closestDistance = double.infinity;

    for (final ArrowModel arrow in widget.arrows) {
      if (arrow.state != ArrowState.active &&
          arrow.state != ArrowState.highlighted) {
        continue;
      }

      final List<Offset> points =
          arrow.pathPoints.map((gp) => gp.toOffset(cellSize)).toList();

      double minDist = double.infinity;

      for (int i = 0; i < points.length - 1; i++) {
        final double d = _distanceToSegment(tapPosition, points[i], points[i + 1]);
        if (d < minDist) minDist = d;
      }
      
      for (final p in points) {
        final double d = (tapPosition - p).distance;
        if (d < minDist) minDist = d;
      }

      if (minDist < closestDistance && minDist <= hitThreshold) {
        closestDistance = minDist;
        closestArrow = arrow;
      }
    }

    if (closestArrow != null) {
      widget.onArrowTapped(closestArrow.id);
    }
  }

  double _distanceToSegment(Offset p, Offset a, Offset b) {
    final double dx = b.dx - a.dx;
    final double dy = b.dy - a.dy;
    final double lengthSq = dx * dx + dy * dy;
    if (lengthSq == 0) return (p - a).distance;
    double t = ((p.dx - a.dx) * dx + (p.dy - a.dy) * dy) / lengthSq;
    t = t.clamp(0.0, 1.0);
    final Offset projection = Offset(a.dx + t * dx, a.dy + t * dy);
    return (p - projection).distance;
  }

  Widget _buildTutorialOverlay(double cellSize, double boardWidth, double boardHeight) {
    // For Level 1 (3x3), the middle arrow is exactly at column 1.
    // We want the hand at the center dot (1, 1).
    final double cx = 1.5 * cellSize;
    final double cy = 1.5 * cellSize;

    const double iconSize = 38.0;
    const double containerWidth = 200.0;

    return Stack(
      children: [
        // Hand Icon centered exactly on (1,1)
        Positioned(
          left: cx - (iconSize / 2),
          top: cy - (iconSize / 2),
          child: const Icon(
            Icons.touch_app_rounded,
            color: Color(0xFF5F6470),
            size: iconSize,
          ),
        ),
        // Tutorial Message centered below the Icon
        Positioned(
          left: cx - (containerWidth / 2),
          top: cy + (iconSize / 2) + 8,
          width: containerWidth,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF2D8CEB),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              widget.tutorialMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
