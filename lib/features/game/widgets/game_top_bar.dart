import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

class GameTopBar extends StatelessWidget {
  final String title;
  final int lives;
  final int flagCount;
  final String difficulty;
  final bool showTutorial;
  final VoidCallback onBack;
  final VoidCallback onSettings;

  const GameTopBar({
    super.key,
    required this.title,
    required this.lives,
    required this.flagCount,
    required this.difficulty,
    required this.showTutorial,
    required this.onBack,
    required this.onSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Title row
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingS,
            vertical: AppDimensions.paddingS,
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: onBack,
                icon: const Icon(
                  Icons.chevron_left_rounded,
                  color: AppColors.primary,
                  size: 32,
                ),
              ),
              Expanded(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              IconButton(
                onPressed: onSettings,
                icon: const Icon(
                  Icons.settings_outlined,
                  color: AppColors.primary,
                  size: 26,
                ),
              ),
            ],
          ),
        ),
        // Stats row (only if not tutorial)
        if (!showTutorial)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingM,
            ),
            child: Row(
              children: [
                // Flag counter
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.flag_rounded,
                        color: AppColors.textPrimary,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$flagCount',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                // Hearts
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: _buildHeart(index < lives),
                      );
                    }),
                  ),
                ),
                // Difficulty
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    difficulty,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildHeart(bool isFull) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Icon(
        isFull ? Icons.favorite_rounded : Icons.favorite_border_rounded,
        key: ValueKey('heart_$isFull'),
        color: isFull ? AppColors.heartFull : AppColors.heartEmpty,
        size: AppDimensions.heartSize,
      ),
    );
  }
}