import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Animated hint effect (pulsing glow) around an arrow
class HintEffect extends StatefulWidget {
  final Offset position;
  final double size;

  const HintEffect({
    super.key,
    required this.position,
    required this.size,
  });

  @override
  State<HintEffect> createState() => _HintEffectState();
}

class _HintEffectState extends State<HintEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.position.dx - widget.size / 2,
      top: widget.position.dy - widget.size / 2,
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.arrowHint
                  .withOpacity(0.2 * _pulseAnimation.value),
              border: Border.all(
                color: AppColors.arrowHint
                    .withOpacity(0.5 * _pulseAnimation.value),
                width: 2,
              ),
            ),
          );
        },
      ),
    );
  }
}