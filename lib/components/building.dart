import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../espig_game.dart';

class Building extends PositionComponent with HasGameReference<FlappyCornGame> {
  final double gapY;
  final double gapSize;
  final double gameSpeed;
  bool scored = false;
  
  Building({
    required this.gapY,
    required this.gapSize,
    required this.gameSpeed,
  });
  
  @override
  Future<void> onLoad() async {
    size = Vector2(80, game.size.y);
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    position.x -= gameSpeed * dt;
  }
  
  @override
  void render(Canvas canvas) {
    final buildingPaint = Paint()..color = const Color(0xFF654321);
    final windowPaint = Paint()..color = const Color(0xFF8B4513);
    final roofPaint = Paint()..color = const Color(0xFF8B0000);
    
    // Prédio superior
    final topBuilding = Rect.fromLTWH(0, 0, size.x, gapY);
    canvas.drawRect(topBuilding, buildingPaint);
    
    // Prédio inferior
    final bottomBuilding = Rect.fromLTWH(0, gapY + gapSize, size.x, size.y - gapY - gapSize);
    canvas.drawRect(bottomBuilding, buildingPaint);
    
    // Janelas do prédio superior
    drawWindows(canvas, windowPaint, 0, gapY);
    
    // Janelas do prédio inferior
    drawWindows(canvas, windowPaint, gapY + gapSize, size.y - gapY - gapSize);
    
    // Telhados
    canvas.drawRect(Rect.fromLTWH(-5, gapY - 10, size.x + 10, 10), roofPaint);
    canvas.drawRect(Rect.fromLTWH(-5, gapY + gapSize, size.x + 10, 10), roofPaint);
  }
  
  void drawWindows(Canvas canvas, Paint paint, double startY, double height) {
    const windowSize = 12.0;
    const windowSpacing = 20.0;
    
    for (double x = 10; x < size.x - 10; x += windowSpacing) {
      for (double y = startY + 15; y < startY + height - 15; y += 25) {
        canvas.drawRect(
          Rect.fromLTWH(x, y, windowSize, windowSize),
          paint,
        );
      }
    }
  }
  
  Rect getTopRect() {
    return Rect.fromLTWH(position.x, position.y, size.x, gapY);
  }
  
  Rect getBottomRect() {
    return Rect.fromLTWH(
      position.x,
      position.y + gapY + gapSize,
      size.x,
      size.y - gapY - gapSize,
    );
  }
}