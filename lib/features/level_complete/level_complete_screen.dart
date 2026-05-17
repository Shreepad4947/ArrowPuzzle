import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_dimensions.dart';
import '../../data/models/arrow_model.dart';
import '../../game_engine/game_controller.dart';
import '../../widgets/animated_confetti.dart';
import '../game/game_screen.dart';
import '../navigation/main_navigation.dart';
import '../game/widgets/arrow_painter.dart';

class LevelCompleteScreen extends StatefulWidget {
  const LevelCompleteScreen({super.key});

  @override
  State<LevelCompleteScreen> createState() => _LevelCompleteScreenState();
}

class _LevelCompleteScreenState extends State<LevelCompleteScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeIn),
    );

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.read<GameController>();
    final gameState = controller.gameState;

    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.0,
                colors: [
                  Color(0xFF42A5F5),
                  Color(0xFF1976D2),
                  Color(0xFF0D47A1),
                ],
              ),
            ),
          ),
          // Confetti
          const AnimatedConfetti(isPlaying: true),
          // Content
          SafeArea(
            child: AnimatedBuilder(
              animation: _animController,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeAnimation.value,
                  child: Column(
                    children: [
                      const Spacer(flex: 2),
                      // Title
                      Transform.scale(
                        scale: _scaleAnimation.value,
                        child: const Text(
                          AppStrings.levelCompleted,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textWhite,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      // Completed puzzle preview
                      Transform.scale(
                        scale: _scaleAnimation.value,
                        child: _buildPuzzlePreview(gameState),
                      ),
                      const Spacer(flex: 3),
                      // Buttons
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.paddingXL,
                        ),
                        child: Column(
                          children: [
                            // Next Game button
                            if (controller.hasNextLevel())
                              SizedBox(
                                width: double.infinity,
                                height: 60,
                                child: ElevatedButton(
                                  onPressed: () => _startNextLevel(context),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.textWhite,
                                    foregroundColor: AppColors.primary,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        AppStrings.nextGame,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        '${AppStrings.levelPrefix} ${controller.getNextLevelNumber() ?? ""}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color:
                                              AppColors.primary.withOpacity(0.7),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            const SizedBox(height: 16),
                            // Main button
                            TextButton(
                              onPressed: () => _goToMain(context),
                              child: const Text(
                                AppStrings.main,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textWhite,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppDimensions.paddingXL),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPuzzlePreview(gameState) {
    if (gameState == null) return const SizedBox.shrink();

    // FIX: Use copyWith to preserve existing pathPoints and just
    // change direction + state — no need to pass pathPoints manually.
    final previewArrows = gameState.level.arrows
        .map<ArrowModel>(
          (arrow) => arrow.copyWith(
            direction: ArrowDirection.up,
            state: ArrowState.active,
          ),
        )
        .take(5)
        .toList();

    return Container(
      width: 180,
      height: 180,
      decoration: BoxDecoration(
        color: AppColors.textWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: CustomPaint(
        painter: ArrowPainter(
          arrows: previewArrows,
          gridRows: gameState.level.gridRows,
          gridCols: gameState.level.gridCols,
          cellSize: 180.0 / gameState.level.gridCols.clamp(3, 7),
        ),
      ),
    );
  }

  void _startNextLevel(BuildContext context) {
    final controller = context.read<GameController>();
    final nextLevel = controller.getNextLevelNumber();
    if (nextLevel != null) {
      controller.startLevel(nextLevel);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const GameScreen()),
      );
    }
  }

  void _goToMain(BuildContext context) {
    final controller = context.read<GameController>();
    controller.clearGame();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainNavigation()),
      (_) => false,
    );
  }
}
