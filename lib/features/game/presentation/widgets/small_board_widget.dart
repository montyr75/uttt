import 'package:awesome_flutter_extensions/awesome_flutter_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../utils/screen_utils.dart';
import '../../controllers/board/board_ctrl.dart';
import '../../controllers/game/game_ctrl.dart';

class SmallBoardWidget extends ConsumerWidget {
  final int boardIndex;

  const SmallBoardWidget({super.key, required this.boardIndex});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boardState = ref.watch(boardCtrlProvider(boardIndex));
    final gameState = ref.watch(gameCtrlProvider);

    // Check if this board is the valid target for the current move
    final canPlay = gameState.isTarget(boardIndex) && !gameState.isGameOver && boardState.isAvailable;

    final styles = context.textStyles;
    final colorScheme = Theme.of(context).colorScheme;

    // If the board is won, show the large symbol
    if (boardState.isWon) {
      final winnerColor = boardState.winner!.getColor(context);
      final isWinningBoard = gameState.isInWinPattern(boardIndex);

      return Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: isWinningBoard ? winnerColor : colorScheme.primary,
            width: isWinningBoard ? 3 : 1,
          ),
          color: isWinningBoard ? null : Colors.black,
          gradient: isWinningBoard
              ? RadialGradient(
                  colors: [Colors.black, winnerColor.withValues(alpha: 0.5)],
                  radius: 1.2,
                  stops: const [0.3, 1.0],
                )
              : null,
        ),
        child: Padding(
          padding: paddingAllM,
          child: FittedBox(
            fit: BoxFit.contain,
            child: Text(
              boardState.winner!.toString(),
              style: styles.displayLarge.copyWith(
                color: winnerColor,
                shadows: [
                  BoxShadow(
                    color: winnerColor,
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 300.ms),
          ),
        ),
      );
    }

    final playerColor = gameState.currentPlayer.getColor(context);

    return AnimatedContainer(
      duration: 300.ms,
      decoration: BoxDecoration(
        border: Border.all(
          color: canPlay ? playerColor : colorScheme.primary.withValues(alpha: 0.3),
          width: canPlay ? 2 : 1,
        ),
        color: canPlay ? colorScheme.primary.withValues(alpha: 0.05) : Colors.transparent,
        boxShadow: [
          BoxShadow(
            color: canPlay ? colorScheme.primary.withValues(alpha: 0.5) : Colors.transparent,
            blurRadius: canPlay ? 10 : 0,
            spreadRadius: canPlay ? 1 : 0,
          ),
        ],
      ),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemCount: 9,
        itemBuilder: (context, index) {
          final cell = boardState.cells[index];
          final cellColor = cell?.getColor(context);
          final isCellEmpty = cell == null;

          return InkWell(
            onTap: canPlay && isCellEmpty
                ? () {
                    ref.read(gameCtrlProvider.notifier).makeMove(boardIndex, index);
                  }
                : null,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: colorScheme.primary.withValues(alpha: 0.3),
                  width: 0.5,
                ),
              ),
              child: isCellEmpty
                  ? null
                  : Padding(
                      padding: paddingAllS,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          cell.toString(),
                          style: styles.bodyLarge.copyWith(
                            fontWeight: FontWeight.bold,
                            color: cellColor,
                            shadows: [
                              BoxShadow(
                                color: cellColor ?? Colors.transparent,
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ).animate().fadeIn(duration: 200.ms),
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}
