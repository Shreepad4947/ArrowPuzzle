import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_progress_model.dart';

class StorageService {
  late SharedPreferences _prefs;

  static const String _keyUserProgress = 'user_progress';
  static const String _keyCurrentLevel = 'current_level';
  static const String _keyHints = 'hints_available';
  static const String _keyTermsAccepted = 'terms_accepted';
  static const String _keyOnboardingSeen = 'onboarding_seen';
  static const String _keyDailyWelcomeSeen = 'daily_welcome_seen';
  static const String _keySoundEnabled = 'sound_enabled';
  static const String _keyVibrationEnabled = 'vibration_enabled';
  static const String _keyLevelCompletion = 'level_completion';
  static const String _keyDailyCompletion = 'daily_completion';
  static const String _keyTotalStars = 'total_stars';
  static const String _keyLevelsCompleted = 'levels_completed';

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Save user progress
  Future<void> saveUserProgress(UserProgressModel progress) async {
    await _prefs.setInt(_keyCurrentLevel, progress.currentLevel);
    await _prefs.setInt(_keyTotalStars, progress.totalStarsEarned);
    await _prefs.setInt(_keyHints, progress.hintsAvailable);
    await _prefs.setInt(_keyLevelsCompleted, progress.levelsCompleted);
    await _prefs.setBool(_keyTermsAccepted, progress.hasAcceptedTerms);
    await _prefs.setBool(_keyOnboardingSeen, progress.hasSeenOnboarding);
    await _prefs.setBool(_keyDailyWelcomeSeen, progress.hasSeenDailyWelcome);
    await _prefs.setBool(_keySoundEnabled, progress.soundEnabled);
    await _prefs.setBool(_keyVibrationEnabled, progress.vibrationEnabled);

    // Save level completion map
    final levelMap = progress.levelCompletionMap.map(
      (key, value) => MapEntry(key.toString(), value),
    );
    await _prefs.setString(_keyLevelCompletion, jsonEncode(levelMap));

    // Save daily challenge completion
    await _prefs.setString(
      _keyDailyCompletion,
      jsonEncode(progress.dailyChallengeCompletionMap),
    );
  }

  // Load user progress
  UserProgressModel loadUserProgress() {
    // Load level completion map
    Map<int, bool> levelMap = {};
    final levelStr = _prefs.getString(_keyLevelCompletion);
    if (levelStr != null) {
      final decoded = jsonDecode(levelStr) as Map<String, dynamic>;
      levelMap = decoded.map(
        (key, value) => MapEntry(int.parse(key), value as bool),
      );
    }

    // Load daily challenge completion
    Map<String, bool> dailyMap = {};
    final dailyStr = _prefs.getString(_keyDailyCompletion);
    if (dailyStr != null) {
      final decoded = jsonDecode(dailyStr) as Map<String, dynamic>;
      dailyMap = decoded.map(
        (key, value) => MapEntry(key, value as bool),
      );
    }

    return UserProgressModel(
      currentLevel: _prefs.getInt(_keyCurrentLevel) ?? 1,
      totalStarsEarned: _prefs.getInt(_keyTotalStars) ?? 0,
      hintsAvailable: _prefs.getInt(_keyHints) ?? 2,
      levelsCompleted: _prefs.getInt(_keyLevelsCompleted) ?? 0,
      hasAcceptedTerms: _prefs.getBool(_keyTermsAccepted) ?? false,
      hasSeenOnboarding: _prefs.getBool(_keyOnboardingSeen) ?? false,
      hasSeenDailyWelcome: _prefs.getBool(_keyDailyWelcomeSeen) ?? false,
      soundEnabled: _prefs.getBool(_keySoundEnabled) ?? true,
      vibrationEnabled: _prefs.getBool(_keyVibrationEnabled) ?? true,
      levelCompletionMap: levelMap,
      dailyChallengeCompletionMap: dailyMap,
    );
  }

  // Quick access methods
  Future<void> setCurrentLevel(int level) async {
    await _prefs.setInt(_keyCurrentLevel, level);
  }

  int getCurrentLevel() {
    return _prefs.getInt(_keyCurrentLevel) ?? 1;
  }

  Future<void> setTermsAccepted(bool accepted) async {
    await _prefs.setBool(_keyTermsAccepted, accepted);
  }

  bool getTermsAccepted() {
    return _prefs.getBool(_keyTermsAccepted) ?? false;
  }

  Future<void> setOnboardingSeen(bool seen) async {
    await _prefs.setBool(_keyOnboardingSeen, seen);
  }

  bool getOnboardingSeen() {
    return _prefs.getBool(_keyOnboardingSeen) ?? false;
  }

  Future<void> setDailyWelcomeSeen(bool seen) async {
    await _prefs.setBool(_keyDailyWelcomeSeen, seen);
  }

  bool getDailyWelcomeSeen() {
    return _prefs.getBool(_keyDailyWelcomeSeen) ?? false;
  }
}