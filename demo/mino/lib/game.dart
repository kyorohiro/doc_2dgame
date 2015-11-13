library gamelogic;

import 'dart:async';
import 'dart:math' as math;
import 'package:umiuni2d/tinygame.dart';

part 'glogic/glogic.dart';
part 'glogic/minon.dart';
part 'glogic/board.dart';
part 'gui/board.dart';
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
    joystick = new TinyJoystick(size:70.0,minWidth:35.0);
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
      game.down();
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
        joyTime = 30-(10*(1/(1+math.exp(-5*(joystick.directionYAbs-1.0))))).toInt();
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
