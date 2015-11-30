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
  ScoreUI no1;
  ScoreUI no2;
  ScoreUI no3;

  PrepareScene(this.builder, this.root) {
    builder.loadImage("assets/se_setting.gif").then((v){
      bgimg = v;
      srcRect = new TinyRect(0.0, 0.0, bgimg.w.toDouble(), bgimg.h.toDouble());
      dstRect = new TinyRect(0.0, 0.0, 400.0, 300.0);
      no1.image = v;
      no2.image = v;
      no3.image = v;
    });
 
    builder.loadStringBase("assets/se_setting.json").then((String x) {
      spriteInfo = new SpriteSheetInfo.fronmJson(x);
      no1.spriteInfo = spriteInfo;
      no2.spriteInfo = spriteInfo;
      no3.spriteInfo = spriteInfo;
    });

    TinyButton level1 = new TinyButton("L01", 45.0, 45.0, onLevelButton);
    level1.bgcolorOff = new TinyColor.argb(0x00, 0xff, 0xff, 0xff);
    level1.mat.translate(50+20.0,50.0,0.0);
    
    TinyButton level2 = new TinyButton("L02", 45.0, 45.0, onLevelButton);
    level2.bgcolorOff = new TinyColor.argb(0x00, 0xff, 0xff, 0xff);
    level2.mat.translate(50+70.0,50.0,0.0);

    TinyButton level3 = new TinyButton("L03", 45.0, 45.0, onLevelButton);
    level3.bgcolorOff = new TinyColor.argb(0x00, 0xff, 0xff, 0xff);
    level3.mat.translate(50+125.0,50.0,0.0);

    TinyButton level4 = new TinyButton("L04", 45.0, 45.0, onLevelButton);
    level4.bgcolorOff = new TinyColor.argb(0x00, 0xff, 0xff, 0xff);
    level4.mat.translate(50+165.0,50.0,0.0);

    TinyButton level5 = new TinyButton("L05", 45.0, 45.0, onLevelButton);
    level5.bgcolorOff = new TinyColor.argb(0x00, 0xff, 0xff, 0xff);
    level5.mat.translate(50+215.0,50.0,0.0);

    TinyButton back = new TinyButton("BACK", 45.0, 45.0, onLevelButton);
    back.bgcolorOff = new TinyColor.argb(0x00, 0xff, 0xff, 0xff);
    back.mat.translate(50+215+50.0,50.0,0.0);
    addChild(level1);
    addChild(level2);
    addChild(level3);
    addChild(level4);
    addChild(level5);
    addChild(back);
    no1 = new ScoreUI(null, null);
    no1.mat.translate(90.0,220.0,0.0);
    no2 = new ScoreUI(null, null);
    no2.mat.translate(90.0,247.0,0.0);
    no3 = new ScoreUI(null, null);
    no3.mat.translate(90.0,278.0,0.0);
    addChild(no1);
    addChild(no2);
    addChild(no3);

    level = 1;
    onLevelButton("L01");
    TinyButton startB = new TinyButton("start", 170.0, 50.0, onStartButton);
    startB.mat.translate(230.0,250.0,0.0);
    startB.bgcolorOff = new TinyColor.argb(0x00, 0xff, 0xff, 0xff);
    addChild(startB);
  }
  
  double chX = 0.0;
  double chY = 0.0;
  onLevelButton(String id){
    print("touch # ${id}");
    switch(id) {
      case "L01":
        chX = 70.0;
        chY = 60.0;
        level = 0;
        break;
      case "L02":
        chX = 125.0;
        chY = 60.0;
        level = 1;
        break;
      case "L03":
        chX = 175.0;
        chY = 60.0;
        level = 2;
        break;
      case "L04":
        chX = 215.0;
        chY = 60.0;
        level = 3;
        break;
      case "L05":
        chX = 265.0;
        chY = 60.0;
        level = 4;
        break;
      case "BACK":
        this.root.clearChild().then((_){
          root.game.start();
          this.root.addChild(root.startScene);        
        });
        break;
    }
  }

  onStartButton(String id){
    print("touch # ${id}");
    this.root.clearChild().then((_){
      print("### level =  ${level}");
      root.game.start();
      this.root.addChild(root.playScene.initFromLevel(level));//new PlayScene(builder,root, root.game, level:level));        
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
      no1.score = root.game.no1Score;
      no2.score = root.game.no2Score;
      no3.score = root.game.no3Score;
  }
}