import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../espig_game.dart';

class Building extends PositionComponent with HasGameReference<FlappyCornGame> {
  final double gapY;
  final double gapSize;
  final double gameSpeed;
  bool scored = false;
  
  // NOVA ADIÇÃO: Variáveis para torres aleatórias
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
    
    // NOVA ADIÇÃO: Gera torres aleatórias quando o componente é carregado
    _generateRandomTowers();
  }
  
  // ALTERAÇÃO: Gera torres com gap fixo
  void _generateRandomTowers() {
    final random = math.Random();
    
    // Largura da torre pode variar entre 16 e 32 pixels
    towerWidth = 16 + random.nextInt(17); // 16 a 32
    
    // CORREÇÃO: Calcula alturas baseadas no gap fixo para manter espaço igual
    final availableSpaceTop = gapY;
    final availableSpaceBottom = size.y - gapY - gapSize;
    
    // Altura das torres baseada no espaço disponível (com margem mínima)
    topTowerHeight = (availableSpaceTop * 0.3).clamp(8, 24).toInt(); // 30% do espaço disponível
    bottomTowerHeight = (availableSpaceBottom * 0.3).clamp(8, 24).toInt(); // 30% do espaço disponível
    
    // Gera as torres
    topTowerPixels = _generateTowerPixels(towerWidth, topTowerHeight);
    bottomTowerPixels = _generateTowerPixels(towerWidth, bottomTowerHeight);
  }
  
  // NOVA FUNÇÃO: Gera os pixels de uma torre com dimensões específicas
  List<List<int>> _generateTowerPixels(int width, int height) {
    final random = math.Random();
    List<List<int>> pixels = [];
    
    for (int y = 0; y < height; y++) {
      List<int> row = [];
      for (int x = 0; x < width; x++) {
        int pixel;
        
        // Lógica para gerar a torre:
        if (y == 0 || y == height - 1) {
          // Primeira e última linha: telhado
          pixel = (x >= 2 && x < width - 2) ? 3 : 0; // telhado laranja
        } else if (x == 0 || x == width - 1) {
          // Bordas laterais: transparente
          pixel = 0;
        } else if (x == 1 || x == width - 2) {
          // Bordas internas: parede
          pixel = 1;
        } else {
          // Interior: alterna entre parede e janelas
          if (y % 3 == 1 && x % 4 == 2) {
            pixel = 2; // janela azul
          } else {
            pixel = 1; // parede bege
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
      2: Paint()..color = const Color(0xFF2C91A7), // janelas/faixas
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
  
  // CORREÇÃO: Remove position.y pois Building sempre está em Y=0
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