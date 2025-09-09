import 'dart:ui' as ui;
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
  late ui.Image cachedImage;
  bool imageReady = false;
  
  
  Building({
    required this.gapY,
    required this.gapSize,
    required this.gameSpeed,
  });
  
  @override
  Future<void> onLoad() async {
    size = Vector2(80, game.size.y);
    _generateRandomTowers();
    await _cacheImage();
  }

  void _generateRandomTowers(){
    final random = math.Random();
  //largura
    towerWidth = 16 + random.nextInt(17);
  
    final availableSpaceTop = gapY;
    final availableSpaceBottom = size.y - gapY - gapSize;
  //altura
    topTowerHeight = (availableSpaceTop * 0.3).clamp(20, 120).toInt(); // 30% do espaço disponível
    bottomTowerHeight = (availableSpaceBottom * 0.3).clamp(20, 120).toInt();
  //gera torres
    topTowerPixels = _generateTowerPixels(towerWidth, topTowerHeight, true);
    bottomTowerPixels = _generateTowerPixels(towerWidth, bottomTowerHeight, false);
  }

  Future<void> _cacheImage() async{
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    _renderTowers(canvas);

    final picture = recorder.endRecording();
    cachedImage = await picture.toImage(
      (towerWidth * 4).toInt(),
      game.size.y.toInt());
      imageReady = true;
  }

List<List<int>> _generateTowerPixels(int width, int height, bool isTopTower) {
  List<List<int>> pixels = [];
  
  if (isTopTower) {
    // TORRE SUPERIOR - Corpo em cima, telhado EMBAIXO (apontando para o gap)
    
    // Corpo da torre primeiro
    for (int y = 0; y < height - 6; y++) {
      List<int> row = [];
      for (int x = 0; x < width; x++) {
        if (x == 0 || x == width - 1) {
          row.add(1); // Bordas
        }
        else if (y % 8 >= 2 && y % 8 <= 5 && x >= 4 && x < width - 4) {
          row.add(2); // Janela azul
        }
        else {
          row.add(1); // Parede
        }
      }
      pixels.add(row);
    }
    
    // Base do telhado
    List<int> roofBase = [];
    for (int x = 0; x < width; x++) {
      roofBase.add(3);
    }
    pixels.add(roofBase);
    
    // Telhado triangular APONTANDO PARA BAIXO (para o gap)
    for (int y = 0; y < 5; y++) {
      List<int> row = [];
      int margin = y;
      for (int x = 0; x < width; x++) {
        if (x >= margin && x < width - margin) {
          row.add(3); // Telhado
        } else {
          row.add(0);
        }
      }
      pixels.add(row);
    }
    
  } else {
    // TORRE INFERIOR - Telhado EM CIMA (apontando para o gap), corpo embaixo
    
    // Telhado triangular APONTANDO PARA CIMA (para o gap)
    for (int y = 0; y < 5; y++) {
      List<int> row = [];
      int margin = 5 - y - 1;
      for (int x = 0; x < width; x++) {
        if (x >= margin && x < width - margin) {
          row.add(3); // Telhado
        } else {
          row.add(0);
        }
      }
      pixels.add(row);
    }
    
    // Base do telhado
    List<int> roofBase = [];
    for (int x = 0; x < width; x++) {
      roofBase.add(3);
    }
    pixels.add(roofBase);
    
    // Corpo da torre
    for (int y = 6; y < height; y++) {
      List<int> row = [];
      for (int x = 0; x < width; x++) {
        if (x == 0 || x == width - 1) {
          row.add(1); // Bordas
        }
        else if (y % 8 >= 2 && y % 8 <= 5 && x >= 4 && x < width - 4) {
          row.add(2); // Janela azul
        }
        else {
          row.add(1); // Parede
        }
      }
      pixels.add(row);
    }
  }
  
  return pixels;
}
  
  @override
  void update(double dt) {
    super.update(dt);
    position.x -= gameSpeed * dt;
  }
  
  @override
void _renderTowers(Canvas canvas) {
  const pixelSize = 4.0; 
  final colors = {
    0: null, 
    1: Paint()..color = const Color(0xFFF5F5DC), // parede
    2: Paint()..color = const Color(0xFF4169E1), // janelas/faixas
    3: Paint()..color = const Color(0xFFD2691E), // telhado
  };


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
    return Rect.fromLTWH(
    0,
    0,
    towerWidth * 4.0,
    topTowerHeight * 4.0
    );
  }
  
  Rect getBottomRect() {
    final bottomY = size.y - (bottomTowerHeight * 4.0);
    return Rect.fromLTWH(
      0,
      bottomY,
      towerWidth * 4.0,
      bottomTowerHeight * 4.0
    );
  }

  @override
  void render(Canvas canvas){
    if (!imageReady) return;
    canvas.drawImage(cachedImage, Offset.zero, Paint());

  }
}
