import 'package:flutter/material.dart';
import '../espig_game.dart';

class MainMenuScreen extends StatelessWidget {
  final FlappyCornGame game;
  
  const MainMenuScreen({Key? key, required this.game}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.8),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '🌽 FLAPPY CORN',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFD700),
                shadows: [
                  Shadow(
                    blurRadius: 6,
                    color: Colors.black,
                    offset: Offset(3, 3),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Espigão d\'Oeste Adventure',
              style: TextStyle(
                fontSize: 24,
                color: Color(0xFF90EE90),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 60),
            ElevatedButton(
              onPressed: () => game.startGame(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF228B22),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text(
                'COMEÇAR JOGO',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'Toque na tela para voar!\nEvite os prédios da cidade!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}