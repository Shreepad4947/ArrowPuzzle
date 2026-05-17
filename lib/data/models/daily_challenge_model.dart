class DailyChallengeModel {
  final DateTime date;
  final bool isCompleted;
  final int? starsEarned;
  final Duration? completionTime;
  final int? movesUsed;

  const DailyChallengeModel({
    required this.date,
    this.isCompleted = false,
    this.starsEarned,
    this.completionTime,
    this.movesUsed,
  });

  DailyChallengeModel copyWith({DateTime? date, bool? isCompleted, int? starsEarned, Duration? completionTime, int? movesUsed}) {
    return DailyChallengeModel(
      date: date ?? this.date, isCompleted: isCompleted ?? this.isCompleted,
      starsEarned: starsEarned ?? this.starsEarned,
      completionTime: completionTime ?? this.completionTime,
      movesUsed: movesUsed ?? this.movesUsed,
    );
  }
}
