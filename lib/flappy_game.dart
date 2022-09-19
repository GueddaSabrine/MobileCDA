import 'dart:ui';

import 'package:flame/anchor.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flame/position.dart';
import 'package:flame/text_config.dart';
import 'package:flame/time.dart';
import 'package:flappybird/composants/background.dart';
import 'package:flappybird/composants/base.dart';
import 'package:flappybird/composants/bird.dart';
import 'package:flappybird/composants/game_over.dart';
import 'package:flappybird/composants/pipes.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FlappyGame extends Game with TapDetector {
  Size screenSize;
  Background background;
  List<Base> baseList;
  List<Pipes> pipeList = [];
  Timer timer;
  Bird bird;
  GameOverScreen endMessage;
  bool isPlaying = false;
  int score = 0;
  TextConfig scoreTextConfig;
  int highScore = 0;
  SharedPreferences prefs;

//constructor
  FlappyGame() {
    initialize();
  }

  void initialize() async {
    resize(await Flame.util.initialDimensions());
    background = Background(game: this);
    createBase();
    timer = Timer(2, repeat: true, callback: () {
      Pipes newPipes = Pipes(game: this);
      pipeList.add(newPipes);
    });

    bird = Bird(game: this);

    timer.start();

    endMessage = GameOverScreen(game: this, score: score);

    // initialiser textConfig
    scoreTextConfig = TextConfig(
      fontSize: 45,
      fontFamily: 'flappy_font',
      color: Colors.white,
    );
  }

  @override
  void render(Canvas canvas) {
    background.render(canvas);

    if (isPlaying == true) {
      //affiche la liste de pipes
      pipeList.forEach((Pipes pipes) {
        pipes.render(canvas);
      });

      //affiche le bird
      bird.render(canvas);

      //affiche le score
      scoreTextConfig.render(
        canvas,
        score.toString(),
        Position(screenSize.width / 2, screenSize.height / 8),
        anchor: Anchor.center,
      );
    } else {
      endMessage.render(canvas);
    }

    //affiche les bases
    baseList.forEach((Base base) {
      base.render(canvas);
    });
  }

  @override
  void update(double t) {
    if (isPlaying == true) {
      timer.update(t);

      //déplacement des tubes
      pipeList.forEach((Pipes pipes) {
        pipes.update(t);
      });

      //supprimer les pipes qui ne sont pas visible
      pipeList.removeWhere((Pipes pipes) => pipes.isVisible == false);

      bird.update(t);
      updateScore();
      gameOver();
    }

    baseList.forEach((Base base) {
      base.update(t);
    });

    baseList.removeWhere((Base base) => base.isVisible == false);
    if (baseList.length < 2) {
      createBase();
    }
  }

  void resize(Size size) {
    super.resize(size);
    screenSize = size;
  }

  void createBase() {
    baseList = [];
    Base firstBase = Base(game: this, leftPosition: 0);
    Base secondBase = Base(game: this, leftPosition: screenSize.width);
    baseList.add(firstBase);
    baseList.add(secondBase);
  }

  @override
  void onTap() {
    super.onTap();
    if (isPlaying == true) {
      bird.onTap();
    } else {
      pipeList.clear();
      isPlaying = true;
      timer.start();
    }
  }

//si le bird a touché un tube
  void gameOver() {
    pipeList.forEach((Pipes pipes) {
      if (pipes.hasCollided(bird.birdRect)) {
        Flame.audio.play('hit.wav');
        reset();
      }
    });

    //collision avec le sol
    baseList.forEach((Base base) {
      if (base.hasCollided(bird.birdRect)) {
        Flame.audio.play('hit.wav');
        reset();
      }
    });

    // collision avec le haut de l'écran
    if (bird.birdRect.top <= 0) {
      Flame.audio.play('hit.wav');
      reset();
    }
  }

//rénitialiser certains évènements
  void reset() {
    isPlaying = false;
    timer.stop();
    bird = Bird(game: this);
    endMessage = GameOverScreen(game: this, score: score);
    score = 0;
  }

  void updateScore() {
    pipeList.forEach((Pipes pipes) {
      if (pipes.canUpdateScore == true) {
        if (bird.birdRect.right >=
            pipes.topPipeBodyRect.left + pipes.topPipeBodyRect.width / 2) {
          score++;
          Flame.audio.play('point.wav');
          pipes.canUpdateScore = false;

          // update le meilleur score
          if (score > highScore) {
            saveHighScore();
          }
        }
      }
    });
  }

  void saveHighScore() async {
    highScore = score;
    prefs = await SharedPreferences.getInstance();
    prefs.setInt('highScore', highScore);
  }
}
