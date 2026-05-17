import 'dart:math';
import 'package:flutter/material.dart';

class AnimatedConfetti extends StatefulWidget {
  final bool isPlaying;

  const AnimatedConfetti({super.key, this.isPlaying = true});

  @override
  State<AnimatedConfetti> createState() => _AnimatedConfettiState();
}

class _AnimatedConfettiState extends State<AnimatedConfetti>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  final List<ConfettiPiece> _pieces = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _generatePieces();

    if (widget.isPlaying) {
      _controller.repeat();
    }
  }

  void _generatePieces() {
    final colors = [
      const Color(0xFFFF6B8A),
      const Color(0xFF4CAF50),
      const Color(0xFFFFC107),
      const Color(0xFF2196F3),
      const Color(0xFFE040FB),
      const Color(0xFF00BCD4),
      const Color(0xFFFF9800),
      const Color(0xFF8BC34A),
    ];

    for (int i = 0; i < 80; i++) {
      _pieces.add(ConfettiPiece(
        x: _random.nextDouble(),
        y: _random.nextDouble() * -1,
        speed: 0.2 + _random.nextDouble() * 0.6,
        angle: _random.nextDouble() * 2 * pi,
        rotationSpeed: (_random.nextDouble() - 0.5) * 10,
        size: 6 + _random.nextDouble() * 10,
        color: colors[_random.nextInt(colors.length)],
        shape: _random.nextInt(3), // 0=rect, 1=circle, 2=triangle
        wobble: _random.nextDouble() * 2,
      ));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isPlaying) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          size: Size.infinite,
          painter: ConfettiPainter(
            pieces: _pieces,
            progress: _controller.value,
          ),
        );
      },
    );
  }
}

class ConfettiPiece {
  final double x;
  final double y;
  final double speed;
  final double angle;
  final double rotationSpeed;
  final double size;
  final Color color;
  final int shape;
  final double wobble;

  ConfettiPiece({
    required this.x,
    required this.y,
    required this.speed,
    required this.angle,
    required this.rotationSpeed,
    required this.size,
    required this.color,
    required this.shape,
    required this.wobble,
  });
}

class ConfettiPainter extends CustomPainter {
  final List<ConfettiPiece> pieces;
  final double progress;

  ConfettiPainter({required this.pieces, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (final piece in pieces) {
      final currentY = (piece.y + progress * piece.speed * 2) % 1.3 - 0.15;
      final currentX =
          piece.x + sin(progress * pi * 2 * piece.wobble + piece.angle) * 0.05;

      final x = currentX * size.width;
      final y = currentY * size.height;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(progress * piece.rotationSpeed);

      final paint = Paint()
        ..color = piece.color.withOpacity(
          (1 - (currentY / 1.3)).clamp(0.0, 1.0),
        )
        ..style = PaintingStyle.fill;

      switch (piece.shape) {
        case 0: // Rectangle
          canvas.drawRect(
            Rect.fromCenter(
              center: Offset.zero,
              width: piece.size,
              height: piece.size * 0.6,
            ),
            paint,
          );
          break;
        case 1: // Circle
          canvas.drawCircle(Offset.zero, piece.size * 0.4, paint);
          break;
        case 2: // Triangle-like
          final path = Path()
            ..moveTo(0, -piece.size * 0.4)
            ..lineTo(piece.size * 0.4, piece.size * 0.4)
            ..lineTo(-piece.size * 0.4, piece.size * 0.4)
            ..close();
          canvas.drawPath(path, paint);
          break;
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant ConfettiPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}