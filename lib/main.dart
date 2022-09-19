import 'package:flame/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'flappy_game.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Util flameUtil = Util();
  //forcer le mode full screen
    flameUtil.fullScreen();
  // focer le mode portrait
  flameUtil.setOrientation(DeviceOrientation.portraitUp);

  FlappyGame game = FlappyGame();
  runApp(game.widget);
}