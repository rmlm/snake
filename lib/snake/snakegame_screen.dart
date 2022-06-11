import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snake/enums/game_state.dart';
import 'package:snake/providers/game_provider.dart';
import 'package:snake/snake/widgets/board.dart';
import 'package:snake/snake/widgets/game_state_info.dart';

class SnakeGameScreen extends StatelessWidget {
  const SnakeGameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GameProvider>(
      context,
    );

    return Scaffold(
      backgroundColor: Colors.grey[700],
      body: Stack(
        children: [
          Board(
            columns: provider.numberOfColumns,
            rows: provider.numberOfRows,
          ),
          if (provider.gameState != GameState.started) const GameStateInfo(),
        ],
      ),
    );
  }
}
