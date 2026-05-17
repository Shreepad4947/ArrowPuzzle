import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../data/models/arrow_model.dart';
import 'arrow_painter.dart';

/// The interactive game board widget.
/// Renders a grid of arrows via [ArrowPainter] and handles tap detection.
///
/// Tap detection is cell-based: the tapped cell (row, col) is computed
/// from the tap position, then matched against arrows at that cell.
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
      duration: const Duration(milliseconds: 380),
    );
    controller.addListener(() {
      if (mounted) setState(() => _removeAnimations[arrowId] = controller.value);
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
    for (final c in _removeControllers.values) c.dispose();
    super.dispose();
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      // Compute cell size — fit the board inside the available space
      final cellSizeW = constraints.maxWidth / widget.gridCols;
      final cellSizeH = constraints.maxHeight / widget.gridRows;
      final cellSize = math.min(cellSizeW, cellSizeH).clamp(40.0, 80.0);

      final boardWidth = cellSize * widget.gridCols;
      final boardHeight = cellSize * widget.gridRows;

      return Center(
        child: SizedBox(
          width: boardWidth,
          height: boardHeight,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // ── Board (dots + arrows) ──────────────────────────────────
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapDown: (details) =>
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

              // ── Tutorial overlay ───────────────────────────────────────
              if (widget.showTutorial && widget.tutorialMessage != null)
                _buildTutorialOverlay(cellSize),
            ],
          ),
        ),
      );
    });
  }

  // ── Tap handling ──────────────────────────────────────────────────────────

  /// Convert tap pixel position → grid cell → find arrow in that cell.
  void _handleTap(Offset tapPosition, double cellSize) {
    // Which cell was tapped?
    final col = (tapPosition.dx / cellSize).floor();
    final row = (tapPosition.dy / cellSize).floor();

    // Bounds check
    if (row < 0 || row >= widget.gridRows || col < 0 || col >= widget.gridCols) {
      return;
    }

    // Find an active arrow in that cell
    final arrow = widget.arrows.where((a) {
      return a.row == row &&
          a.col == col &&
          (a.state == ArrowState.active || a.state == ArrowState.highlighted);
    }).firstOrNull;

    if (arrow != null) {
      debugPrint('Tapped cell ($row,$col) → arrow ${arrow.id}');
      widget.onArrowTapped(arrow.id);
    }
  }

  // ── Tutorial overlay ──────────────────────────────────────────────────────

  Widget _buildTutorialOverlay(double cellSize) {
    final activeArrows =
        widget.arrows.where((a) => a.state == ArrowState.active).toList();
    if (activeArrows.isEmpty) return const SizedBox.shrink();

    // Point at the first active arrow
    final targetArrow = activeArrows.first;
    final cx = targetArrow.col * cellSize + cellSize / 2;
    final cy = targetArrow.row * cellSize + cellSize / 2;

    return Positioned(
      left: cx - 60,
      top: cy + cellSize * 0.55,
      child: Column(
        children: [
          const Icon(Icons.touch_app_rounded, color: Color(0xFF5F6470), size: 38),
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
