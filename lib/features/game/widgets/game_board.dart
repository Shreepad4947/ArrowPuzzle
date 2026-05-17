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

    for (final arrow in widget.arrows) {
      if (arrow.state == ArrowState.removing &&
          !_removeControllers.containsKey(arrow.id)) {
        _startRemoveAnimation(arrow.id);
      }
    }
  }

  void _startRemoveAnimation(String arrowId) {
    final controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );

    controller.addListener(() {
      if (mounted) {
        setState(() {
          _removeAnimations[arrowId] = controller.value;
        });
      }
    });

    controller.addStatusListener((status) {
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
    for (final controller in _removeControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final maxHeight = constraints.maxHeight;

        final cellSizeW = maxWidth / widget.gridCols;
        final cellSizeH = maxHeight / widget.gridRows;
        final rawCellSize = math.min(cellSizeW, cellSizeH);

        final cellSize = rawCellSize.clamp(44.0, 72.0);

        final boardWidth = cellSize * widget.gridCols;
        final boardHeight = cellSize * widget.gridRows;

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
                    onTapDown: (details) {
                      _handleTap(details.localPosition, cellSize);
                    },
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
      },
    );
  }

  void _handleTap(Offset tapPosition, double cellSize) {
    ArrowModel? nearestArrow;
    double nearestDistance = double.infinity;

    final hitRadius = cellSize * 0.36;

    for (final arrow in widget.arrows) {
      if (arrow.state != ArrowState.active &&
          arrow.state != ArrowState.highlighted) {
        continue;
      }

      final distance = _distanceToArrowPath(
        tapPosition,
        arrow,
        cellSize,
      );

      if (distance <= hitRadius && distance < nearestDistance) {
        nearestDistance = distance;
        nearestArrow = arrow;
      }
    }

    if (nearestArrow != null) {
      debugPrint('Tapped arrow: ${nearestArrow.id}');
      widget.onArrowTapped(nearestArrow.id);
    }
  }

  double _distanceToArrowPath(
    Offset tap,
    ArrowModel arrow,
    double cellSize,
  ) {
    final points = arrow.pathPoints.map((p) => p.toOffset(cellSize)).toList();

    if (points.length < 2) {
      return (tap - arrow.getCenter(cellSize)).distance;
    }

    double minDistance = double.infinity;

    for (int i = 0; i < points.length - 1; i++) {
      final distance = _distanceToSegment(
        tap,
        points[i],
        points[i + 1],
      );

      if (distance < minDistance) {
        minDistance = distance;
      }
    }

    return minDistance;
  }

  double _distanceToSegment(Offset point, Offset start, Offset end) {
    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;

    final lengthSquared = dx * dx + dy * dy;

    if (lengthSquared == 0) {
      return (point - start).distance;
    }

    double t = ((point.dx - start.dx) * dx + (point.dy - start.dy) * dy) /
        lengthSquared;

    t = t.clamp(0.0, 1.0);

    final projection = Offset(
      start.dx + t * dx,
      start.dy + t * dy,
    );

    return (point - projection).distance;
  }

  Widget _buildTutorialOverlay(double cellSize) {
    final activeArrows =
        widget.arrows.where((a) => a.state == ArrowState.active).toList();

    if (activeArrows.isEmpty) {
      return const SizedBox.shrink();
    }

    ArrowModel targetArrow;

    if (activeArrows.length >= 2) {
      targetArrow = activeArrows[1];
    } else {
      targetArrow = activeArrows.first;
    }

    final center = targetArrow.getCenter(cellSize);

    return Positioned(
      left: center.dx - 58,
      top: center.dy + cellSize * 0.45,
      child: Column(
        children: [
          const Icon(
            Icons.touch_app_rounded,
            color: Color(0xFF5F6470),
            size: 42,
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 10,
            ),
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