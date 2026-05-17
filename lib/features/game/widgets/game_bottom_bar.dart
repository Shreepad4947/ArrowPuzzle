import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

class GameBottomBar extends StatelessWidget {
  final int hintsRemaining;
  final VoidCallback onHint;

  const GameBottomBar({
    super.key,
    required this.hintsRemaining,
    required this.onHint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingXL,
        vertical: AppDimensions.paddingS,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Hint button
          _buildToolButton(
            icon: Icons.lightbulb_outline_rounded,
            badge: hintsRemaining,
            onTap: hintsRemaining > 0 ? onHint : null,
          ),
          const SizedBox(width: 24),
          // Grid/board view button (placeholder)
          _buildToolButton(
            icon: Icons.grid_4x4_rounded,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildToolButton({
    required IconData icon,
    int? badge,
    VoidCallback? onTap,
  }) {
    final isEnabled = onTap != null;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.hintIconBackground,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: isEnabled
                  ? AppColors.primary
                  : AppColors.bottomNavInactive,
              size: 26,
            ),
          ),
          if (badge != null && badge > 0)
            Positioned(
              right: -2,
              top: -2,
              child: Container(
                width: 22,
                height: 22,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$badge',
                    style: const TextStyle(
                      color: AppColors.textWhite,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}