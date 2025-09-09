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
    topTowerHeight = (availableSpaceTop * 0.3).clamp(8, 120).toInt(); // 30% do espaço disponível
    bottomTowerHeight = (availableSpaceBottom * 0.3).clamp(8, 120).toInt();
  //gera torres
    topTowerPixels = _generateTowerPixels(towerWidth, topTowerHeight);
    bottomTowerPixels = _generateTowerPixels(towerWidth, bottomTowerHeight);
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
void _renderTowers(Canvas canvas) {
  const pixelSize = 4.0; 
  final colors = {
    0: null, 
    1: Paint()..color = const Color(0xFFF3F1E1), // parede
    2: Paint()..color = const Color.fromARGB(255, 44, 83, 167), // janelas/faixas
    3: Paint()..color = const Color(0xFFF5803C), // telhado
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
