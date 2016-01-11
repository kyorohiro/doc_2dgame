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
import 'dart:async';

void main() {
  runApp(new GameWidget());
}

class GameWidget extends OneChildRenderObjectWidget {
  GameWidget() {}
  RenderObject createRenderObject() {
    TinyGameBuilderForFlutter builder = new TinyGameBuilderForFlutter(assetsRoot:"web/");
    builder.useTestCanvas = true;
    TinyGameRoot root = new TinyGameRoot(450.0, 450.0,bkcolor:new TinyColor.argb(0xaa, 0x00, 0x00, 0x00));
    TinyStage stage = builder.createStage(root);
    stage.start();
    new Future(() async {
      stage.root.addChild(new PhysicsTest(builder));
    });
    return (stage as TinyFlutterStage);
  }
}
