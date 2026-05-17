import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_dimensions.dart';

class AppButton extends StatelessWidget {
  final String text;
  final String? subtitle;
  final VoidCallback onPressed;
  final bool isOutlined;
  final double? width;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;

  const AppButton({
    super.key,
    required this.text,
    this.subtitle,
    required this.onPressed,
    this.isOutlined = false,
    this.width,
    this.icon,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: subtitle != null ? 64 : AppDimensions.buttonHeight,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isOutlined
              ? Colors.transparent
              : (backgroundColor ?? AppColors.buttonPrimary),
          foregroundColor: isOutlined
              ? AppColors.primary
              : (textColor ?? AppColors.buttonText),
          elevation: isOutlined ? 0 : 0,
          side: isOutlined
              ? const BorderSide(color: AppColors.primary, width: 2)
              : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.buttonRadius),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingL,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20),
              const SizedBox(width: 8),
            ],
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: isOutlined
                        ? AppColors.primary
                        : (textColor ?? AppColors.buttonText),
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: isOutlined
                          ? AppColors.primary.withOpacity(0.7)
                          : (textColor ?? AppColors.buttonText)
                              .withOpacity(0.8),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}