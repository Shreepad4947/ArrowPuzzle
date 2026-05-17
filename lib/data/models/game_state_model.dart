import 'arrow_model.dart';
import 'level_model.dart';

/// Current state of an active game
class GameStateModel {
  final LevelModel level;
  final List<ArrowModel> currentArrows;
  final int livesRemaining;
  final int hintsRemaining;
  final int movesMade;
  final int wrongMoves;
  final List<String> removedArrowIds;
  final String? lastWrongArrowId;
  final bool isCompleted;
  final bool isFailed;
  final bool isPaused;
  final bool showingHint;
  final String? hintArrowId;
  final DateTime startTime;

  GameStateModel({
    required this.level,
    required this.currentArrows,
    this.livesRemaining = 3,
    this.hintsRemaining = 2,
    this.movesMade = 0,
    this.wrongMoves = 0,
    this.removedArrowIds = const [],
    this.lastWrongArrowId,
    this.isCompleted = false,
    this.isFailed = false,
    this.isPaused = false,
    this.showingHint = false,
    this.hintArrowId,
    DateTime? startTime,
  }) : startTime = startTime ?? DateTime.now();

  int get remainingArrows =>
      currentArrows.where((a) => a.state == ArrowState.active).length;

  int get totalArrows => level.totalArrows;

  int get flagCount => level.totalMoves;

  GameStateModel copyWith({
    LevelModel? level,
    List<ArrowModel>? currentArrows,
    int? livesRemaining,
    int? hintsRemaining,
    int? movesMade,
    int? wrongMoves,
    List<String>? removedArrowIds,
    String? lastWrongArrowId,
    bool? isCompleted,
    bool? isFailed,
    bool? isPaused,
    bool? showingHint,
    String? hintArrowId,
    DateTime? startTime,
    bool clearLastWrong = false,
    bool clearHint = false,
  }) {
    return GameStateModel(
      level: level ?? this.level,
      currentArrows: currentArrows ?? this.currentArrows,
      livesRemaining: livesRemaining ?? this.livesRemaining,
      hintsRemaining: hintsRemaining ?? this.hintsRemaining,
      movesMade: movesMade ?? this.movesMade,
      wrongMoves: wrongMoves ?? this.wrongMoves,
      removedArrowIds: removedArrowIds ?? this.removedArrowIds,
      lastWrongArrowId:
          clearLastWrong ? null : (lastWrongArrowId ?? this.lastWrongArrowId),
      isCompleted: isCompleted ?? this.isCompleted,
      isFailed: isFailed ?? this.isFailed,
      isPaused: isPaused ?? this.isPaused,
      showingHint: clearHint ? false : (showingHint ?? this.showingHint),
      hintArrowId: clearHint ? null : (hintArrowId ?? this.hintArrowId),
      startTime: startTime ?? this.startTime,
    );
  }
}