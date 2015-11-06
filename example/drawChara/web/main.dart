import 'package:umiuni2d/tinygame.dart';
import 'package:umiuni2d/tinygame_webgl.dart';
import 'package:charatest/test.dart';

main() async {
  TinyGameBuilder builder = new TinyGameBuilderForWebgl();
  TinyGameRoot root = new TinyGameRoot(400.0,300.0);
  TinyStage stage = builder.createStage(root);
  stage.start();
  CharaUmi chara = await CharaUmi.createChara(builder);
  root.addChild(chara);
}
