import '../models/user_progress_model.dart';
import '../services/storage_service.dart';

class UserRepository {
  final StorageService storageService;
  late UserProgressModel _progress;

  UserRepository({required this.storageService}) {
    _progress = storageService.loadUserProgress();
  }

  UserProgressModel get progress => _progress;

  int get currentLevel => _progress.currentLevel;
  int get hintsAvailable => _progress.hintsAvailable;
  bool get hasAcceptedTerms => _progress.hasAcceptedTerms;
  bool get hasSeenOnboarding => _progress.hasSeenOnboarding;
  bool get hasSeenDailyWelcome => _progress.hasSeenDailyWelcome;

  Future<void> acceptTerms() async {
    _progress = _progress.copyWith(
      hasAcceptedTerms: true,
      hasSeenOnboarding: true,
    );
    await storageService.saveUserProgress(_progress);
  }

  Future<void> setDailyWelcomeSeen() async {
    _progress = _progress.copyWith(hasSeenDailyWelcome: true);
    await storageService.saveUserProgress(_progress);
  }

  Future<void> completeLevel(int levelNumber) async {
    final newMap = Map<int, bool>.from(_progress.levelCompletionMap);
    newMap[levelNumber] = true;

    int nextLevel = _progress.currentLevel;
    if (levelNumber >= nextLevel) {
      nextLevel = levelNumber + 1;
    }

    _progress = _progress.copyWith(
      currentLevel: nextLevel,
      levelsCompleted: _progress.levelsCompleted + 1,
      levelCompletionMap: newMap,
    );
    await storageService.saveUserProgress(_progress);
  }

  Future<void> completeDailyChallenge(DateTime date) async {
    final key = '${date.year}-${date.month}-${date.day}';
    final newMap = Map<String, bool>.from(
      _progress.dailyChallengeCompletionMap,
    );
    newMap[key] = true;

    _progress = _progress.copyWith(
      dailyChallengeCompletionMap: newMap,
      totalStarsEarned: _progress.totalStarsEarned + 1,
    );
    await storageService.saveUserProgress(_progress);
  }

  Future<void> useHint() async {
    if (_progress.hintsAvailable > 0) {
      _progress = _progress.copyWith(
        hintsAvailable: _progress.hintsAvailable - 1,
      );
      await storageService.saveUserProgress(_progress);
    }
  }

  Future<void> addHints(int count) async {
    _progress = _progress.copyWith(
      hintsAvailable: _progress.hintsAvailable + count,
    );
    await storageService.saveUserProgress(_progress);
  }

  Future<void> updateSettings({bool? sound, bool? vibration}) async {
    _progress = _progress.copyWith(
      soundEnabled: sound,
      vibrationEnabled: vibration,
    );
    await storageService.saveUserProgress(_progress);
  }

  int getDailyStarsForMonth(int year, int month) {
    return _progress.getDailyStarsForMonth(year, month);
  }

  bool isDailyChallengeCompleted(DateTime date) {
    return _progress.isDailyChallengeCompleted(date);
  }
}