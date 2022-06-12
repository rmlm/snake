import 'package:flutter/material.dart';
import 'package:snake/snake/widgets/block.dart';

class Board extends StatelessWidget {
  final int columns;
  final int rows;

  const Board({
    Key? key,
    required this.columns,
    required this.rows,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final sizeOfBlock = screenWidth / columns;

    return GridView.count(
      crossAxisCount: columns,
      crossAxisSpacing: 0,
      mainAxisSpacing: 0,
      children: List.generate(
        columns * rows,
        (index) => Block(
          blockPosition: index,
          size: sizeOfBlock,
        ),
      ),
    );
  }
}
