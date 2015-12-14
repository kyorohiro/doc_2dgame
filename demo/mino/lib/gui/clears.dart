part of gamelogic;

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
  String currentMessage  = "";

  List<int> event = [
//    10,20,30,40
    0,5000, 16000, 32000,50000, 100000
  ];
  List<String> path = [
    "assets/bg_clear01.png",
    "assets/bg_clear02.png",
    "assets/bg_clear05.png",
    "assets/bg_clear06.png",
    "assets/bg_clear03.png",
   "assets/bg_clear04.png"];
  List<String> message = [
     "そして、ミノーンの雪が降った。",
     "ミノーンが仲間になった。",
     "炎の妖精がこちらを見ている。",
     "魔法少女とお友達になった。",
     "闇が辺りを照らした。",
     "ミーティアを詠唱した。"
    ];

  int typeFromScore(int score) {
    int type = 0;
    for(int i=0;i<event.length;i++) {
      if(score >= event[i]) {
        type = i;
      }
    }
    return type;
  }

  ClearScene(this.builder, this.root, int score) {
    initFromScore(score);
  }

  initFromScore(int score) {
    fontimg = null;
    bgimg = null;
    int type = typeFromScore(score);
    currentMessage = message[type];
    String imgFileName = path[type];
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
    return this;
  }

  bool isTouch = false;
  bool onTouch(TinyStage stage, int id, TinyStagePointerType type, double x, double y,
      double globalX, globalY) {
    if(isTouch == true && type == TinyStagePointerType.UP) {
      isTouch = false;
    this.root.clearChild().then((_) {
      this.root.addChild(root.prepareScene);
    });
    }
    else if(type == TinyStagePointerType.DOWN) {
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
          20.0, new TinyRect(40.0, 230.0, 350.0, 200.0));
    }
  }
}
