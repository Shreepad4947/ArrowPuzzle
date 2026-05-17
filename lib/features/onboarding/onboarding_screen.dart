import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_dimensions.dart';
import '../../data/repositories/user_repository.dart';
import '../../widgets/app_button.dart';
import '../navigation/main_navigation.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingL),
          child: Column(
            children: [
              const Spacer(flex: 3),
              // Welcome Text
              const Text(
                AppStrings.welcomeTitle,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingL),
              // Terms message
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.6,
                    color: AppColors.textSecondary,
                  ),
                  children: [
                    const TextSpan(
                      text: 'Please read and accept our ',
                    ),
                    TextSpan(
                      text: AppStrings.terms,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const TextSpan(text: ' and '),
                    TextSpan(
                      text: AppStrings.privacyPolicy,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const TextSpan(
                      text:
                          ' which set out the terms of use of our app and explain '
                          'how we collect, use and process your information, '
                          'the privacy rights available to you and instructions on '
                          'how you can exercise such privacy rights, otherwise ',
                    ),
                    TextSpan(
                      text: AppStrings.seeOptions,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const TextSpan(text: ' available to you.'),
                  ],
                ),
              ),
              const Spacer(flex: 2),
              // Accept button
              AppButton(
                text: AppStrings.accept,
                onPressed: () async {
                  final userRepo = context.read<UserRepository>();
                  await userRepo.acceptTerms();

                  if (!context.mounted) return;

                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => const MainNavigation(),
                    ),
                  );
                },
              ),
              const SizedBox(height: AppDimensions.paddingL),
            ],
          ),
        ),
      ),
    );
  }
}