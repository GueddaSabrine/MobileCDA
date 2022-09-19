import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:flappybird/flappy_game.dart';

class Background {
  Rect bgRect;
  Sprite bgSprite;
  final FlappyGame game;

  Background({this.game}) {
  bgSprite = Sprite('background.png');
  bgRect = Rect.fromLTWH(0, 0, game.screenSize.width, game.screenSize.height);
  }

  void update (double t){}

  void render(Canvas canvas) {
    bgSprite.renderRect(canvas, bgRect);
  }

}