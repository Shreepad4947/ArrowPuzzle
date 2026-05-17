import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_dimensions.dart';
import 'widgets/profile_menu_item.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppDimensions.paddingM),
              color: AppColors.backgroundWhite,
              child: const Text(
                AppStrings.me,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.paddingM),
            // Awards
            _buildSection(
              children: [
                ProfileMenuItem(
                  icon: Icons.emoji_events_rounded,
                  iconColor: AppColors.starGold,
                  title: AppStrings.awards,
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.paddingM),
            // Settings
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
            // Remove Ads
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
          ],
        ),
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
      child: Column(
        children: children,
      ),
    );
  }
}