library gamelogic;

import 'dart:async';
import 'dart:math' as math;
import 'package:umiuni2d/tinygame.dart';

class CharaUmi extends TinySprite {
  CharaUmi(TinyImage image, List<TinyRect> srcs, List<TinyRect> dsts,List<TinyCanvasTransform> transforms) 
  : super.simple(image,srcs:srcs,dsts:dsts,transforms:transforms) {
    ;
  }

  static Future<CharaUmi> createChara(TinyGameBuilder builder) async {
    TinyImage img = await builder.loadImage("assets/chara.png");
    return new CharaUmi(img,
        [new TinyRect(0.0,0.0,200.0,200.0),new TinyRect(200.0,0.0,200.0,200.0),new TinyRect(0.0,200.0,200.0,200.0)],
        [new TinyRect(0.0,0.0,200.0,200.0),new TinyRect(0.0,0.0,200.0,200.0),new TinyRect(0.0,0.0,200.0,200.0)],
        [TinyCanvasTransform.NONE,TinyCanvasTransform.NONE,TinyCanvasTransform.NONE]);
  }

  int prevTime = 0;
  int time = 0;
  void onTick(TinyStage stage, int timeStamp) {
    super.onTick(stage, timeStamp);
    if (prevTime != 0.0) {
      // 1 sec , half rotate
      rotation -= math.PI * ((timeStamp - prevTime) / 1000);
      x = 200.0;
      y = 150.0;
      centerX = 100.0;
      centerY = 100.0;
      scaleX = 0.8;
      scaleY = 0.8;
      
      time += timeStamp-prevTime;
      if(time > 100) {
        time = 0;
      currentFrameID++;
      if(currentFrameID >= numOfFrameID) {
        currentFrameID=0;
      }
      }
    }

    prevTime = timeStamp;
  }
}
