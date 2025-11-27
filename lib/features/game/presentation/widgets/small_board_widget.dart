import 'package:awesome_flutter_extensions/awesome_flutter_extensions.dart';
import 'package:flutter/material.dart';
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
    final canPlay = gameState.isTarget(boardIndex) && !gameState.isGameWon && !boardState.isBoardWon;

    final styles = context.textStyles;
    final colorScheme = Theme.of(context).colorScheme;

    // If the board is won, show the large symbol
    if (boardState.isBoardWon) {
      final winnerColor = boardState.winner!.getColor(context);

      return Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: colorScheme.primary,
            width: 1,
          ),
          color: Colors.black,
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
            ),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: canPlay ? colorScheme.primary : colorScheme.primary.withValues(alpha: 0.3),
          width: canPlay ? 2 : 1,
        ),
        color: canPlay ? colorScheme.primary.withValues(alpha: 0.05) : null,
        boxShadow: canPlay
            ? [
                BoxShadow(
                  color: colorScheme.primary.withValues(alpha: 0.5),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ]
            : null,
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

          return GestureDetector(
            onTap: () {
              if (canPlay && cell == null) {
                ref.read(gameCtrlProvider.notifier).makeMove(boardIndex, index);
              }
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: colorScheme.primary.withValues(alpha: 0.3),
                  width: 0.5,
                ),
              ),
              child: cell == null
                  ? null
                  : Padding(
                      padding: const EdgeInsets.all(4.0),
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
                        ),
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}
