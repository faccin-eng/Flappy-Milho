import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../espig_game.dart';

class CornPlayer extends PositionComponent with HasGameReference<FlappyCornGame> {
  late double velocity;
  final double gravity = 900.0; 
  final double jumpForce = -400.0; // Pulo mais suave
  final double maxVelocity = 300.0;
  bool isGameOver = false;
  
  @override
  Future<void> onLoad() async {
    size = Vector2(25, 45); // Espiga mais fina
    position = Vector2(100, game.size.y / 2);
    velocity = 0;
  }
  
  @override
  void update(double dt) {

    super.update(dt);
    if (isGameOver) return;
    
    // Aplicar gravidade
    velocity += gravity * dt;
    velocity = velocity.clamp(-maxVelocity, maxVelocity);
    
    // Atualizar posição
    position.y += velocity * dt;
  }
  
  @override
  void render(Canvas canvas) {
    super.render(canvas);
        
    canvas.save();
    canvas.translate(size.x / 2, size.y / 2);
    canvas.rotate((velocity / maxVelocity) *0.4);
    
    final pixelSize = 3.0; 
    final pixelPaint = Paint()..color = Colors.black;
    
    void drawPixel (int x, int y, Color color) {
      final paint = Paint()..color = color;
    canvas.drawRect(
      Rect.fromLTWH(
      (x-8) * pixelSize,
      (y-8) * pixelSize,
      pixelSize,
      pixelSize,
      ),
      paint,
    );
    }
      // Mapeamento manual de "pixels"
  final List<List<Color?>> pixels = [
    // Cada linha representa 1 linha de pixels da imagem (de cima pra baixo)
    // [null, null, null, null, Colors.black, Colors.black, null, null, null, null, null, null, null, null, null, null],
    [null, null, null, null, Colors.black, Colors.black, null, null, null, null, null, null, null, null, null, null],
    [null, null, null, Colors.black, Color(0xFFFFD700), Color(0xFFFFD700), Colors.black, null, null, null, null, null, null, null, null, null],
    [null, null, Colors.black, Color(0xFFFFD700), Color(0xFFFFD700), Color(0xFFFFD700), Color(0xFFFFD700), Colors.black, null, null, null, null, null, null, null, null],
    [null, Colors.black, Color(0xFFFFD700), Color(0xFFFFA500), Color(0xFFFFD700), Color(0xFFFFA500), Color(0xFFFFD700), Color(0xFFFFD700), Colors.black, null, null, null, null, null, null, null],
    [null, Colors.black, Color(0xFFFFD700), Color(0xFFFFD700), Color(0xFFFFD700), Color(0xFFFFD700), Color(0xFFFFD700), Color(0xFFFFD700), Colors.black, null, null, null, null, null, null, null],
    [null, Colors.black, Color(0xFFFFD700), Color(0xFFFFA500), Color(0xFFFFD700), Color(0xFFFFA500), Color(0xFFFFD700), Color(0xFFFFD700), Colors.black, null, null, null, null, null, null, null],
    [null, Colors.black, Color(0xFFFFD700), Color(0xFFFFD700), Color(0xFFFFD700), Color(0xFFFFD700), Color(0xFFFFD700), Color(0xFFFFD700), Colors.black, null, null, null, null, null, null, null],
    [null, Colors.black, Color(0xFFFFD700), Color(0xFFFFA500), Color(0xFFFFD700), Color(0xFFFFA500), Color(0xFFFFD700), Color(0xFFFFD700), Colors.black, null, null, null, null, null, null, null],
    [null, Colors.black, Color(0xFFFFD700), Color(0xFFFFD700), Color(0xFFFFD700), Color(0xFFFFD700), Color(0xFFFFD700), Color(0xFFFFD700), Colors.black, null, null, null, null, null, null, null],
    [null, Colors.black, Color(0xFF32CD32), Color(0xFFFFD700), Color(0xFFFFD700), Color(0xFFFFD700), Color(0xFFFFD700), Color(0xFF32CD32), Colors.black, null, null, null, null, null, null, null],
    [null, null, Colors.black, Color(0xFF32CD32), Color(0xFF32CD32), Color(0xFFFFD700), Color(0xFF32CD32), Colors.black, null, null, null, null, null, null, null, null],
    [null, null, null, Colors.black, Color(0xFF32CD32), Color(0xFF32CD32), Colors.black, null, null, null, null, null, null, null, null, null],
    [null, null, Colors.black, Color(0xFF32CD32), Color(0xFF32CD32), Color(0xFF32CD32), Color(0xFF32CD32), Colors.black, null, null, null, null, null, null, null, null],
  ];
    
    canvas.restore();
    for (int y = 0; y < pixels.length; y++) {
      for (int x = 0; x < pixels[y].length; x++) {
        final color = pixels[y] [x];
        if (color != null) {
          drawPixel(x, y, color);
        }
      }
    }
    canvas.restore();
  }
  
  void jump() {
    velocity = jumpForce;
  }
  
  void reset() {
    position = Vector2(100, game.size.y / 2);
    velocity = 0;
  }
  
  Rect toRect() {
    return Rect.fromLTWH(position.x, position.y, size.x, size.y);
  }
}