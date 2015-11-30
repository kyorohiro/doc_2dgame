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
    });
    builder.loadString("assets/se_start.json").then((v) {
      info = new SpriteSheetInfo.fronmJson(v);
    });
  }
  bool isTouch = false;
  bool onTouch(TinyStage stage, int id, String type, double x, double y,
      double globalX, globalY) {
    if (isTouch == true && type == TinyStage.TYPE_POINTER_UP_EVENT) {
      isTouch = false;
      this.root.clearChild().then((_) {
        this.root.addChild(root.prepareScene);
      });
    } else if (type == TinyStage.TYPE_POINTER_DOWN_EVENT) {
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

      snows.onPaint(stage, canvas, this);
    }
  }
}
