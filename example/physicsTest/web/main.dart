import 'package:umiuni2d/tinygame.dart';
import 'package:umiuni2d/tinygame_webgl.dart';
import 'package:physicstest/test.dart';

main() async {
  TinyGameBuilder builder = new TinyGameBuilderForWebgl();
  TinyGameRoot root = new TinyGameRoot(450.0,450.0,bkcolor:new TinyColor.argb(0xaa, 0x00, 0x00, 0x00));
  TinyStage stage = builder.createStage(root);
  (stage as TinyWebglStage).isTMode = true;
  stage.start();
  root.addChild(new PhysicsTest(builder));
}
