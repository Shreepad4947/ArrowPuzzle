import 'arrow_model.dart';

enum LevelDifficulty { easy, normal, hard, expert }

enum LevelType { tutorial, regular, daily }

class LevelModel {
  final int levelNumber;
  final LevelType type;
  final LevelDifficulty difficulty;
  final int gridRows;
  final int gridCols;
  final List<ArrowModel> arrows;
  final List<String> solutionOrder;
  final bool showTutorial;
  final String? tutorialMessage;

  const LevelModel({
    required this.levelNumber,
    required this.type,
    required this.difficulty,
    required this.gridRows,
    required this.gridCols,
    required this.arrows,
    required this.solutionOrder,
    this.showTutorial = false,
    this.tutorialMessage,
  });

  int get totalArrows => arrows.length;
  int get totalMoves => solutionOrder.length;

  String get difficultyLabel {
    switch (difficulty) {
      case LevelDifficulty.easy:
        return 'Easy';
      case LevelDifficulty.normal:
        return 'Normal';
      case LevelDifficulty.hard:
        return 'Hard';
      case LevelDifficulty.expert:
        return 'Expert';
    }
  }

  LevelModel freshCopy() {
    return LevelModel(
      levelNumber: levelNumber,
      type: type,
      difficulty: difficulty,
      gridRows: gridRows,
      gridCols: gridCols,
      arrows: arrows
          .map((ArrowModel a) => a.copyWith(state: ArrowState.active))
          .toList(),
      solutionOrder: List<String>.from(solutionOrder),
      showTutorial: showTutorial,
      tutorialMessage: tutorialMessage,
    );
  }
}