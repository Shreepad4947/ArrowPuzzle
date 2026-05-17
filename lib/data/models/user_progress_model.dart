class UserProgressModel {
  final int currentLevel;
  final int totalStarsEarned;
  final int hintsAvailable;
  final int levelsCompleted;
  final bool hasAcceptedTerms;
  final bool hasSeenOnboarding;
  final bool hasSeenDailyWelcome;
  final bool soundEnabled;
  final bool vibrationEnabled;
  final Map<int, bool> levelCompletionMap;
  final Map<String, bool> dailyChallengeCompletionMap;

  const UserProgressModel({
    this.currentLevel = 1,
    this.totalStarsEarned = 0,
    this.hintsAvailable = 2,
    this.levelsCompleted = 0,
    this.hasAcceptedTerms = false,
    this.hasSeenOnboarding = false,
    this.hasSeenDailyWelcome = false,
    this.soundEnabled = true,
    this.vibrationEnabled = true,
    this.levelCompletionMap = const {},
    this.dailyChallengeCompletionMap = const {},
  });

  UserProgressModel copyWith({
    int? currentLevel,
    int? totalStarsEarned,
    int? hintsAvailable,
    int? levelsCompleted,
    bool? hasAcceptedTerms,
    bool? hasSeenOnboarding,
    bool? hasSeenDailyWelcome,
    bool? soundEnabled,
    bool? vibrationEnabled,
    Map<int, bool>? levelCompletionMap,
    Map<String, bool>? dailyChallengeCompletionMap,
  }) {
    return UserProgressModel(
      currentLevel: currentLevel ?? this.currentLevel,
      totalStarsEarned: totalStarsEarned ?? this.totalStarsEarned,
      hintsAvailable: hintsAvailable ?? this.hintsAvailable,
      levelsCompleted: levelsCompleted ?? this.levelsCompleted,
      hasAcceptedTerms: hasAcceptedTerms ?? this.hasAcceptedTerms,
      hasSeenOnboarding: hasSeenOnboarding ?? this.hasSeenOnboarding,
      hasSeenDailyWelcome: hasSeenDailyWelcome ?? this.hasSeenDailyWelcome,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      levelCompletionMap: levelCompletionMap ?? this.levelCompletionMap,
      dailyChallengeCompletionMap:
          dailyChallengeCompletionMap ?? this.dailyChallengeCompletionMap,
    );
  }

  bool isLevelCompleted(int levelNumber) {
    return levelCompletionMap[levelNumber] ?? false;
  }

  bool isDailyChallengeCompleted(DateTime date) {
    final key = '${date.year}-${date.month}-${date.day}';
    return dailyChallengeCompletionMap[key] ?? false;
  }

  int getDailyStarsForMonth(int year, int month) {
    int count = 0;
    dailyChallengeCompletionMap.forEach((key, completed) {
      if (completed) {
        final parts = key.split('-');
        if (parts.length == 3) {
          final y = int.tryParse(parts[0]);
          final m = int.tryParse(parts[1]);
          if (y == year && m == month) {
            count++;
          }
        }
      }
    });
    return count;
  }
}