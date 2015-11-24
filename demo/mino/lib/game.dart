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
part 'gui/start.dart';

class MinoRoot extends TinyDisplayObject {
  TinyGameBuilder builder;
  MinoGame game = new MinoGame();
  MinoRoot(this.builder) {
    addChild(new ResourceLoader(builder, this));
  }
}

class ResourceLoader extends TinyDisplayObject {
  MinoRoot root;
  TinyGameBuilder builder;
  ResourceLoader(this.builder, this.root) {
    load();
  }

  load() async {
    try {
      await builder.loadImage("assets/bg_clear01.png");
    } catch (e) {}
    try {
      await builder.loadImage("assets/bg_clear02.png");
    } catch (e) {}
    ;
    try {
      await builder.loadImage("assets/se_start.gif");
      await builder.loadString("assets/se_start.json");
    } catch (e) {}
    ;
    try {
      await builder.loadString("assets/se_play.json");
      await builder.loadImage("assets/se_play.png");
    } catch (e) {}
    ;

    try {
      await builder.loadImage("assets/se_setting.gif");
      await builder.loadString("assets/se_setting.json");
    } catch (e) {}
    ;
    try {
      await builder.loadImage("assets/font_a.png");
      await builder.loadString("assets/font_a.json");
    } catch (e) {}
    ;

    await this.root.clearChild();
    await this.root.addChild(new StartScene(builder, root));
  }

  int count = 0;
  void onPaint(TinyStage stage, TinyCanvas canvas) {
    count++;
    double size = 100.0 + ((count / 2) % 10) * 5;
    canvas.drawRect(
        stage,
        new TinyRect(-size / 2 + 200, -size / 2 + 150, size, size),
        new TinyPaint(color: new TinyColor.argb(0xaa, 0xff, 0xaa, 0xaa)));
  }
}

class ClearScene extends TinyDisplayObject {
  MinoRoot root;
  TinyGameBuilder builder;
  //
  TinyImage bgimg;
  TinyRect srcRect;
  TinyRect dstRect;
  //
  TinyImage fontimg;
  TinyRect fontSrcRect;
  TinyRect fontDstRect;
  BitmapFontInfo fontInfo;
  TinyPaint p = new TinyPaint();
  static final String messageOne = "ミノーンの雪が降った。";
  static final String messageTwo = "ミノーンが仲間になった。";
  String currentMessage  = "";

  ClearScene(this.builder, this.root, int score) {
    String imgFileName = "assets/bg_clear01.png";
    currentMessage = messageOne;
    if(score > 10000) {
      imgFileName = "assets/bg_clear02.png";
      currentMessage = messageTwo;
    }
    builder.loadImage(imgFileName).then((v) {
      bgimg = v;
      srcRect = new TinyRect(0.0, 0.0, bgimg.w.toDouble(), bgimg.h.toDouble());
      dstRect = new TinyRect(0.0, 0.0, 400.0, 300.0);
    });
    builder.loadImage("assets/font_a.png").then((v) {
      fontimg = v;
      fontSrcRect = new TinyRect(0.0, 0.0, 0.0, 0.0);
      fontDstRect = new TinyRect(0.0, 0.0, 0.0, 0.0);
    });
    builder.loadString("assets/font_a.json").then((String v) {
      fontInfo = new BitmapFontInfo.fromJson(v);
    });
  }

  bool isTouch = false;
  bool onTouch(TinyStage stage, int id, String type, double x, double y,
      double globalX, globalY) {
    if(isTouch == true && type == TinyStage.TYPE_POINTER_UP_EVENT) {   
      isTouch = false;
    this.root.clearChild().then((_) {
      this.root.addChild(new PrepareScene(builder, root));
    });
    }
    else if(type == TinyStage.TYPE_POINTER_DOWN_EVENT) {
      isTouch = true;
    }
    return false;
  }

  void onPaint(TinyStage stage, TinyCanvas canvas) {
    if (bgimg != null) {
      canvas.drawImageRect(stage, bgimg, srcRect, dstRect, p);
    }
    if(fontimg != null && fontInfo != null) {
      fontInfo.drawText(stage, canvas, 
          fontimg, currentMessage, 
          20.0, new TinyRect(80.0, 230.0, 400.0, 200.0));
    }
  }
}

