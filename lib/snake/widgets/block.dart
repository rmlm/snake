import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snake/providers/game_provider.dart';

class Block extends StatelessWidget {
  final int blockPosition;
  final double size;

  const Block({
    Key? key,
    required this.blockPosition,
    required this.size,
  }) : super(key: key);

  Color getBlockColor(List<int> snake, List<int> apples) {
    if (snake.contains(blockPosition)) return Colors.white;
    if (apples.contains(blockPosition)) return Colors.green;

    return Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GameProvider>(context);

    return GestureDetector(
      onTap: () => provider.changeDirection(blockPosition),
      child: Container(
        decoration: BoxDecoration(
          color: getBlockColor(provider.snake, provider.apples),
        ),
        width: size,
        height: size,
      ),
    );
  }
}
