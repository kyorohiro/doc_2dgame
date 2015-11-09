import 'package:umiuni2d/tinygame.dart';
import 'package:umiuni2d/tinygame_webgl.dart';
import 'package:play_sound/playsound_test.dart';
import 'dart:html';
import 'dart:web_audio';
import 'dart:async';

//
// http://kyorohiro.github.io/umiuni2d/sound_test/web/main.html
//
main() async {
  TinyGameBuilderForWebgl builder = new TinyGameBuilderForWebgl();
  print("--n--");
  TinyStage stage = builder.createStage(new TinyGameRoot(600.0, 400.0));
  stage.root.addChild(new Piano(builder));
  stage.start();
}
