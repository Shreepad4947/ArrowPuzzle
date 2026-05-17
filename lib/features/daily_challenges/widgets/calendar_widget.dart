import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class CalendarWidget extends StatelessWidget {
  final DateTime displayMonth;
  final Set<int> completedDates;
  final DateTime today;

  const CalendarWidget({
    super.key,
    required this.displayMonth,
    required this.completedDates,
    required this.today,
  });

  @override
  Widget build(BuildContext context) {
    final daysInMonth =
        DateTime(displayMonth.year, displayMonth.month + 1, 0).day;
    final firstWeekday =
        DateTime(displayMonth.year, displayMonth.month, 1).weekday % 7;

    return Column(
      children: [
        // Day headers
        Row(
          children: ['S', 'M', 'T', 'W', 'T', 'F', 'S'].map((day) {
            return Expanded(
              child: Center(
                child: Text(
                  day,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        // Calendar grid
        Expanded(
          child: GridView.count(
            crossAxisCount: 7,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.1,
            children: [
              // Empty cells for days before first day of month
              ...List.generate(firstWeekday, (_) => const SizedBox.shrink()),
              // Day cells
              ...List.generate(daysInMonth, (index) {
                final day = index + 1;
                return _buildDayCell(day);
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDayCell(int day) {
    final isToday = today.year == displayMonth.year &&
        today.month == displayMonth.month &&
        today.day == day;
    final isCompleted = completedDates.contains(day);
    final isPast = DateTime(displayMonth.year, displayMonth.month, day)
        .isBefore(DateTime(today.year, today.month, today.day));
    final isFuture = DateTime(displayMonth.year, displayMonth.month, day)
        .isAfter(DateTime(today.year, today.month, today.day));

    Color textColor = AppColors.textPrimary;
    Color? bgColor;
    FontWeight fontWeight = FontWeight.w400;

    if (isToday) {
      bgColor = AppColors.calendarToday;
      textColor = AppColors.textWhite;
      fontWeight = FontWeight.w600;
    } else if (isCompleted) {
      bgColor = AppColors.calendarCompleted.withOpacity(0.15);
      textColor = AppColors.calendarCompleted;
      fontWeight = FontWeight.w600;
    } else if (isFuture) {
      textColor = AppColors.calendarFuture;
    } else if (isPast) {
      textColor = AppColors.calendarMissed;
    }

    return Center(
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
        ),
        child: Stack(
          children: [
            Center(
              child: Text(
                '$day',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: fontWeight,
                  color: textColor,
                ),
              ),
            ),
            // Star indicator for completed days
            if (isCompleted && !isToday)
              Positioned(
                bottom: 2,
                right: 2,
                child: Icon(
                  Icons.star_rounded,
                  color: AppColors.starGold,
                  size: 10,
                ),
              ),
          ],
        ),
      ),
    );
  }
}