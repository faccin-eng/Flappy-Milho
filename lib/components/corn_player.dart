import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../espig_game.dart';

class CornPlayer extends PositionComponent with HasGameReference<FlappyCornGame> {
  late double velocity;
  final double gravity = 800.0; // Gravidade mais suave
  final double jumpForce = -350.0; // Pulo mais suave
  final double maxVelocity = 300.0;
  
  @override
  Future<void> onLoad() async {
    size = Vector2(25, 45); // Espiga mais fina
    position = Vector2(100, game.size.y / 2);
    velocity = 0;
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    
    // Aplicar gravidade
    velocity += gravity * dt;
    velocity = velocity.clamp(-maxVelocity, maxVelocity);
    
    // Atualizar posição
    position.y += velocity * dt;
  }
  
  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    // Rotação baseada na velocidade
    final rotation = (velocity / maxVelocity) * 0.4;
    
    canvas.save();
    canvas.translate(size.x / 2, size.y / 2);
    canvas.rotate(rotation);
    
    // Desenhar espiga mais fina e detalhada
    final cornPaint = Paint()..color = const Color(0xFFFFD700);
    final kernelPaint = Paint()..color = const Color(0xFFFFA500);
    final leafPaint = Paint()..color = const Color(0xFF32CD32);
    
    // Corpo da espiga (mais fino)
    final cornRect = Rect.fromCenter(
      center: Offset.zero,
      width: size.x * 0.7, // Mais fino
      height: size.y * 0.8,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(cornRect, const Radius.circular(8)),
      cornPaint,
    );
    
    // Grãos de milho em fileiras
    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 3; col++) {
        final x = -size.x * 0.25 + col * 8.0;
        final y = -size.y * 0.3 + row * 5.0;
        canvas.drawCircle(Offset(x, y), 2.5, kernelPaint);
      }
    }
    
    // Folhas no topo
    final leafPath = Path();
    leafPath.moveTo(-size.x * 0.2, -size.y * 0.4);
    leafPath.quadraticBezierTo(-size.x * 0.4, -size.y * 0.6, -size.x * 0.1, -size.y * 0.7);
    leafPath.quadraticBezierTo(size.x * 0.1, -size.y * 0.7, size.x * 0.4, -size.y * 0.6);
    leafPath.quadraticBezierTo(size.x * 0.2, -size.y * 0.4, 0, -size.y * 0.4);
    leafPath.close();
    canvas.drawPath(leafPath, leafPaint);
    
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