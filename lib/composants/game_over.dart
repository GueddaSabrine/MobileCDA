import 'dart:ui';

import 'package:flame/anchor.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flame/text_config.dart';
import 'package:flappybird/flappy_game.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameOverScreen {
  Rect messageRect;
  Sprite messageSprite;
  final FlappyGame game;
  final int score;
  int highScore;
  TextConfig scoreTextConfig;
  TextConfig highScoreTextConfig;

  GameOverScreen({this.game, this.score}) {
    messageSprite = Sprite('message.png');
    messageRect = Rect.fromCenter(
      center: Offset(game.screenSize.width / 2, game.screenSize.height / 2),
      width: 276,
      height: 400,
    );

    highScore = 0;
    scoreTextConfig = TextConfig(
      fontFamily: 'flappy_font',
      fontSize: 45,
      color: Colors.white,
    );
    highScoreTextConfig = TextConfig(
      fontFamily: 'flappy_font',
      fontSize: 45,
      color: Colors.white,
    );
    getHighScore();
  }


  void update(double t){}

  void render(Canvas canvas) {
    messageSprite.renderRect(canvas, messageRect);
    // affiche le score
    scoreTextConfig.render(
      canvas,
      'SCORE: $score',
      Position(game.screenSize.width / 2, game.screenSize.height / 8),
      anchor: Anchor.center,
    );
    // affiche le meilleur score
    highScoreTextConfig.render(
      canvas,
      'HIGHSCORE: $highScore',
      Position(game.screenSize.width / 2,
          game.screenSize.height - (game.screenSize.height / 8 + 30)),
      anchor: Anchor.center,
    );
  }

  void getHighScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    highScore = prefs.getInt('highScore') ?? 0;
  }
}
