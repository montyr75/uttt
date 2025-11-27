import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../data/game_data.dart';
import 'board_state.dart';

part 'board_ctrl.g.dart';

@riverpod
class BoardCtrl extends _$BoardCtrl {
  @override
  BoardState build(int boardIndex) {
    return BoardState(
      cells: List.filled(9, null),
      winner: null,
    );
  }

  void makeMove(int cellIndex, Player player) {
    if (state.cells[cellIndex] != null || state.winner != null) {
      return;
    }

    final newCells = List<Player?>.from(state.cells);
    newCells[cellIndex] = player;

    final winner = _checkWin(newCells);

    state = state.copyWith(
      cells: newCells,
      winner: winner,
    );
  }

  Player? _checkWin(List<Player?> cells) {
    for (final pattern in winPatterns) {
      final a = cells[pattern[0]];
      final b = cells[pattern[1]];
      final c = cells[pattern[2]];

      if (a != null && a == b && a == c) {
        return a;
      }
    }
    
    return null;
  }
}
