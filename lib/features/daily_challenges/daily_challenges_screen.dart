import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_dimensions.dart';
import '../../data/repositories/user_repository.dart';
import '../../game_engine/game_controller.dart';
import '../../widgets/app_button.dart';
import '../game/game_screen.dart';
import 'widgets/calendar_widget.dart';

class DailyChallengesScreen extends StatefulWidget {
  const DailyChallengesScreen({super.key});

  @override
  State<DailyChallengesScreen> createState() => _DailyChallengesScreenState();
}

class _DailyChallengesScreenState extends State<DailyChallengesScreen> {
  late DateTime _displayMonth;
  bool _showWelcome = false;

  @override
  void initState() {
    super.initState();
    _displayMonth = DateTime.now();

    // Check if should show welcome dialog
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userRepo = context.read<UserRepository>();
      if (!userRepo.hasSeenDailyWelcome) {
        setState(() {
          _showWelcome = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userRepo = context.read<UserRepository>();
    final now = DateTime.now();
    final daysInMonth = DateTime(_displayMonth.year, _displayMonth.month + 1, 0).day;
    final starsForMonth = userRepo.getDailyStarsForMonth(
      _displayMonth.year,
      _displayMonth.month,
    );

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: Stack(
        children: [
          Column(
            children: [
              // Header with trophy
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 10,
                  bottom: 20,
                ),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF1565C0),
                      Color(0xFF1976D2),
                      Color(0xFF2196F3),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  children: [
                    // Title
                    const Text(
                      AppStrings.dailyChallenges,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textWhite,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Trophy icon
                    Icon(
                      Icons.emoji_events_rounded,
                      color: AppColors.starGold.withOpacity(0.9),
                      size: 80,
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
              // Calendar section
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.paddingM),
                  child: Column(
                    children: [
                      // Month header with star count
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                onPressed: () => _changeMonth(-1),
                                icon: const Icon(
                                  Icons.chevron_left_rounded,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                _getMonthYearString(),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              IconButton(
                                onPressed: () => _changeMonth(1),
                                icon: const Icon(
                                  Icons.chevron_right_rounded,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                color: AppColors.starGold,
                                size: 22,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '$starsForMonth/$daysInMonth',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Calendar
                      Expanded(
                        child: CalendarWidget(
                          displayMonth: _displayMonth,
                          completedDates: _getCompletedDates(userRepo),
                          today: now,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Play button
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingXL,
                ),
                child: AppButton(
                  text: AppStrings.play,
                  onPressed: () => _startDailyChallenge(context),
                ),
              ),
              const SizedBox(height: AppDimensions.paddingL),
            ],
          ),
          // Welcome dialog overlay
          if (_showWelcome) _buildWelcomeDialog(),
        ],
      ),
    );
  }

  Set<int> _getCompletedDates(UserRepository userRepo) {
    final completed = <int>{};
    final daysInMonth =
        DateTime(_displayMonth.year, _displayMonth.month + 1, 0).day;

    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_displayMonth.year, _displayMonth.month, day);
      if (userRepo.isDailyChallengeCompleted(date)) {
        completed.add(day);
      }
    }

    return completed;
  }

  String _getMonthYearString() {
    final months = [
      '', 'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return '${months[_displayMonth.month]} ${_displayMonth.year}';
  }

  void _changeMonth(int delta) {
    setState(() {
      _displayMonth = DateTime(
        _displayMonth.year,
        _displayMonth.month + delta,
      );
    });
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

  Widget _buildWelcomeDialog() {
    return Container(
      color: AppColors.dialogBarrier,
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 40),
          padding: const EdgeInsets.all(AppDimensions.paddingL),
          decoration: BoxDecoration(
            color: AppColors.backgroundWhite,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                AppStrings.welcomeToDailyChallenges,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 24),
              // Star icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.starGold.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.star_rounded,
                  color: AppColors.starGold,
                  size: 60,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                AppStrings.dailyChallengeMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () async {
                    final userRepo = context.read<UserRepository>();
                    await userRepo.setDailyWelcomeSeen();
                    setState(() {
                      _showWelcome = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text(
                    AppStrings.continueText,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textWhite,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}