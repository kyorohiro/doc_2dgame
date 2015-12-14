part of gamelogic;

class StartScene extends TinyDisplayObject {
  TinyImage bgimg;
  SpriteSheetInfo info;
  MinoRoot root;
  TinyGameBuilder builder;
  TinyPaint p = new TinyPaint();
  Snows snows = new Snows();
  StartScene(this.builder, this.root) {
    builder.loadImage("assets/se_start.gif").then((v) {
      bgimg = v;
      snows.bgimg = bgimg;
    });
    builder.loadString("assets/se_start.json").then((v) {
      info = new SpriteSheetInfo.fronmJson(v);
      snows.info = info;
    });
    {
    for(int i=1;i<=7;i++) {
      snows.addIdName("B00${i}.png", 0.35);
    }
    }
  }
  bool isTouch = false;
  bool onTouch(TinyStage stage, int id, TinyStagePointerType type, double x, double y,
      double globalX, globalY) {
    if (isTouch == true && type == TinyStagePointerType.TYPE_POINTER_UP_EVENT) {
      isTouch = false;
      this.root.clearChild().then((_) {
        this.root.addChild(root.prepareScene);
      });
    } else if (type == TinyStagePointerType.TYPE_POINTER_DOWN_EVENT) {
      isTouch = true;
    }
    return false;
  }

  void onPaint(TinyStage stage, TinyCanvas canvas) {
    if (bgimg != null && info != null) {
      canvas.drawImageRect(
          stage,
          bgimg,
          info.frameFromFileName("BG001.png").srcRect,
          info.frameFromFileName("BG001.png").dstRect,
          p);

      snows.onPaint(stage, canvas);
    }
  }
}
