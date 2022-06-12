import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snake/providers/game_provider.dart';
import 'package:snake/snake/snakegame_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Snake Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => GameProvider(),
          ),
        ],
        child: const SnakeGameScreen(),
      ),
    );
  }
}
