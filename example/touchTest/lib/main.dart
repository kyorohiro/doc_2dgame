//
//
// Flutter entry point
//
//
import 'package:flutter/widgets.dart';
import 'package:flutter/rendering.dart';
import 'package:umiuni2d/tinygame.dart';
import 'package:umiuni2d/tinygame_flutter.dart';
import 'package:touch_test/touch_test.dart';
import 'dart:async';

void main() {
  runApp(new GameWidget());
}

class GameWidget extends OneChildRenderObjectWidget {
  GameWidget() {}
  RenderObject createRenderObject() {
    TinyGameBuilderForFlutter builder = new TinyGameBuilderForFlutter(assetsRoot:"web/");
    builder.useTestCanvas = true;
    TinyGameRoot root = new TinyGameRoot(400.0, 300.0);
    TinyStage stage = builder.createStage(root);
    stage.start();
    stage.root.addChild(new PrimitiveTest(builder));
    return (stage as TinyFlutterStage);
  }
}
