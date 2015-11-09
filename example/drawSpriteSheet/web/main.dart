import 'package:umiuni2d/tinygame.dart';
import 'package:umiuni2d/tinygame_webgl.dart';
//import 'package:vector_math/vector_math_64.dart';
import 'package:spritesheet/spritesheet_test.dart';

main() async {
  TinyGameBuilder builder = new TinyGameBuilderForWebgl();
  TinyGameRoot root = new TinyGameRoot(400.0, 300.0);
  TinyStage stage = builder.createStage(root);
  stage.start();
  root.addChild(new SpriteSheetTest(builder));
}
