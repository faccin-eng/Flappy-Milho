import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../espig_game.dart';

class Building extends PositionComponent with HasGameReference<FlappyCornGame> {
  final double gapY;
  final double gapSize;
  final double gameSpeed;
  bool scored = false;

  late List<List<int>> topTowerPixels;
  late List<List<int>> bottomTowerPixels;
  late int towerWidth;
  late int topTowerHeight;
  late int bottomTowerHeight;
  
  
  Building({
    required this.gapY,
    required this.gapSize,
    required this.gameSpeed,
  });
  
  @override
  Future<void> onLoad() async {
    size = Vector2(80, game.size.y);
    _generateRandomTowers();
  }

  void _generateRandomTowers(){
    final random = math.Random();
  //largura
    towerWidth = 16 + random.nextInt(17);
  
    final availableSpaceTop = gapY;
    final availableSpaceBottom = size.y - gapY - gapSize;
  //altura
    topTowerHeight = (availableSpaceTop * 0.3).clamp(8, 120).toInt(); // 30% do espaço disponível
    bottomTowerHeight = (availableSpaceBottom * 0.3).clamp(8, 120).toInt();
  //gera torres
    topTowerPixels = _generateTowerPixels(towerWidth, topTowerHeight);
    bottomTowerPixels = _generateTowerPixels(towerWidth, bottomTowerHeight);
  }

  List<List<int>> _generateTowerPixels(int width, int height){
    final random = math.Random();
    List<List<int>> pixels = [];

    for (int y = 0; y < height; y++){
      List<int> row = [];
      for (int x = 0; x < width; x++) {
        int pixel; 

        if (y == 0 || y == height - 1) {
          pixel = (x >= 2 && x < width -2) ? 3 : 0 ; //telhado laranja
        } else if ( x == 0 || x == width -1){
          pixel = 0; //bordas transparentes
        } else if (x == 1 || x == width -2) {
          pixel = 1;
        } else {
          if (y % 3 == 1 && x % 4 == 2){
            pixel = 2; //janela azul
          } else {
            pixel = 1; //parede bege
          }
        }
        row.add(pixel);
      }
      pixels.add(row);
    }
    return pixels;
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    position.x -= gameSpeed * dt;
  }
  
  @override
void render(Canvas canvas) {
  const pixelSize = 4.0; // Tamanho do "pixel"
  final colors = {
    0: null, // transparente
    1: Paint()..color = const Color(0xFFF3F1E1), // parede
    2: Paint()..color = const Color.fromARGB(255, 44, 83, 167), // janelas/faixas
    3: Paint()..color = const Color(0xFFF5803C), // telhado
  };

   // ALTERAÇÃO: Desenha a torre superior com tamanho aleatório
    for (int y = 0; y < topTowerPixels.length; y++) {
      for (int x = 0; x < topTowerPixels[y].length; x++) {
        final colorIndex = topTowerPixels[y][x];
        final paint = colors[colorIndex];
        if (paint != null) {
          canvas.drawRect(
            Rect.fromLTWH(x * pixelSize, y * pixelSize, pixelSize, pixelSize),
            paint,
          );
        }
      }
    }

    // ALTERAÇÃO: Desenha a torre inferior com tamanho aleatório
    for (int y = 0; y < bottomTowerPixels.length; y++) {
      for (int x = 0; x < bottomTowerPixels[y].length; x++) {
        final colorIndex = bottomTowerPixels[y][x];
        final paint = colors[colorIndex];
        if (paint != null) {
          // Posiciona a torre inferior no final da tela
          final mirroredY = size.y - (bottomTowerPixels.length - y) * pixelSize;
          canvas.drawRect(
            Rect.fromLTWH(x * pixelSize, mirroredY, pixelSize, pixelSize),
            paint,
          );
        }
      }
    }
  }
 
  Rect getTopRect() {
    return Rect.fromLTWH(position.x, 0, size.x, gapY);
  }
  
  Rect getBottomRect() {
    return Rect.fromLTWH(
      position.x,
      gapY + gapSize,
      size.x,
      size.y - gapY - gapSize,
    );
  }
}


  // Prédio 3rd stage 
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