import 'package:umiuni2d/tinygame.dart';
import 'package:umiuni2d/tinygame_webgl.dart';
import 'package:draw_primitive/primitive_test.dart';

void main() {
  TinyGameBuilderForWebgl builder = new TinyGameBuilderForWebgl();
  TinyGameRoot root = new TinyGameRoot(400.0,300.0);
  TinyStage stage = builder.createStage(root);
  (stage as TinyWebglStage).isTMode = true;
  stage.start();
  PrimitiveTest test = new PrimitiveTest(builder);
  root.addChild(test);
}
