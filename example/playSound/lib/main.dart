import 'package:umiuni2d/tinygame.dart';
import 'package:umiuni2d/tinygame_flutter.dart';
import 'package:play_sound/playsound_test.dart';
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
    builder.useTestCanvas = true;
    TinyGameRoot root = new TinyGameRoot(600.0, 400.0);
    TinyStage stage = builder.createStage(root);
    stage.start();
    stage.root.addChild(new Piano(builder));
    return (stage as TinyFlutterStage);
  }
}
