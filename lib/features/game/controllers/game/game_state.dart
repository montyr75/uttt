import '../../../../data/game_data.dart';

typedef Winner = ({Player player, List<int> pattern});

class GameState {
  final Player currentPlayer;
  final int? nextBoardIndex;
  final Winner? winner;
  final Map<int, Player> largeBoardState;
  final Set<int> drawnBoards;

  const GameState({
    this.currentPlayer = Player.x,
    this.nextBoardIndex,
    this.winner,
    this.largeBoardState = const {},
    this.drawnBoards = const {},
  });

  GameState copyWith({
    Player? currentPlayer,
    int? nextBoardIndex,
    Winner? winner,
    Map<int, Player>? largeBoardState,
    Set<int>? drawnBoards,
  }) {
    return GameState(
      currentPlayer: currentPlayer ?? this.currentPlayer,
      nextBoardIndex: nextBoardIndex, // Allow setting to null
      winner: winner ?? this.winner,
      largeBoardState: largeBoardState ?? this.largeBoardState,
      drawnBoards: drawnBoards ?? this.drawnBoards,
    );
  }

  bool isTarget(int boardIndex) => nextBoardIndex == null || nextBoardIndex == boardIndex;
  bool isInWinPattern(int boardIndex) => winner?.pattern.contains(boardIndex) ?? false;
  
  bool get isWon => winner != null;
  bool get isDrawn => !isWon && (largeBoardState.length + drawnBoards.length == 9);
  bool get isGameOver => isWon || isDrawn;
}
