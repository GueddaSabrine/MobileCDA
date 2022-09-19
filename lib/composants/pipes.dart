import 'dart:math';
import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:flappybird/flappy_game.dart';

const double PIPE_WIDTH = 70;
const double PIPE_HEAD_HEIGHT = 24;
const double SPACE_BETWEEN_PIPES = 180;
const double PIPE_MOVEMENT = 130;

class Pipes {
  Rect topPipeBodyRect;
  Rect topPipeHeadRect;
  Sprite topPipeBodySprite;
  Sprite topPipeHeadSprite;
  final FlappyGame game;

  Rect bottomPipeBodyRect;
  Rect bottomPipeHeadRect;
  Sprite bottomPipeBodySprite;
  Sprite bottomPipeHeadSprite;
  List<double> heights;
  bool isVisible = true;
  bool canUpdateScore = true;

  Pipes({this.game}){
    // initialiser la liste de hauteur
    heights = [
      game.screenSize.height / 6,
      game.screenSize.height / 4,
      game.screenSize.height / 3,
      game.screenSize.height / 2
    ];

    int index = Random().nextInt(heights.length);
    
    // sprites du pipe du haut
    topPipeBodySprite = Sprite('pipe_body.png');
    topPipeHeadSprite = Sprite('pipe_head.png');

    // sprites du pipe du bas
    bottomPipeBodySprite = Sprite('pipe_body.png');
    bottomPipeHeadSprite = Sprite('pipe_head.png');

    double topPipeBodyHeight = heights[index];
    
    // RECT du pipe du haut
    topPipeBodyRect = Rect.fromLTWH(
      game.screenSize.width + 10,
      0,
      PIPE_WIDTH,
      topPipeBodyHeight,
    );

    topPipeHeadRect = Rect.fromLTWH(
      game.screenSize.width + 10,
      topPipeBodyHeight,
      PIPE_WIDTH + 2,
      PIPE_HEAD_HEIGHT,
    );

    //RECT du pipe du bas
    bottomPipeHeadRect = Rect.fromLTWH(
      game.screenSize.width + 10,
      topPipeBodyHeight + PIPE_HEAD_HEIGHT + SPACE_BETWEEN_PIPES,
      PIPE_WIDTH + 2,
      PIPE_HEAD_HEIGHT,
    );

    bottomPipeBodyRect = Rect.fromLTWH(
      game.screenSize.width + 10,
      topPipeBodyHeight +
          PIPE_HEAD_HEIGHT +
          SPACE_BETWEEN_PIPES +
          PIPE_HEAD_HEIGHT,
      PIPE_WIDTH,
      game.screenSize.height -
          (topPipeBodyHeight +
              PIPE_HEAD_HEIGHT +
              SPACE_BETWEEN_PIPES +
              PIPE_HEAD_HEIGHT),
    );
  }

  void update(double t){
    topPipeBodyRect = topPipeBodyRect.translate(-t * PIPE_MOVEMENT, 0);
    topPipeHeadRect = topPipeHeadRect.translate(-t * PIPE_MOVEMENT, 0);
    bottomPipeBodyRect = bottomPipeBodyRect.translate(-t * PIPE_MOVEMENT, 0);
    bottomPipeHeadRect = bottomPipeHeadRect.translate(-t * PIPE_MOVEMENT, 0);

    //verifie si le tube est sorti de l'écran
    if (topPipeBodyRect.right < -20) {
      isVisible = false;
    }
  }

  void render(Canvas canvas){
    //on affiche le body du top pipe
    topPipeBodySprite.renderRect(canvas, topPipeBodyRect);

    //on affiche la tête du top pipe
    topPipeHeadSprite.renderRect(canvas, topPipeHeadRect);

    // on affiche le tube du bas
    bottomPipeHeadSprite.renderRect(canvas, bottomPipeHeadRect);
    bottomPipeBodySprite.renderRect(canvas, bottomPipeBodyRect);
  }

//gestion de la collision
  bool hasCollided(Rect myRect) {
    if (topPipeBodyRect.overlaps(myRect) ||
        topPipeHeadRect.overlaps(myRect) ||
        bottomPipeBodyRect.overlaps(myRect) ||
        bottomPipeHeadRect.overlaps(myRect)) {
      return true;
    } else {
      return false;
    }
  }
}