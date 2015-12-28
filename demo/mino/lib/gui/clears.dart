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
  String jsonText;
  SpriteSheet fontInfo;
  TinyPaint p = new TinyPaint();
  int type = 0;
  String locale = "ja";

  String get currentMessage {
    if (locale.contains("ja")) {
      return message_ja[type];
    } else {
      return message_en[type];
    }
  }

  List<int> event = [
//    10,20,30,40
    0, 5000, 16000, 32000, 50000, 100000
  ];
  List<String> path = ["assets/bg_clear01.png", "assets/bg_clear02.png", "assets/bg_clear05.png", "assets/bg_clear06.png", "assets/bg_clear03.png", "assets/bg_clear04.png"];
  List<String> message_ja = ["そして、ミノーンの雪が降った。", "ミノーンが仲間になった。", "炎の妖精がこちらを見ている。", "魔法少女とお友達になった。", "闇が辺りを照らした。", "ミーティアを詠唱した。"];
  List<String> message_en = ["then, Minon snowflake fell", "Minon has become a friend", "Fairy of flame have seen here .", "Magical Girl and I became friends .", "Darkness shone around .", "Chanting the Meteor."];
  int typeFromScore(int score) {
    int type = 0;
    for (int i = 0; i < event.length; i++) {
      if (score >= event[i]) {
        type = i;
      }
    }
    return type;
  }

  ClearScene(this.builder, this.root, int score) {
    initFromScore(score);
    builder.getLocale().then((String v) {
      locale = v;
    });
  }

  initFromScore(int score) {
    fontimg = null;
    bgimg = null;
    type = typeFromScore(score);

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
      update();
    });
    builder.loadString("assets/font_a.json").then((String v) {
      jsonText = v;
      update();
    });
    return this;
  }

  update() {
    if(jsonText != null && fontimg != null) {
      fontInfo = new SpriteSheet.bitmapfont(jsonText, fontimg.w, fontimg.h);
    }
  }
  bool isTouch = false;
  bool onTouch(TinyStage stage, int id, TinyStagePointerType type, double x, double y, double globalX, globalY) {
    if (isTouch == true && type == TinyStagePointerType.UP) {
      isTouch = false;
      this.root.clearChild().then((_) {
        this.root.addChild(root.prepareScene);
      });
    } else if (type == TinyStagePointerType.DOWN) {
      isTouch = true;
    }
    return false;
  }

  void onPaint(TinyStage stage, TinyCanvas canvas) {
    if (bgimg != null) {
      canvas.drawImageRect(stage, bgimg, srcRect, dstRect, p);
    }
    if (fontimg != null && fontInfo != null) {
      fontInfo.drawText(stage, canvas, fontimg, currentMessage, 20.0, rect: new TinyRect(40.0, 230.0, 350.0, 200.0));
    }
  }
}
