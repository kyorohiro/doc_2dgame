part of gamelogic;

class StartScene extends TinyDisplayObject {
  TinyImage bgimg;
  SpriteSheetInfo info;
  MinoRoot root;
  TinyGameBuilder builder;
  TinyPaint p = new TinyPaint();
  Snows snows = new Snows();
  TinyButton sound = null;
  StartScene(this.builder, this.root) {
    builder.loadImage("assets/se_start.png").then((v) {
      bgimg = v;
      snows.bgimg = bgimg;
    });
    builder.loadString("assets/se_start.json").then((v) {
      info = new SpriteSheetInfo.fronmJson(v);
      snows.info = info;
    });
    {
      for (int i = 1; i <= 7; i++) {
        snows.addIdName("B00${i}.png", 0.35);
      }
    }
    sound = new TinyButton("a", 100.0, 100.0, (String id) {
      if(this.root.isStartBGM) {
        this.root.stopBGM();
      } else {
        this.root.startBGM();
      }
    });
    sound.mat.translate(250.0,50.0,0.0);
    sound.bgcolorOff = new TinyColor.argb(0x00, 0x00, 0x00, 0x00);
    addChild(sound);
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
 TinyRect t = new TinyRect(0.0, 0.0, 100.0, 100.0);
  void onPaint(TinyStage stage, TinyCanvas canvas) {
    if (bgimg != null && info != null) {
      canvas.drawImageRect(stage, bgimg, info.frameFromFileName("BG001.png").srcRect, info.frameFromFileName("BG001.png").dstRect, p);
      snows.onPaint(stage, canvas);

      sound.bgImg = bgimg;
      sound.bgImgDstRect = t;
      if(this.root.isStartBGM) {
        sound.bgImgSrcRect = info.frameFromFileName("VON.png").srcRect;
      } else {
        sound.bgImgSrcRect = info.frameFromFileName("VOFF.png").srcRect;
      }
    }
  }
}
