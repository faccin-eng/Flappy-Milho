import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../espig_game.dart';

class Building extends Component with HasGameReference<FlappyCornGame> {
  final double gapY;
  final double gapSize;
  final double gameSpeed;
  bool scored = false;
  
   SpriteComponent top = SpriteComponent();
   SpriteComponent bottom = SpriteComponent();

  Building({
    required this.gapY,
    required this.gapSize,
    required this.gameSpeed,
  });
  
  @override
  Future<void> onLoad() async {
    final topSprite = await game.loadSprite('building_top.png');
    final bottomSprite = await game.loadSprite('building_bottom.png');
   
    final buildingWidth = 80.0;
    final topHeight = gapY;
    final bottomHeight = game.size.y - gapY - gapSize;

    top = SpriteComponent(
      sprite: topSprite,
      size: Vector2(buildingWidth, topHeight),
      position: Vector2(game.size.x, 0),
      anchor: Anchor.topLeft,
    )..add(RectangleHitbox());

    bottom = SpriteComponent(
      sprite: bottomSprite,
      size: Vector2(buildingWidth, bottomHeight),
      position: Vector2(game.size.x, gapY + gapSize),
      anchor: Anchor.topLeft,
      )..add(RectangleHitbox());


    addAll([top, bottom]);
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    final dx=gameSpeed * dt;
    top.position.x -= dx;
    bottom.position.x -= dx;
  }
  
  double get x => top.position.x;
  double get width => top.size.x;
  bool get isOffScreen => x + width <0 ;

  Rect getTopRect() => top.toRect();
  Rect getBottomRect() => bottom.toRect();
  
  }

  // @override
  // void render(Canvas canvas) {
  //   final buildingPaint = Paint()..color = const Color(0xFF654321);
  //   final windowPaint = Paint()..color = const Color(0xFF8B4513);
  //   final roofPaint = Paint()..color = const Color(0xFF8B0000);
    
  //   // Prédio superior
  //   final topBuilding = Rect.fromLTWH(0, 0, size.x, gapY);
  //   canvas.drawRect(topBuilding, buildingPaint);
    
  //   // Prédio inferior
  //   final bottomBuilding = Rect.fromLTWH(0, gapY + gapSize, size.x, size.y - gapY - gapSize);
  //   canvas.drawRect(bottomBuilding, buildingPaint);
    
  //   // Janelas do prédio superior
  //   drawWindows(canvas, windowPaint, 0, gapY);
    
  //   // Janelas do prédio inferior
  //   drawWindows(canvas, windowPaint, gapY + gapSize, size.y - gapY - gapSize);
    
  //   // Telhados
  //   canvas.drawRect(Rect.fromLTWH(-5, gapY - 10, size.x + 10, 10), roofPaint);
  //   canvas.drawRect(Rect.fromLTWH(-5, gapY + gapSize, size.x + 10, 10), roofPaint);
  // }
  
  // void drawWindows(Canvas canvas, Paint paint, double startY, double height) {
  //   const windowSize = 12.0;
  //   const windowSpacing = 20.0;
    
  //   for (double x = 10; x < size.x - 10; x += windowSpacing) {
  //     for (double y = startY + 15; y < startY + height - 15; y += 25) {
  //       canvas.drawRect(
  //         Rect.fromLTWH(x, y, windowSize, windowSize),
  //         paint,
  //       );
  //     }
  //   }
  // }
  