import 'package:umiuni2d/tinygame.dart';
import 'package:umiuni2d/tinygame_webgl.dart';
import 'package:mino/game.dart';

main() async {
  TinyGameBuilder builder = new TinyGameBuilderForWebgl();
  TinyGameRoot root = new TinyGameRoot(400.0,300.0);
  TinyStage stage = builder.createStage(root);
  (stage as TinyWebglStage).isTMode = true;
  stage.start();
  root.addChild(new MinoRoot(builder));
}