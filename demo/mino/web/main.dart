import 'package:umiuni2d/tinygame.dart';
import 'package:umiuni2d/tinygame_webgl.dart';
import 'package:mino/game.dart';

main() async {
  TinyGameBuilder builder = new TinyGameBuilderForWebgl();
  TinyStage stage = builder.createStage(new MinoRoot(builder));
  stage.start();
}
