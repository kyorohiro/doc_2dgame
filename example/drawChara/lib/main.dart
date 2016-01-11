//
//
// Flutter entry point
//
//
import 'package:flutter/widgets.dart';
import 'package:flutter/rendering.dart';
import 'package:umiuni2d/tinygame.dart';
import 'package:umiuni2d/tinygame_flutter.dart';
import 'test.dart';

void main() {
  runApp(new GameWidget());
}

class GameWidget extends OneChildRenderObjectWidget {
  GameWidget() {}
  RenderObject createRenderObject() {
    TinyGameBuilderForFlutter builder = new TinyGameBuilderForFlutter(assetsRoot:"web/");
    builder.useTestCanvas = true;
    TinyStage stage = builder.createStage(new CharaGameRoot(builder));
    stage.start();
    return (stage as TinyFlutterStage);
  }
}
