library gamelogic;

import 'dart:async';
import 'dart:math' as math;
import 'package:umiuni2d/tinygame.dart';

part 'glogic/glogic.dart';
part 'glogic/minon.dart';

class MinoRoot extends TinyDisplayObject {
  TinyGameBuilder builder;
  MinoGame game = new MinoGame();
  TinyJoystick joystick;
  TinyButton rotateR;
  TinyButton rotateL;
  MinoTableUI playboard;
  MinoRoot(this.builder) {
    rotateR = new TinyButton("r", 40.0, 40.0, onTouchCallback);
    rotateL = new TinyButton("l", 40.0, 40.0, onTouchCallback);
    joystick = new TinyJoystick();
    playboard = new MinoTableUI(builder, game.table);
    addChild(playboard);
    addChild(joystick);
    addChild(rotateR);
    addChild(rotateL);

    playboard.mat.translate(100.0, 25.0, 0.0);
    joystick.mat.translate(100.0, 250.0, 0.0);
    rotateR.mat.translate(250.0, 225.0, 0.0);
    rotateL.mat.translate(300.0, 225.0, 0.0);
  }

  int time = 0;
  int turnTime = 0;
  int joyTime = 0;
  void onTick(TinyStage stage, int timeStamp) {
    if (time > 10) {
      game.loop();
      time = 0;
    }
    turnTime--;
    joyTime--;
    time++;
    if (joyTime <= 0) {
      if (joystick.directionX > 0.3) {
        joyTime = 4~/joystick.directionXAbs;
        if(joyTime > 9) {
          joyTime = 9;
        }
        game.right();
      } else if (joystick.directionX < -0.3) {
        joyTime = 4~/joystick.directionXAbs;
        if(joyTime > 9) {
          joyTime = 9;
        }
        game.left();
      } else if (joystick.directionY < -0.5) {
        joyTime = 2~/joystick.directionXAbs;
        if(joyTime > 9) {
          joyTime = 9;
        }
        game.down();
      }else if (joystick.directionY > 0.5) {
        joyTime = 2~/joystick.directionXAbs;
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
    print(
        "## ${(joystick.directionX*10).toInt()}:${(joystick.directionY*10).toInt()}");
  }

  onTouchCallback(String id) {}
}

class MinoTableUI extends TinyDisplayObject {
  TinyGameBuilder builder;
  MinoTable table;
  TinyColor colorEmpty = new TinyColor.argb(0xaa, 0x88, 0x88, 0x88);
  TinyColor colorFrame = new TinyColor.argb(0xaa, 0x55, 0x33, 0x33);
  TinyColor colorMinon = new TinyColor.argb(0xaa, 0xaa, 0xff, 0xaa);
  TinyColor colorO = new TinyColor.argb(0xaa, 0xaa, 0xff, 0xaa);
  TinyColor colorS = new TinyColor.argb(0xaa, 0xff, 0xaa, 0xaa);
  TinyColor colorZ = new TinyColor.argb(0xaa, 0xaa, 0xaa, 0xff);
  TinyColor colorJ = new TinyColor.argb(0xaa, 0xaa, 0xff, 0xff);
  TinyColor colorL = new TinyColor.argb(0xaa, 0xff, 0xff, 0xaa);
  TinyColor colorT = new TinyColor.argb(0xaa, 0xff, 0xff, 0xff);
  MinoTableUI(this.builder, this.table) {
    ;
  }

  void onPaint(TinyStage stage, TinyCanvas canvas) {
    TinyRect rect = new TinyRect(0.0, 0.0, 7.0, 7.0);
    TinyPaint p = new TinyPaint();
    p.style = TinyPaintStyle.stroke;
    p.strokeWidth = 1.0;

    for (int y = 0; y < table.fieldHWithFrame; y++) {
      for (int x = 0; x < table.fieldWWithFrame; x++) {
        rect.x = x * 8.0;
        rect.y = y * 8.0;
        Mino m = table.getMino(x, y);
        if (m.type == MinoTyoe.frame) {
          p.color = colorFrame;
        } else if (m.type == MinoTyoe.empty) {
          p.color = colorEmpty;
        } else if (m.type == MinoTyoe.l) {
          p.color = colorMinon;
        } else if (m.type == MinoTyoe.o) {
          p.color = colorO;
        } else if (m.type == MinoTyoe.t) {
          p.color = colorT;
        } else if (m.type == MinoTyoe.s) {
          p.color = colorS;
        } else if (m.type == MinoTyoe.z) {
          p.color = colorZ;
        } else if (m.type == MinoTyoe.j) {
          p.color = colorJ;
        } else if (m.type == MinoTyoe.L) {
          p.color = colorL;
        } else {
          p.color = colorL;
        }
        canvas.drawRect(stage, rect, p);
      }
    }
  }
}
