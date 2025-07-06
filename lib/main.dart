import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flutter/services.dart';
import 'espig_game.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flappy Espiga',
      theme: ThemeData(primarySwatch: Colors.green),
      home: GameScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late FlappyCornGame game;

  @override
  void initState() {
    super.initState();
    game = FlappyCornGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget<FlappyCornGame>(
        game: game,
      ),
    );
  }
}