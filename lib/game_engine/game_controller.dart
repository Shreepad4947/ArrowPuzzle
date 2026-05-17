import 'package:flutter/material.dart';
import '../data/models/arrow_model.dart';
import '../data/models/game_state_model.dart';
import '../data/models/level_model.dart';
import '../data/repositories/game_repository.dart';
import '../data/repositories/user_repository.dart';
import '../core/utils/haptic_manager.dart';

class GameController extends ChangeNotifier {
  final GameRepository gameRepository;
  final UserRepository userRepository;

  GameStateModel? _gameState;
  bool _isAnimating = false;

  GameController({
    required this.gameRepository,
    required this.userRepository,
  });

  GameStateModel? get gameState => _gameState;
  bool get isAnimating => _isAnimating;
  bool get hasActiveGame => _gameState != null;

  int get currentUserLevel {
    return gameRepository.getCurrentLevel();
  }

  int get hintsAvailable => userRepository.hintsAvailable;

  void startLevel(int levelNumber) {
    _gameState = gameRepository.createGameSession(levelNumber);
    _isAnimating = false;

    debugPrint('Started level: ${_gameState!.level.levelNumber}');
    debugPrint('Solution: ${_gameState!.level.solutionOrder}');

    notifyListeners();
  }

  void startDailyChallenge(DateTime date) {
    _gameState = gameRepository.createDailyChallengeSession(date);
    _isAnimating = false;
    notifyListeners();
  }

  void restartLevel() {
    if (_gameState == null) return;

    final levelNumber = _gameState!.level.levelNumber;

    if (_gameState!.level.type == LevelType.daily) {
      startDailyChallenge(DateTime.now());
    } else {
      startLevel(levelNumber);
    }
  }

  Future<void> onArrowTapped(String arrowId) async {
    if (_gameState == null) return;
    if (_isAnimating) return;
    if (_gameState!.isCompleted || _gameState!.isFailed) return;

    final state = _gameState!;
    final arrowIndex = state.currentArrows.indexWhere((a) => a.id == arrowId);

    if (arrowIndex == -1) return;

    final arrow = state.currentArrows[arrowIndex];

    if (arrow.state != ArrowState.active &&
        arrow.state != ArrowState.highlighted) {
      return;
    }

    final expectedArrowId = _getNextExpectedArrowId(state);

    final isCorrect = arrow.id == expectedArrowId;

    debugPrint('Tapped: ${arrow.id}');
    debugPrint('Expected: $expectedArrowId');
    debugPrint('Correct: $isCorrect');

    if (isCorrect) {
      await _handleCorrectTap(arrowIndex);
    } else {
      await _handleWrongTap(arrowIndex);
    }
  }

  String? _getNextExpectedArrowId(GameStateModel state) {
    for (final arrowId in state.level.solutionOrder) {
      final alreadyRemoved = state.removedArrowIds.contains(arrowId);

      if (alreadyRemoved) {
        continue;
      }

      final existsAndActive = state.currentArrows.any(
        (arrow) =>
            arrow.id == arrowId &&
            (arrow.state == ArrowState.active ||
                arrow.state == ArrowState.highlighted),
      );

      if (existsAndActive) {
        return arrowId;
      }
    }

    return null;
  }

  Future<void> _handleCorrectTap(int arrowIndex) async {
    _isAnimating = true;

    final state = _gameState!;
    final updatedArrows = List<ArrowModel>.from(state.currentArrows);

    final tappedArrow = updatedArrows[arrowIndex];

    updatedArrows[arrowIndex] = tappedArrow.copyWith(
      state: ArrowState.removing,
    );

    _gameState = state.copyWith(
      currentArrows: updatedArrows,
      clearLastWrong: true,
      clearHint: true,
    );

    HapticManager.lightImpact();
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 430));

    if (_gameState == null) return;

    final postAnimationArrows = List<ArrowModel>.from(_gameState!.currentArrows);

    final currentIndex = postAnimationArrows.indexWhere(
      (arrow) => arrow.id == tappedArrow.id,
    );

    if (currentIndex != -1) {
      postAnimationArrows[currentIndex] =
          postAnimationArrows[currentIndex].copyWith(
        state: ArrowState.removed,
      );
    }

    final newRemovedIds = List<String>.from(_gameState!.removedArrowIds)
      ..add(tappedArrow.id);

    final isComplete = postAnimationArrows.every(
      (arrow) => arrow.state == ArrowState.removed,
    );

    _gameState = _gameState!.copyWith(
      currentArrows: postAnimationArrows,
      movesMade: _gameState!.movesMade + 1,
      removedArrowIds: newRemovedIds,
      isCompleted: isComplete,
    );

    _isAnimating = false;

    if (isComplete) {
      HapticManager.successVibration();

      if (state.level.type == LevelType.daily) {
        await userRepository.completeDailyChallenge(DateTime.now());
      } else {
        await userRepository.completeLevel(state.level.levelNumber);
      }
    }

    notifyListeners();
  }

  Future<void> _handleWrongTap(int arrowIndex) async {
    _isAnimating = true;

    final state = _gameState!;
    final updatedArrows = List<ArrowModel>.from(state.currentArrows);
    final wrongArrow = updatedArrows[arrowIndex];

    updatedArrows[arrowIndex] = wrongArrow.copyWith(
      state: ArrowState.wrong,
    );

    final newLives = state.livesRemaining - 1;
    final isFailed = newLives <= 0;

    _gameState = state.copyWith(
      currentArrows: updatedArrows,
      livesRemaining: newLives,
      wrongMoves: state.wrongMoves + 1,
      lastWrongArrowId: wrongArrow.id,
      isFailed: isFailed,
      clearHint: true,
    );

    HapticManager.errorVibration();
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 700));

    if (_gameState == null) return;

    if (!isFailed) {
      final resetArrows = List<ArrowModel>.from(_gameState!.currentArrows);
      final resetIndex = resetArrows.indexWhere((a) => a.id == wrongArrow.id);

      if (resetIndex != -1 && resetArrows[resetIndex].state == ArrowState.wrong) {
        resetArrows[resetIndex] = resetArrows[resetIndex].copyWith(
          state: ArrowState.active,
        );

        _gameState = _gameState!.copyWith(
          currentArrows: resetArrows,
        );
      }
    }

    _isAnimating = false;
    notifyListeners();
  }

  Future<void> useHint() async {
    if (_gameState == null) return;
    if (_gameState!.isCompleted || _gameState!.isFailed) return;
    if (userRepository.hintsAvailable <= 0) return;

    final nextArrowId = _getNextExpectedArrowId(_gameState!);

    if (nextArrowId == null) return;

    await userRepository.useHint();

    final updatedArrows = List<ArrowModel>.from(_gameState!.currentArrows);
    final hintIndex = updatedArrows.indexWhere((a) => a.id == nextArrowId);

    if (hintIndex != -1) {
      updatedArrows[hintIndex] = updatedArrows[hintIndex].copyWith(
        state: ArrowState.highlighted,
      );
    }

    _gameState = _gameState!.copyWith(
      currentArrows: updatedArrows,
      hintsRemaining: userRepository.hintsAvailable,
      showingHint: true,
      hintArrowId: nextArrowId,
    );

    notifyListeners();

    await Future.delayed(const Duration(seconds: 3));

    if (_gameState == null) return;

    final resetArrows = List<ArrowModel>.from(_gameState!.currentArrows);
    final resetIndex = resetArrows.indexWhere((a) => a.id == nextArrowId);

    if (resetIndex != -1 &&
        resetArrows[resetIndex].state == ArrowState.highlighted) {
      resetArrows[resetIndex] = resetArrows[resetIndex].copyWith(
        state: ArrowState.active,
      );

      _gameState = _gameState!.copyWith(
        currentArrows: resetArrows,
        clearHint: true,
      );

      notifyListeners();
    }
  }

  void addExtraLife() {
    if (_gameState == null) return;

    _gameState = _gameState!.copyWith(
      livesRemaining: _gameState!.livesRemaining + 1,
      isFailed: false,
    );

    notifyListeners();
  }

  void clearGame() {
    _gameState = null;
    notifyListeners();
  }

  bool hasNextLevel() {
    if (_gameState == null) return false;
    return gameRepository.hasNextLevel(_gameState!.level.levelNumber);
  }

  int? getNextLevelNumber() {
    if (_gameState == null) return null;

    final next = _gameState!.level.levelNumber + 1;

    if (gameRepository.hasNextLevel(_gameState!.level.levelNumber)) {
      return next;
    }

    return null;
  }
}