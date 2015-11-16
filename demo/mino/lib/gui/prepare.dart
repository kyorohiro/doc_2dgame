part of gamelogic;

class PrepareScene extends TinyDisplayObject {
  TinyImage bgimg;
  MinoRoot root;
  TinyGameBuilder builder;
  TinyRect srcRect;
  TinyRect dstRect;
  TinyPaint p = new TinyPaint();
  SpriteSheetInfo spriteInfo = null;
  int level = 1;


  PrepareScene(this.builder, this.root) {
    builder.loadImage("assets/se_setting.png").then((v){
      bgimg = v;
      srcRect = new TinyRect(0.0, 0.0, bgimg.w.toDouble(), bgimg.h.toDouble());
      dstRect = new TinyRect(0.0, 0.0, 400.0, 300.0);
    });
 
    builder.loadString("assets/se_setting.json").then((String x) {
      spriteInfo = new SpriteSheetInfo.fronmJson(x);
    });

    TinyButton level1 = new TinyButton("L01", 45.0, 45.0, onLevelButton);
    level1.bgcolorOff = new TinyColor.argb(0x00, 0xff, 0xff, 0xff);
    level1.mat.translate(70.0,60.0,0.0);

    TinyButton level2 = new TinyButton("L02", 45.0, 45.0, onLevelButton);
    level2.bgcolorOff = new TinyColor.argb(0x00, 0xff, 0xff, 0xff);
    level2.mat.translate(135.0,60.0,0.0);

    TinyButton level3 = new TinyButton("L03", 45.0, 45.0, onLevelButton);
    level3.bgcolorOff = new TinyColor.argb(0x00, 0xff, 0xff, 0xff);
    level3.mat.translate(185.0,60.0,0.0);

    TinyButton level4 = new TinyButton("L04", 45.0, 45.0, onLevelButton);
    level4.bgcolorOff = new TinyColor.argb(0x00, 0xff, 0xff, 0xff);
    level4.mat.translate(235.0,60.0,0.0);

    TinyButton level5 = new TinyButton("L05", 45.0, 45.0, onLevelButton);
    level5.bgcolorOff = new TinyColor.argb(0x00, 0xff, 0xff, 0xff);
    level5.mat.translate(285.0,60.0,0.0);
    
    TinyButton level6 = new TinyButton("L06", 45.0, 45.0, onLevelButton);
    level6.bgcolorOff = new TinyColor.argb(0x00, 0xff, 0xff, 0xff);
    level6.mat.translate(70.0,110.0,0.0);

    TinyButton level7 = new TinyButton("L07", 45.0, 45.0, onLevelButton);
    level7.bgcolorOff = new TinyColor.argb(0x00, 0xff, 0xff, 0xff);
    level7.mat.translate(135.0,110.0,0.0);

    TinyButton level8 = new TinyButton("L08", 45.0, 45.0, onLevelButton);
    level8.bgcolorOff = new TinyColor.argb(0x00, 0xff, 0xff, 0xff);
    level8.mat.translate(185.0,110.0,0.0);

    TinyButton level9 = new TinyButton("L09", 45.0, 45.0, onLevelButton);
    level9.bgcolorOff = new TinyColor.argb(0x00, 0xff, 0xff, 0xff);
    level9.mat.translate(245.0,110.0,0.0);

    TinyButton level10 = new TinyButton("L10", 45.0, 45.0, onLevelButton);
    level10.bgcolorOff = new TinyColor.argb(0x00, 0xff, 0xff, 0xff);
    level10.mat.translate(295.0,110.0,0.0);
    
    addChild(level1);
    addChild(level2);
    addChild(level3);
    addChild(level4);
    addChild(level5);

    addChild(level6);
    addChild(level7);
    addChild(level8);
    addChild(level9);
    addChild(level10);
    level = 1;
    onLevelButton("L01");
    TinyButton startB = new TinyButton("start", 200.0, 50.0, onStartButton);
    startB.mat.translate(100.0,200.0,0.0);
    addChild(startB);
  }
  
  double chX = 0.0;
  double chY = 0.0;
  onLevelButton(String id){
    print("touch # ${id}");
    switch(id) {
      case "L01":
        chX = 75.0;
        chY = 60.0;
        level = 1;
        break;
      case "L02":
        chX = 75.0+50.0*1;
        chY = 60.0;
        level = 2;
        break;
      case "L03":
        chX = 75.0+50.0*2;
        chY = 60.0;
        level = 3;
        break;
      case "L04":
        chX = 75.0+50.0*3;
        chY = 60.0;
        level = 4;
        break;
      case "L05":
        chX = 75.0+50.0*4;
        chY = 60.0;
        level = 5;
        break;
      case "L06":
        chX = 75.0+50.0*0;
        chY = 110.0;
        level = 6;
        break;
      case "L07":
        chX = 75.0+50.0*1;
        chY = 110.0;
        level = 7;
        break;
      case "L08":
        chX = 75.0+50.0*2;
        chY = 110.0;
        level = 8;
        break;
      case "L09":
        chX = 75.0+50.0*3;
        chY = 110.0;
        level = 9;
        break;
      case "L10":
        chX = 75.0+50.0*4;
        chY = 110.0;
        level = 10;
        break;
    }
  }

  onStartButton(String id){
    print("touch # ${id}");
    this.root.clearChild().then((_){
      print("### level =  ${level}");
      this.root.addChild(new PlayScene(builder,root,level:level));        
    });
  }

  bool onTouch(TinyStage stage, int id, String type, double x, double y, double globalX, globalY) {
    return false;
  }

  void onPaint(TinyStage stage, TinyCanvas canvas) {
      if(bgimg != null&& spriteInfo != null) {       
        canvas.drawImageRect(stage, bgimg, 
            spriteInfo.frameFromFileName("BG001.png").srcRect,
            //srcRect,
            dstRect, p);
        canvas.drawImageRect(stage, bgimg, 
            spriteInfo.frameFromFileName("CH001.png").srcRect,
            //srcRect,
            new TinyRect(chX, chY,50.0,50.0), p);
      }
  }
}