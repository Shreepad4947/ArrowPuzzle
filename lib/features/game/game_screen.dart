import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../game_engine/game_controller.dart';
import '../level_complete/level_complete_screen.dart';
import '../settings/options_screen.dart';
import 'widgets/game_board.dart';
import 'widgets/game_top_bar.dart';
import 'widgets/game_bottom_bar.dart';
import 'widgets/out_of_lives_dialog.dart';

class GameScreen extends StatefulWidget {
  final bool isDailyChallenge;

  const GameScreen({super.key, this.isDailyChallenge = false});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameController>(
      builder: (context, controller, _) {
        final gameState = controller.gameState;

        if (gameState == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Check for level complete
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (gameState.isCompleted) {
            _showLevelComplete(context);
          } else if (gameState.isFailed) {
            _showOutOfLives(context);
          }
        });

        final levelTitle = widget.isDailyChallenge
            ? _getDailyTitle()
            : '${gameState.level.levelNumber > 0 ? "Level ${gameState.level.levelNumber}" : ""}';

        return Scaffold(
          backgroundColor: AppColors.backgroundGame,
          body: SafeArea(
            child: Column(
              children: [
                // Top Bar
                GameTopBar(
                  title: levelTitle,
                  lives: gameState.livesRemaining,
                  flagCount: gameState.flagCount,
                  difficulty: gameState.level.difficultyLabel,
                  showTutorial: gameState.level.showTutorial,
                  onBack: () => Navigator.of(context).pop(),
                  onSettings: () => _showOptions(context),
                ),
                // Game Board
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppDimensions.boardPadding),
                      child: GameBoard(
                        arrows: gameState.currentArrows,
                        gridRows: gameState.level.gridRows,
                        gridCols: gameState.level.gridCols,
                        showTutorial: gameState.level.showTutorial,
                        tutorialMessage: gameState.level.tutorialMessage,
                        onArrowTapped: (arrowId) {
                          controller.onArrowTapped(arrowId);
                        },
                      ),
                    ),
                  ),
                ),
                // Bottom Bar
                GameBottomBar(
                  hintsRemaining: gameState.hintsRemaining,
                  onHint: () => controller.useHint(),
                ),
                const SizedBox(height: AppDimensions.paddingM),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getDailyTitle() {
    final now = DateTime.now();
    final months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[now.month]} ${now.day}';
  }

  bool _isDialogShowing = false;

  void _showLevelComplete(BuildContext context) {
    if (_isDialogShowing) return;
    _isDialogShowing = true;

    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const LevelCompleteScreen(),
        ),
      );
      _isDialogShowing = false;
    });
  }

  void _showOutOfLives(BuildContext context) {
    if (_isDialogShowing) return;
    _isDialogShowing = true;

    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => OutOfLivesDialog(
          onGetMoreLives: () {
            final controller = context.read<GameController>();
            controller.addExtraLife();
            Navigator.of(context).pop();
            _isDialogShowing = false;
          },
          onRestart: () {
            final controller = context.read<GameController>();
            controller.restartLevel();
            Navigator.of(context).pop();
            _isDialogShowing = false;
          },
        ),
      ).then((_) {
        _isDialogShowing = false;
      });
    });
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const OptionsScreen(),
    );
  }
}