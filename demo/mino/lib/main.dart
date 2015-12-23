//
//
// Flutter entry point
//
//
import 'package:flutter/widgets.dart';
import 'package:flutter/rendering.dart';
import 'package:umiuni2d/tinygame.dart';
import 'package:umiuni2d/tinygame_flutter.dart';
import 'package:mino/game.dart';
import 'dart:async';

void main() {
  runApp(new GameWidget());
}

class GameWidget extends OneChildRenderObjectWidget {
  GameWidget() {}
  RenderObject createRenderObject() {
    TinyGameBuilderForFlutter builder = new TinyGameBuilderForFlutter("web/");
    builder.tickInPerFrame = false;
    TinyStage stage = builder.createStage(new MinoRoot(builder));
    (stage as TinyFlutterStage).isNCanvas = true;
    stage.start();
    return (stage as TinyFlutterStage);
  }
}
