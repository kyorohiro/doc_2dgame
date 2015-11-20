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
    level1.mat.translate(50+70.0,50.0,0.0);

    TinyButton level2 = new TinyButton("L02", 45.0, 45.0, onLevelButton);
    level2.bgcolorOff = new TinyColor.argb(0x00, 0xff, 0xff, 0xff);
    level2.mat.translate(50+125.0,50.0,0.0);

    TinyButton level3 = new TinyButton("L03", 45.0, 45.0, onLevelButton);
    level3.bgcolorOff = new TinyColor.argb(0x00, 0xff, 0xff, 0xff);
    level3.mat.translate(50+165.0,50.0,0.0);

    TinyButton level4 = new TinyButton("L04", 45.0, 45.0, onLevelButton);
    level4.bgcolorOff = new TinyColor.argb(0x00, 0xff, 0xff, 0xff);
    level4.mat.translate(50+215.0,50.0,0.0);

    TinyButton level5 = new TinyButton("L05", 45.0, 45.0, onLevelButton);
    level5.bgcolorOff = new TinyColor.argb(0x00, 0xff, 0xff, 0xff);
    level5.mat.translate(50+265.0,50.0,0.0);
    

    
    addChild(level1);
    addChild(level2);
    addChild(level3);
    addChild(level4);
    addChild(level5);

    level = 1;
    onLevelButton("L01");
    TinyButton startB = new TinyButton("start", 150.0, 50.0, onStartButton);
    startB.mat.translate(240.0,250.0,0.0);
    addChild(startB);
  }
  
  double chX = 0.0;
  double chY = 0.0;
  onLevelButton(String id){
    print("touch # ${id}");
    switch(id) {
      case "L01":
        chX = 120.0;
        chY = 60.0;
        level = 0;
        break;
      case "L02":
        chX = 175.0;
        chY = 60.0;
        level = 1;
        break;
      case "L03":
        chX = 215.0;
        chY = 60.0;
        level = 2;
        break;
      case "L04":
        chX = 265.0;
        chY = 60.0;
        level = 3;
        break;
      case "L05":
        chX = 315.0;
        chY = 60.0;
        level = 4;
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
            new TinyRect(chX, chY,35.0,35.0), p);
      }
  }
}