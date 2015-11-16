part of gamelogic;

class PlayScene extends TinyDisplayObject {
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
  MinoGame game = new MinoGame();
  TinyJoystick joystick;
  TinyButton rotateR;
  TinyButton rotateL;

  MinoTableUI playboard;
  MinoNextUI nextUI;
  ScoreUI scoreUI;
  ScoreUI levelUI;
  SpriteSheetInfo spriteInfo = null;
  TinyImage image = null;
  PlayScene(this.builder, this.root,{int level:1}) {
    rotateR = new TinyButton("r", 40.0, 40.0, onTouchCallback);
    rotateL = new TinyButton("l", 40.0, 40.0, onTouchCallback);
    joystick = new TinyJoystick(size:70.0,minWidth:35.0);
    playboard = new MinoTableUI(builder, game.table);
    nextUI = new MinoNextUI(builder);
    scoreUI = new ScoreUI(this);
    levelUI = new ScoreUI(this);
    levelUI.size = 3;
    addChild(playboard);
    addChild(joystick);
    addChild(rotateR);
    addChild(rotateL);
    addChild(nextUI);
    addChild(scoreUI);
    addChild(levelUI);
    playboard.mat.translate(100.0, 25.0, 0.0);
    joystick.mat.translate(100.0, 250.0, 0.0);
    rotateR.mat.translate(250.0, 225.0, 0.0);
    rotateL.mat.translate(300.0, 225.0, 0.0);
    nextUI.mat.translate(225.0, 153.0, 0.0);
    scoreUI.mat.translate(225.0, 50.0, 0.0);
    levelUI.mat.translate(225.0, 85.0, 0.0);
    //
    //
    builder.loadImage("assets/se_play.png").then((TinyImage i) {
      image = i;
    });
    builder.loadString("assets/se_play.json").then((String x) {
      spriteInfo = new SpriteSheetInfo.fronmJson(x);
    });
    game.baseLevel = level;
    game.level = level;
    print("### game =  ${game.baseLevel}");
  }

  int time = 0;
  int turnTime = 0;
  int joyTime = 0;


  void onTick(TinyStage stage, int timeStamp) {
    scoreUI.score = game.score;
    levelUI.score = game.level;
    if (time > 10) {
      game.down();
      nextUI.setMinon(game.minon2);
      time = 0;
    }
    turnTime--;
    joyTime--;
    time++;
    if (joyTime <= 0) {
      if (joystick.directionX > 0.5) {
        joyTime = 10-(10*(1/(1+math.exp(-5*(joystick.directionXAbs-1.0))))).toInt();
        if(joyTime > 9) {
          joyTime = 9;
        }
        game.right();
      } else if (joystick.directionX < -0.5) {
        joyTime = 10-(10*(1/(1+math.exp(-5*(joystick.directionXAbs-1.0))))).toInt();
        if(joyTime > 9) {
          joyTime = 9;
        }
        game.left();
      }

      if (joystick.directionY < -0.5) {
        joyTime = 10-(10*(1/(1+math.exp(-5*(joystick.directionYAbs-1.0))))).toInt();
        if(joyTime > 9) {
          joyTime = 9;
        }
        game.down();
      }else if (joystick.directionY > 0.5) {
        joyTime = 30-(30*(1/(1+math.exp(-5*(joystick.directionYAbs-1.0))))).toInt();
        if(joyTime > 9) {
          joyTime = 9;
        }
        game.rotateR();
      }
    }

    if (rotateR.isTouch && turnTime <= 0) {
      turnTime = 10;
      game.rotateR();
    } else if (rotateL.isTouch && turnTime <= 0) {
      turnTime = 10;
      game.rotateL();
    }

    if(game.isGameOver) {
      //game.start();
      this.root.clearChild().then((_){
        this.root.addChild(new ClearScene(builder, root));       
      });
    }
  }

  onTouchCallback(String id) {}
}
