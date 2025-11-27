import '../../../../data/game_data.dart';

class GameState {
  final Player currentPlayer;
  final int? nextBoardIndex;
  final Player? winner;
  final Map<int, Player> largeBoardState;

  const GameState({
    this.currentPlayer = Player.x,
    this.nextBoardIndex,
    this.winner,
    this.largeBoardState = const {},
  });

  GameState copyWith({
    Player? currentPlayer,
    int? nextBoardIndex,
    Player? winner,
    Map<int, Player>? largeBoardState,
  }) {
    return GameState(
      currentPlayer: currentPlayer ?? this.currentPlayer,
      nextBoardIndex: nextBoardIndex, // Allow setting to null
      winner: winner ?? this.winner,
      largeBoardState: largeBoardState ?? this.largeBoardState,
    );
  }

  bool isTarget(int boardIndex) => nextBoardIndex == null || nextBoardIndex == boardIndex;

  bool get isGameWon => winner != null;
  bool get isGameDrawn => !isGameWon && largeBoardState.values.length == 9;
}
