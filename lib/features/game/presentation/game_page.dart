
import 'package:awesome_flutter_extensions/awesome_flutter_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utils/screen_utils.dart';
import '../controllers/game/game_ctrl.dart';
import '../controllers/game/game_state.dart';
import 'widgets/small_board_widget.dart';

class GamePage extends ConsumerWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameCtrlProvider);

    final styles = context.textStyles;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ultimate Tic-Tac-Toe',
          style: styles.titleLarge,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Restart Game',
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(gameCtrlProvider.notifier).restartGame();
            },
          ),
        ],
      ),
      body: Padding(
        padding: paddingAllM,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: paddingAllXL,
              child: _buildStatusText(context, gameState),
            ),
            Expanded(
              child: Padding(
                padding: paddingAllM,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 4,
                      ),
                      itemCount: 9,
                      itemBuilder: (context, index) {
                        return SmallBoardWidget(boardIndex: index);
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusText(BuildContext context, GameState state) {
    final styles = context.textStyles;

    if (state.isDrawn) {
      return FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          'Game Drawn!',
          style: styles.headlineLarge.copyWith(
            color: Colors.white,
            shadows: [
              const BoxShadow(
                color: Colors.white,
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
        ),
      );
    }
    
    if (state.isWon) {
      return FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          'Player ${state.winner!.player.toString()} Wins!',
          style: styles.headlineLarge.copyWith(
            color: state.winner!.player.getColor(context),
            shadows: [
              BoxShadow(
                color: state.winner!.player.getColor(context),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
        ),
      );
    }

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(
        'Player: ${state.currentPlayer.toString()}',
        style: styles.headlineLarge.copyWith(
          color: state.currentPlayer.getColor(context),
          shadows: [
            BoxShadow(
              color: state.currentPlayer.getColor(context),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
      ),
    );
  }
}