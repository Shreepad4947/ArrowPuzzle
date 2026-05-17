import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppStyles {
  AppStyles._();

  static const TextStyle heading1 = TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.textPrimary, letterSpacing: -0.5);
  static const TextStyle heading2 = TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.textPrimary, letterSpacing: -0.3);
  static const TextStyle heading3 = TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textPrimary);
  static const TextStyle bodyLarge = TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: AppColors.textPrimary);
  static const TextStyle bodyMedium = TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.textPrimary);
  static const TextStyle bodySmall = TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textSecondary);
  static const TextStyle labelLarge = TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textWhite);
  static const TextStyle labelMedium = TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textSecondary);
  static const TextStyle labelSmall = TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.textSecondary);
  static const TextStyle buttonLarge = TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textWhite);
  static const TextStyle buttonMedium = TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textWhite);
  static const TextStyle levelTitle = TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary);
  static const TextStyle levelSubtitle = TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textWhite);
  static const TextStyle moveCounter = TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary);
  static const TextStyle difficultyLabel = TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary);
  static const TextStyle celebrationTitle = TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: AppColors.textWhite, letterSpacing: -0.5);
  static const TextStyle calendarDay = TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.textPrimary);
  static const TextStyle calendarHeader = TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textSecondary);
  static const TextStyle calendarMonth = TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary);
  static const TextStyle dialogTitle = TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textPrimary);
  static const TextStyle dialogBody = TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.textSecondary);
  static const TextStyle menuItem = TextStyle(fontSize: 17, fontWeight: FontWeight.w400, color: AppColors.textPrimary);
}
