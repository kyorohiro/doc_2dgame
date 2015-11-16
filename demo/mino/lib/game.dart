library gamelogic;

import 'dart:async';
import 'dart:math' as math;
import 'package:umiuni2d/tinygame.dart';

part 'glogic/glogic.dart';
part 'glogic/minon.dart';
part 'glogic/board.dart';
part 'gui/board.dart';
part 'gui/next.dart';
part 'gui/playscene.dart';
part 'gui/score.dart';
part 'gui/prepare.dart';

class MinoRoot extends TinyDisplayObject {
  TinyGameBuilder builder;
  MinoRoot(this.builder) {
    addChild(new StartScene(builder, this));
//    addChild(new PlayScene(builder));
  }
}


class ClearScene extends TinyDisplayObject {
  TinyImage bgimg;
  MinoRoot root;
  TinyGameBuilder builder;
  TinyRect srcRect;
  TinyRect dstRect;
  TinyPaint p = new TinyPaint();

  ClearScene(this.builder, this.root) {
    builder.loadImage("assets/bg_clear01.png").then((v){
      bgimg = v;
      srcRect = new TinyRect(0.0, 0.0, bgimg.w.toDouble(), bgimg.h.toDouble());
      dstRect = new TinyRect(0.0, 0.0, 400.0, 300.0);
    });
    TinyButton startB = new TinyButton("start", 200.0, 50.0, onStartButton);
    startB.mat.translate(100.0,200.0,0.0);
    addChild(startB);
  }
  onStartButton(String id){
    print("touch # ${id}");
    this.root.clearChild().then((_){
      this.root.addChild(new PrepareScene(builder, root));       
    });
  }
  bool a = false;
  bool onTouch(TinyStage stage, int id, String type, double x, double y, double globalX, globalY) {
    return false;
  }
  void onPaint(TinyStage stage, TinyCanvas canvas) {
      if(bgimg != null) {
        canvas.drawImageRect(stage, bgimg, srcRect, dstRect, p);
      }
  }
}

class StartScene extends TinyDisplayObject {
  TinyImage bgimg;
  MinoRoot root;
  TinyGameBuilder builder;
  TinyRect srcRect;
  TinyRect dstRect;
  TinyPaint p = new TinyPaint();

  StartScene(this.builder, this.root) {
    builder.loadImage("assets/bg_start.png").then((v){
      bgimg = v;
      srcRect = new TinyRect(0.0, 0.0, bgimg.w.toDouble(), bgimg.h.toDouble());
      dstRect = new TinyRect(0.0, 0.0, 400.0, 300.0);
    });
    TinyButton startB = new TinyButton("start", 200.0, 50.0, onStartButton);
    startB.mat.translate(100.0,200.0,0.0);
    addChild(startB);
  }
  onStartButton(String id){
    print("touch # ${id}");
    this.root.clearChild().then((_){
      this.root.addChild(new PrepareScene(builder, root));       
    });
  }
  bool a = false;
  bool onTouch(TinyStage stage, int id, String type, double x, double y, double globalX, globalY) {
    return false;
  }
  void onPaint(TinyStage stage, TinyCanvas canvas) {
      if(bgimg != null) {
        canvas.drawImageRect(stage, bgimg, srcRect, dstRect, p);
      }
  }
}