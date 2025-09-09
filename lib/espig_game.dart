import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'package:flame_audio/flame_audio.dart';
import 'components/corn_player.dart';
import 'components/building.dart';
import 'components/background.dart';

enum GameState { menu, playing, gameOver, paused }

class FlappyCornGame extends FlameGame with HasKeyboardHandlerComponents, TapDetector {
  late CornPlayer player;
  late Background background;
  late TextComponent scoreText;
  late TextComponent titleText;
  late TextComponent instructionText;
  
  List<Building> buildings = [];
  GameState gameState = GameState.menu;
  int score = 0;
  double gameSpeed = 120.0; // Pixels por segundo
  double buildingSpawnTimer = 0;
  final double buildingSpawnInterval = 2.5; // Segundos entre prédios
  final double buildingGap = 280.0; // Abertura maior para facilitar
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();

      await FlameAudio.audioCache.load('theme_game.wav');
      FlameAudio.bgm.initialize();
      FlameAudio.bgm.play('theme_game.wav', volume: 0.5); 
    
    // Configurar câmera
    camera.viewfinder.visibleGameSize = size;
    
    // Adicionar componentes
    background = Background();
    add(background);
    
    player = CornPlayer();
    add(player);
    
    scoreText = TextComponent(
      text: 'Pontuação: 0',
      position: Vector2(20, 50),
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              blurRadius: 4,
              color: Colors.black,
              offset: Offset(2, 2),
            ),
          ],
        ),
      ),
    );
    add(scoreText);
    
    // Título do menu
    titleText = TextComponent(
      text: '🌽 FLAPPY ESPIGA 🌽',
      position: Vector2(size.x / 2, size.y / 2 - 100),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFFFFD700),
          fontSize: 36,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              blurRadius: 6,
              color: Colors.black,
              offset: Offset(3, 3),
            ),
          ],
        ),
      ),
    );
    add(titleText);

        instructionText = TextComponent(
      text: 'Toque para começar!\nToque para voar entre o portal pomerano',
      position: Vector2(size.x / 2, size.y / 2 + 50),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          shadows: [
            Shadow(
              blurRadius: 4,
              color: Colors.black,
              offset: Offset(2, 2),
            ),
          ],
        ),
      ),
    );
    add(instructionText);
    
    showMenu();
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    if (gameState == GameState.playing) {
      updateGame(dt);
          
    }
  }
  
  void updateGame(double dt) {
    // Spawnar prédios
    player.isGameOver = false;
    buildingSpawnTimer += dt;
    if (buildingSpawnTimer >= buildingSpawnInterval) {
      spawnBuilding();
      buildingSpawnTimer = 0;
    }
    
    // Remover prédios fora da tela
    buildings.removeWhere((building) {
      if (building.x + building.width < 0) {
        building.removeFromParent();
        return true;
      }
      return false;
    });
    
    // Verificar colisões
    checkCollisions();
    
    // Verificar pontuação
    updateScore();
  }
  
  void spawnBuilding() {
    final double minGapY = 100;
    final double maxGapY = size.y - buildingGap - 100;
    final double gapY = math.Random().nextDouble() * (maxGapY - minGapY) + minGapY;
    
    final newBuilding = Building(
      gapY: gapY,
      gapSize: buildingGap,
      gameSpeed: gameSpeed,
    );
    newBuilding.position = Vector2(size.x, 0);
    buildings.add(newBuilding);
    add(newBuilding);
  }
  
  void checkCollisions() {
    final playerRect = Rect.fromLTWH(
      player.position.x - player.size.x / 2, 
      player.position.y - player.size.y / 2, 
      player.size.x, 
      player.size.y
    );

    for (final building in buildings) {
      final topRect = building.getTopRect().translate(building.position.x, building.position.y);
      final bottomRect = building.getBottomRect().translate(building.position.x, building.position.y);


      if (playerRect.overlaps(topRect) || playerRect.overlaps(bottomRect)) {
        gameOver();
        return;
      }
    }
    if (player.position.y - player.size.y/2 < 0 || player.position.y + player.size.y/2 > size.y){
      gameOver();
    }
  }
  
  void updateScore() {
    for (final building in buildings) {
      if (!building.scored && 
          building.x + building.width < player.position.x) {
        building.scored = true;
        score++;
        scoreText.text = 'Pontuação: $score';
        
        // Aumentar velocidade gradualmente
        if (score % 5 == 0) {
          gameSpeed += 10;
        }
      }
    }
  }
    void showMenu() {
    gameState = GameState.menu;
  titleText.textRenderer = TextPaint(
    style: TextStyle(
      color: const Color.fromARGB(255, 255, 255, 255), 
      fontSize: 24,
    ),
  );
  instructionText.textRenderer = TextPaint(
    style: TextStyle(
      color: const Color.fromARGB(255, 255, 255, 255), 
      fontSize:18,
    ),
  );
  scoreText.textRenderer = TextPaint(
    style: TextStyle(
      color: const Color.fromARGB(255, 255, 255, 255), 
      fontSize: 18,
    ),
  );
  }
  
void hideMenu() {
  titleText.textRenderer = TextPaint(
    style: TextStyle(
      color: const Color.fromARGB(0, 255, 255, 255), 
      fontSize: 24,
    ),
  );
  instructionText.textRenderer = TextPaint(
    style: TextStyle(
      color: const Color.fromARGB(0, 255, 255, 255), 
      fontSize: 18,
    ),
  );
  scoreText.textRenderer = TextPaint(
    style: TextStyle(
      color: const Color.fromARGB(255, 255, 255, 255), 
      fontSize: 18,
    ),
  );
}


  void startGame() {
    gameState = GameState.playing;
    hideMenu();
    resetGame();
  }
  
  void gameOver() {
    gameState = GameState.gameOver;
    player.isGameOver = true;
    instructionText.text = 'GAME OVER!\n Pontuação: $score\n\nToque para jogar novamente';
  titleText.textRenderer = TextPaint(
    style: TextStyle(
      color: const Color.fromARGB(255, 255, 255, 255), 
      fontSize: 24,
    ),
  );
  instructionText.textRenderer = TextPaint(
    style: TextStyle(
      color: const Color.fromARGB(255, 255, 255, 255), 
      fontSize:18,
    ),
  );
  scoreText.textRenderer = TextPaint(
    style: TextStyle(
      color: const Color.fromARGB(0, 255, 255, 255), 
      fontSize: 18,
    ),
  );
  }
  

  void resetGame() {
    score = 0;
    gameSpeed = 120.0;
    buildingSpawnTimer = 0;
    scoreText.text = 'Pontuação: 0';
    
    // Remover todos os prédios
    for (final building in buildings) {
      building.removeFromParent();
    }
    buildings.clear();
    
    // Resetar jogador
    player.reset();
  }
  
  
  void jump() {
    if (gameState == GameState.playing) {
      player.jump();
    } else if (gameState == GameState.menu){
      startGame();
    } else if (gameState == GameState.gameOver) {
      showMenu();
    }
  }
  
  @override
  bool onTapDown(TapDownInfo info) {
    jump();
    return true;
  }
}
