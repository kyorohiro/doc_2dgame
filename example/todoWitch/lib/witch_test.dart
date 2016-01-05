library gamelogic;

import 'dart:async';
import 'dart:math' as math;
import 'package:umiuni2d/tinygame.dart';

class CharaGameRoot extends TinyGameRoot {
  TinyGameBuilder builder;
  TinySprite chara;
  TinyStage _stage = null;
  CharaGameRoot(this.builder) : super(400.0, 300.0) {
  }

  void onInit(TinyStage stage) {
    _stage = stage;
    gameLoop();
  }

  void onUnattach() {
    _stage = null;
  }

  gameLoop() async {
    TinySprite chara = await createChara(builder);
    addChild(chara);
    chara.x = 200.0;
    chara.y = 150.0;
    chara.centerX = 100.0;
    chara.centerY = 100.0;
    chara.scaleX = 0.8;
    chara.scaleY = 0.8;

    int prevTime = 0;
    while (_stage != null) {
      int timeStamp = new DateTime.now().millisecondsSinceEpoch;
      chara.rotation -= math.PI * ((timeStamp - prevTime) / 1000);
      prevTime = timeStamp;
      chara.currentFrameID++;
      if (chara.currentFrameID >= chara.numOfFrameID) {
        chara.currentFrameID = 0;
      }
      _stage.markNeedsPaint();
      await new Future.delayed(new Duration(milliseconds: 50));
    }
  }

  Future<TinySprite> createChara(TinyGameBuilder builder) async {
    TinyImage img = await builder.loadImage("assets/chara.png");
    return new TinySprite.simple(img, srcs: [
      new TinyRect(0.0, 0.0, 200.0, 200.0),
      new TinyRect(200.0, 0.0, 200.0, 200.0),
      new TinyRect(0.0, 200.0, 200.0, 200.0)
    ], dsts: [
      new TinyRect(0.0, 0.0, 200.0, 200.0),
      new TinyRect(0.0, 0.0, 200.0, 200.0),
      new TinyRect(0.0, 0.0, 200.0, 200.0)
    ], transforms: [
      TinyCanvasTransform.NONE,
      TinyCanvasTransform.NONE,
      TinyCanvasTransform.NONE
    ]);
  }
}
