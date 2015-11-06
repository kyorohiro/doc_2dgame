library gamelogic;

import 'dart:async';
import 'dart:math' as math;
import 'package:umiuni2d/tinygame.dart';

class CharaUmi extends TinySprite {
  CharaUmi(TinyImage image) : super.simple(image) {
    ;
  }

  static Future<CharaUmi> createChara(TinyGameBuilder builder) async {
    TinyImage img = await builder.loadImage("assets/chara.jpeg");
    return new CharaUmi(img);
  }

  int prevTime = 0;
  void onTick(TinyStage stage, int timeStamp) {
    super.onTick(stage, timeStamp);
    if (prevTime != 0.0) {
      // 1 sec , half rotate
      rotation -= math.PI * ((timeStamp - prevTime) / 1000);
      x = 200.0;
      y = 150.0;
      scaleX = 0.1;
      scaleY = 0.1;
    }
    prevTime = timeStamp;
  }
}
