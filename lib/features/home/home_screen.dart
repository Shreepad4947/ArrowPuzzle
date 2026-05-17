import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_dimensions.dart';
import '../../game_engine/game_controller.dart';
import '../game/game_screen.dart';
import 'widgets/daily_challenge_card.dart';
import 'widgets/new_game_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: AppDimensions.paddingXL),
                    // Daily Challenge Card
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingXL,
                      ),
                      child: DailyChallengeCard(
                        onPlay: () => _startDailyChallenge(context),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.paddingXXL),
                    // Background arrow decorations
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Decorative background arrows
                        Opacity(
                          opacity: 0.05,
                          child: Icon(
                            Icons.arrow_forward_rounded,
                            size: 200,
                            color: AppColors.primary,
                          ),
                        ),
                        // App Title
                        Column(
                          children: [
                            Text(
                              AppStrings.appTagline,
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Puzzle Escape',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textSecondary,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.paddingXXL),
                  ],
                ),
              ),
            ),
            // New Game Button
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingXL,
              ),
              child: Consumer<GameController>(
                builder: (context, controller, _) {
                  return NewGameButton(
                    level: controller.currentUserLevel,
                    onPressed: () => _startNewGame(context),
                  );
                },
              ),
            ),
            const SizedBox(height: AppDimensions.paddingL),
          ],
        ),
      ),
    );
  }

  void _startNewGame(BuildContext context) {
    final controller = context.read<GameController>();
    final level = controller.currentUserLevel;
    controller.startLevel(level);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const GameScreen(),
      ),
    );
  }

  void _startDailyChallenge(BuildContext context) {
    final controller = context.read<GameController>();
    controller.startDailyChallenge(DateTime.now());

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const GameScreen(isDailyChallenge: true),
      ),
    );
  }
}