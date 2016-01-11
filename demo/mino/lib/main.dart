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

void main() {
  runApp(new GameWidget());
}

class GameWidget extends OneChildRenderObjectWidget {
  GameWidget() {}
  RenderObject createRenderObject() {
    TinyGameBuilderForFlutter builder = new TinyGameBuilderForFlutter(assetsRoot:"web/");
    builder.tickInPerFrame = false;
    builder.useTestCanvas = true;
    TinyStage stage = builder.createStage(new MinoRoot(builder));
    stage.start();
    return (stage as TinyFlutterStage);
  }
}
