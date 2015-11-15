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

class MinoRoot extends TinyDisplayObject {
  TinyGameBuilder builder;
  MinoRoot(this.builder) {
    addChild(new StartScene(builder, this));
//    addChild(new PlayScene(builder));
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
    builder.loadImage("assets/bg_startscene.png").then((v){
      bgimg = v;
      srcRect = new TinyRect(0.0, 0.0, bgimg.w.toDouble(), bgimg.h.toDouble());
      dstRect = new TinyRect(0.0, 0.0, 400.0, 300.0);
    });
  }
  bool a = false;
  bool onTouch(TinyStage stage, int id, String type, double x, double y, double globalX, globalY) {
    if(a == true) {
      return false;
    }    
    if(0.0<x && x<400.0 && 0.0<y && y<400.0) {
      print("--");
      this.root.clearChild().then((_){
        this.root.addChild(new PlayScene(builder));        
      });
      a = true;
    }
    return true;
  }
  void onPaint(TinyStage stage, TinyCanvas canvas) {
      if(bgimg != null) {
        canvas.drawImageRect(stage, bgimg, srcRect, dstRect, p);
      }
  }
}