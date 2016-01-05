import 'package:umiuni2d/tinygame.dart';
import 'package:umiuni2d/tinygame_webgl.dart';
import 'package:witch_test/witch_test.dart';

main() async {
  TinyGameBuilder builder = new TinyGameBuilderForWebgl();
  TinyStage stage = builder.createStage(new CharaGameRoot(builder));
  (stage as TinyWebglStage).isTMode = true;
  stage.start();
}
