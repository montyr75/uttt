import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../data/game_data.dart';
import '../board/board_ctrl.dart';
import 'game_state.dart';

part 'game_ctrl.g.dart';

@riverpod
class GameCtrl extends _$GameCtrl {
  @override
  GameState build() {
    return const GameState();
  }

  void makeMove(int boardIndex, int cellIndex) {
    // 1. Validate turn
    if (state.winner != null) {
      return;
    }

    // Check if the move is in the correct board
    if (state.nextBoardIndex != null && state.nextBoardIndex != boardIndex) {
      // However, we must handle the case where we were sent to a won/full board.
      // But the logic below handles setting nextBoardIndex to null if that happens.
      // So if nextBoardIndex is NOT null, we MUST play there.
      return;
    }

    final boardCtrl = ref.read(boardCtrlProvider(boardIndex).notifier);
    final boardState = ref.read(boardCtrlProvider(boardIndex));

    // Check if cell is empty
    if (boardState.cells[cellIndex] != null) {
      return;
    }

    // Check if board is already won
    if (boardState.winner != null) {
      return;
    }

    // 2. Make the move on the small board
    boardCtrl.makeMove(cellIndex, state.currentPlayer);

    // Refresh board state after move
    final newBoardState = ref.read(boardCtrlProvider(boardIndex));

    // 3. Update large board state if this small board was just won
    final newLargeBoardState = Map<int, Player>.from(state.largeBoardState);
    if (newBoardState.isBoardWon && !state.largeBoardState.containsKey(boardIndex)) {
      newLargeBoardState[boardIndex] = newBoardState.winner!;
    }

    // 4. Check for global win
    final winner = _checkGlobalWin(newLargeBoardState);

    // 5. Determine next board index
    int? nextBoardIndex = cellIndex;

    // Check if the target board is already won or full
    final targetBoardState = ref.read(boardCtrlProvider(nextBoardIndex));
    if (targetBoardState.winner != null || targetBoardState.isFull) {
      nextBoardIndex = null; // Free choice
    }

    // 6. Switch player
    final nextPlayer = state.currentPlayer == Player.x ? Player.o : Player.x;

    state = state.copyWith(
      currentPlayer: nextPlayer,
      nextBoardIndex: nextBoardIndex,
      winner: winner,
      largeBoardState: newLargeBoardState,
    );
  }

  void restartGame() {
    // Invalidate all board controllers to reset them
    for (int i = 0; i < 9; i++) {
      ref.invalidate(boardCtrlProvider(i));
    }

    // Reset game state
    state = const GameState();
  }

  Player? _checkGlobalWin(Map<int, Player> largeBoard) {
    for (final pattern in winPatterns) {
      final a = largeBoard[pattern[0]];
      final b = largeBoard[pattern[1]];
      final c = largeBoard[pattern[2]];

      if (a != null && a == b && a == c) {
        return a;
      }
    }

    return null;
  }
}
