import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../espig_game.dart';

class Background extends Component with HasGameReference<FlappyCornGame> {
  @override
  void render(Canvas canvas) {
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        const Color(0xFF87CEEB), // Azul céu
        const Color(0xFF98FB98), // Verde claro
      ],
    );
    
    final paint = Paint()
      ..shader = gradient.createShader(
        Rect.fromLTWH(0, 0, game.size.x, game.size.y),
      );
    
    canvas.drawRect(
      Rect.fromLTWH(0, 0, game.size.x, game.size.y),
      paint,
    );
    
    // Adicionar algumas nuvens simples
    drawClouds(canvas);
  }
  
  void drawClouds(Canvas canvas) {
    final cloudPaint = Paint()
      ..color = const Color.fromARGB(160, 255, 255, 255);
    
    // Nuvem 1
    canvas.drawCircle(const Offset(150, 80), 25, cloudPaint);
    canvas.drawCircle(const Offset(170, 85), 30, cloudPaint);
    canvas.drawCircle(const Offset(190, 80), 25, cloudPaint);
    
    // Nuvem 2
    canvas.drawCircle(const Offset(350, 120), 20, cloudPaint);
    canvas.drawCircle(const Offset(365, 125), 25, cloudPaint);
    canvas.drawCircle(const Offset(380, 120), 20, cloudPaint);
  }
}
