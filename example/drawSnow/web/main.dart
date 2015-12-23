import 'package:umiuni2d/tinygame.dart';
import 'package:umiuni2d/tinygame_webgl.dart';
//import 'package:vector_math/vector_math_64.dart';
import 'package:snowtest/snow_test.dart';

main() async {
  TinyGameBuilderForWebgl builder = new TinyGameBuilderForWebgl();
  builder.paintInterval = 0;
  TinyGameRoot root = new TinyGameRoot(400.0, 300.0);
  TinyStage stage = builder.createStage(root);
  stage.start();
  root.addChild(new SnowTest(builder));
}
