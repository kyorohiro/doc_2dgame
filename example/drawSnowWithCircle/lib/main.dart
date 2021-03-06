import 'package:umiuni2d/tinygame.dart';
import 'package:umiuni2d/tinygame_flutter.dart';
import 'package:snowtest/snow_test.dart';
//
import 'package:flutter/widgets.dart';
import 'package:flutter/rendering.dart';

main() async {
  runApp(new GameWidget());
}

class GameWidget extends OneChildRenderObjectWidget {
  GameWidget() {}
  RenderObject createRenderObject() {
    TinyGameBuilderForFlutter builder = new TinyGameBuilderForFlutter(assetsRoot:"web/");
    builder.tickInPerFrame = false;
    builder.useTestCanvas = true;
    TinyGameRoot root = new TinyGameRoot(400.0, 300.0);
    TinyStage stage = builder.createStage(root);
    stage.start();
    print("-----aaaa---");
    stage.root.addChild(new SnowTest(builder));
    return (stage as TinyFlutterStage);
  }
}
