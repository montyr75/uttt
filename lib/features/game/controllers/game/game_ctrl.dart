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
    // Make the move on the small board
    ref.read(boardCtrlProvider(boardIndex).notifier).makeMove(cellIndex, state.currentPlayer);

    // Refresh board state after move
    final newBoardState = ref.read(boardCtrlProvider(boardIndex));

    // Update large board state if this small board was just won or drawn
    final newLargeBoardState = Map<int, Player>.from(state.largeBoardState);
    final newDrawnBoards = Set<int>.from(state.drawnBoards);

    if (newBoardState.isWon && !state.largeBoardState.containsKey(boardIndex)) {
      newLargeBoardState[boardIndex] = newBoardState.winner!;
    } else if (newBoardState.isDrawn && !state.drawnBoards.contains(boardIndex)) {
      newDrawnBoards.add(boardIndex);
    }

    // Check for global win
    final winner = _checkGlobalWin(newLargeBoardState);

    // Determine next board index
    int? nextBoardIndex = cellIndex;

    // Check if the target board is already won or full
    final targetBoardState = ref.read(boardCtrlProvider(nextBoardIndex));
    if (targetBoardState.isWon || targetBoardState.isDrawn) {
      nextBoardIndex = null; // Free choice
    }

    // Switch player
    final nextPlayer = state.currentPlayer == Player.x ? Player.o : Player.x;

    state = state.copyWith(
      currentPlayer: nextPlayer,
      nextBoardIndex: nextBoardIndex,
      winner: winner,
      largeBoardState: newLargeBoardState,
      drawnBoards: newDrawnBoards,
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

  ({Player player, List<int> pattern})? _checkGlobalWin(Map<int, Player> largeBoard) {
    for (final pattern in winPatterns) {
      final a = largeBoard[pattern[0]];
      final b = largeBoard[pattern[1]];
      final c = largeBoard[pattern[2]];

      if (a != null && a == b && a == c) {
        return (player: a, pattern: pattern);
      }
    }

    return null;
  }
}
