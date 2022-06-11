import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:snake/providers/game_provider.dart';

import '../../enums/game_state.dart';

class GameStateInfo extends StatelessWidget {
  const GameStateInfo({Key? key}) : super(key: key);

  String getText(GameState state) {
    if (state == GameState.toStart) return "Snake Game";
    if (state == GameState.paused) return "Paused";
    if (state == GameState.gameover) return "Game over!";

    return "";
  }

  Color getTitleColor(GameState state) {
    if (state == GameState.toStart) return Colors.green;
    if (state == GameState.paused) return Colors.yellow;
    if (state == GameState.gameover) return Colors.red;

    return Colors.white;
  }

  String getSubText(GameState state) {
    if (state == GameState.toStart) return "Click here to start";
    if (state == GameState.gameover) return "Click here to start again";

    return "";
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<GameProvider>(context, listen: false);

    return Center(
      child: GestureDetector(
        onTap: () => provider.startGame(),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(
              10,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                getText(provider.gameState),
                style: GoogleFonts.bebasNeue(
                  fontSize: 50,
                  textStyle: TextStyle(
                    color: getTitleColor(provider.gameState),
                    letterSpacing: 1,
                  ),
                ),
              ),
              Text(
                getSubText(provider.gameState).toUpperCase(),
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  textStyle: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              if (provider.gameState == GameState.gameover)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    "Score: ${provider.score}",
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      textStyle: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
