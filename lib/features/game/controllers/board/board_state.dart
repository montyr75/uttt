import '../../../../data/game_data.dart';

class BoardState {
  final List<Player?> cells;
  final Player? winner;

  BoardState({required this.cells, this.winner});

  BoardState copyWith({List<Player?>? cells, Player? winner}) {
    return BoardState(
      cells: cells ?? this.cells,
      winner: winner ?? this.winner,
    );
  }
  
  bool get isFull => cells.every((cell) => cell != null);
  bool get isWon => winner != null;
  bool get isDrawn => !isWon && isFull;
  bool get isAvailable => !isWon && !isFull;
  
  bool isCellAvailable(int index) => !isWon && !isFull && cells[index] == null;
}
