import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_dimensions.dart';
import '../profile/widgets/profile_menu_item.dart';

class OptionsScreen extends StatelessWidget {
  const OptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingM,
              vertical: AppDimensions.paddingS,
            ),
            child: Row(
              children: [
                const Spacer(),
                const Text(
                  AppStrings.options,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    AppStrings.done,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textRed,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Settings section
          _buildSection(
            children: [
              ProfileMenuItem(
                icon: Icons.settings_rounded,
                iconColor: AppColors.primary,
                title: AppStrings.settings,
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingM),
          // Info section
          _buildSection(
            children: [
              ProfileMenuItem(
                icon: Icons.help_outline_rounded,
                iconColor: const Color(0xFF4CAF50),
                title: AppStrings.help,
                onTap: () {},
              ),
              const Divider(height: 1, indent: 56),
              ProfileMenuItem(
                icon: Icons.info_outline_rounded,
                iconColor: AppColors.primary,
                title: AppStrings.aboutGame,
                onTap: () {},
              ),
              const Divider(height: 1, indent: 56),
              ProfileMenuItem(
                icon: Icons.privacy_tip_outlined,
                iconColor: const Color(0xFF7C4DFF),
                title: AppStrings.privacyRights,
                onTap: () {},
              ),
              const Divider(height: 1, indent: 56),
              ProfileMenuItem(
                icon: Icons.people_outline_rounded,
                iconColor: const Color(0xFF00BCD4),
                title: AppStrings.privacyPreferences,
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingM),
          // Remove ads
          _buildSection(
            children: [
              ProfileMenuItem(
                icon: Icons.block_rounded,
                iconColor: AppColors.arrowWrong,
                title: AppStrings.removeAds,
                onTap: () {},
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
        ],
      ),
    );
  }

  Widget _buildSection({required List<Widget> children}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}