part of gamelogic;

class PlayScene extends TinyDisplayObject {
  static final TinyColor bgColor = new TinyColor.argb(0xff, 0xee, 0xee, 0xff);
  static final TinyColor colorEmpty = new TinyColor.argb(0xaa, 0x88, 0x88, 0x88);
  static final TinyColor colorFrame = new TinyColor.argb(0xaa, 0x55, 0x33, 0x33);
  static final TinyColor colorMinon = new TinyColor.argb(0xaa, 0xff, 0xff, 0xff);

  static final TinyColor colorO = new TinyColor.argb(0xaa, 0x00, 0x00, 0x00);
  static final TinyColor colorS = new TinyColor.argb(0xaa, 0xff, 0xaa, 0xaa);
  static final TinyColor colorZ = new TinyColor.argb(0xaa, 0xaa, 0xff, 0xaa);
  static final TinyColor colorJ = new TinyColor.argb(0xaa, 0xaa, 0xaa, 0xff);
  static final TinyColor colorL = new TinyColor.argb(0xaa, 0xff, 0xff, 0xaa);
  static final TinyColor colorT = new TinyColor.argb(0xaa, 0xaa, 0xff, 0xff);

  TinyGameBuilder builder;
  MinoRoot root;
  MinoGame game;
  TinyJoystick joystick;
  TinyButton rotateR;
  TinyButton rotateL;

  MinoTableUI playboard;
  MinoNextUI nextUI;
  ScoreUI scoreUI;
  ScoreUI levelUI;
  SpriteSheetInfo spriteInfo = null;
  TinyImage image = null;
  
  Snows snows = new Snows();
  PlayScene(this.builder, this.root, this.game,{int level: 1}) {
    rotateR = new TinyButton("r", 50.0, 50.0, onTouchCallback);
    rotateL = new TinyButton("l", 50.0, 50.0, onTouchCallback);
    rotateR.bgcolorOff = new TinyColor.argb(0x00, 0xff, 0xff, 0xff);
    rotateL.bgcolorOff = new TinyColor.argb(0x00, 0xff, 0xff, 0xff);
    joystick = new TinyJoystick(size: 70.0, minWidth: 35.0);
    playboard = new MinoTableUI(builder, game.table);
    nextUI = new MinoNextUI(builder);
    scoreUI = new ScoreUI(this.spriteInfo, this.image);
    levelUI = new ScoreUI(this.spriteInfo, this.image);
    levelUI.size = 3;
    {    //
      //
      addChild(snows);
      snows.addIdName("S001.png", 0.25, randomSize: true);
      snows.addIdName("S002.png", 0.25, randomSize: true);
      snows.addIdName("S001.png", 0.25, randomSize: true);
      snows.addIdName("S002.png", 0.25, randomSize: true);
      snows.addIdName("S001.png", 0.25, randomSize: true);
      snows.addIdName("S002.png", 0.25, randomSize: true);

    }
    addChild(playboard);
    addChild(joystick);
    addChild(rotateR);
    addChild(rotateL);
    addChild(nextUI);
    addChild(scoreUI);
    addChild(levelUI);
    playboard.mat.translate(100.0, 25.0, 0.0);
    joystick.mat.translate(100.0, 250.0, 0.0);
    rotateL.mat.translate(230.0, 225.0, 0.0);
    rotateR.mat.translate(300.0, 225.0, 0.0);
    nextUI.mat.translate(225.0, 153.0, 0.0);
    scoreUI.mat.translate(225.0, 50.0, 0.0);
    levelUI.mat.translate(225.0, 85.0, 0.0);
    //
    //
    builder.loadImage("assets/se_play.png").then((TinyImage i) {
      image = i;
      scoreUI.image = i;
      levelUI.image = i;
      snows.bgimg = i;
    });
    builder.loadStringBase("assets/se_play.json").then((String x) {
      spriteInfo = new SpriteSheetInfo.fronmJson(x);
      scoreUI.spriteInfo = spriteInfo;
      levelUI.spriteInfo = spriteInfo;
      snows.info = spriteInfo;
    });
    game.baseLevel = level;
    game.level = level;
    print("### game =  ${game.baseLevel}");

  }

  TinyPaint p = new TinyPaint();
  TinyRect d1 = new TinyRect(0.0, 0.0, 50.0, 50.0);
  TinyRect d2 = new TinyRect(0.0, 0.0, 50.0, 50.0);
  void onPaint(TinyStage stage, TinyCanvas canvas) {
    //snows.onPaint(stage, canvas);
    if(image != null && spriteInfo != null) {
    d1.x = 230.0;
    d1.y = 225.0;  
    canvas.drawImageRect(stage, image, spriteInfo.frameFromFileName("BT01.png").srcRect, d1, p);
    d2.x = 300.0;
    d2.y = 225.0;  
    canvas.drawImageRect(stage, image, spriteInfo.frameFromFileName("BT02.png").srcRect, d2, p);
    }
  }
  void onTick(TinyStage stage, int timeStamp) {
    scoreUI.score = game.score;
    levelUI.score = game.level+1;
    if(game.nexts.length > 1 && game.nexts[1] != null) {
      nextUI.setMinon(game.nexts[1]);
    }

    game.onTouchStart(timeStamp);
    if (joystick.directionX > 0.5 ||
      (joystick.registerDown == true &&joystick.registerUp == true && joystick.directionX_released > 0.5)) {
      joystick.registerDown = false;
      if(joystick.registerDown == true &&joystick.registerUp == true && joystick.directionX_released > 0.5) {
        print("------------hotX up");
      }
      game.rightWithLevel(timeStamp, force:joystick.registerUp);
    } else if (joystick.directionX < -0.5 ||
    (joystick.registerDown == true &&joystick.registerUp == true && joystick.directionX_released < -0.5)) {
      joystick.registerDown = false;
      if(joystick.registerUp == true && joystick.directionX_released < -0.5) {
        print("------------hotX up");
      }
      game.leftWithLevel(timeStamp,force:joystick.registerUp);
    }

    if (joystick.directionY < -0.6) {
      game.downWithLevel(timeStamp, force: joystick.registerUp);
    } else if (joystick.directionY > 0.7) {
      game.downPlusWithLevel(timeStamp, force: joystick.registerUp);
    }

    if (rotateR.isTouch || (rotateR.registerDown == true &&rotateR.registerUp == true)) {
      rotateR.registerDown = false;
      game.rotateRWithLevel(timeStamp,force: rotateR.registerUp);
    }
    if (rotateL.isTouch|| (rotateL.registerDown == true &&rotateL.registerUp == true)) {
      rotateL.registerDown = false;
      game.rotateLWithLevel(timeStamp,force: rotateL.registerUp);
    }

    if (game.isGameOver) {
      //game.start();
      this.root.clearChild().then((_) async {
        this.root.addChild(root.clearScene.initFromScore(game.score));
        try {
          print("--a");
        await this.root.database.setRank(root.game.ranking);
        print("--b");
        await this.root.database.save();
        } catch(e) {
          print("## failed to save score ${e}");
        }
      });
    }
    game.onTouchEnd(timeStamp);
    joystick.registerUp = false;
    rotateL.registerUp = false;
    rotateR.registerUp = false;
  }

  onTouchCallback(String id) {}
}
