library gamelogic;

import 'dart:async';
import 'dart:math' as math;
import 'package:umiuni2d/tinygame.dart';

class MinoRoot extends TinyDisplayObject {
  TinyGameBuilder builder;
  MinoGame game = new MinoGame();
  TinyJoystick joystick;
  TinyButton rotateR;

  MinoRoot(this.builder) {
    rotateR = new TinyButton("r", 50.0, 50.0, onTouchCallback);
    joystick = new TinyJoystick();
    addChild(new MinoTableUI(builder, game.table));
    addChild(joystick);
    addChild(rotateR);

    joystick.mat.translate(100.0,250.0,0.0);
    rotateR.mat.translate(250.0,225.0,0.0);
  }

  int time = 0;
  void onTick(TinyStage stage, int timeStamp) {
    if(time > 10) {
      game.loop();
      time=0;
    }
    time++;
  }
  
  onTouchCallback(String id) {
    
  }
}

class MinoGame {
  MinoTable table = new MinoTable();
  Minon minon = new Minon.l();

  MinoGame() {
    nextMinon();
  }

  loop() {
    setMinon(minon, true);
    down();
  }

  nextMinon() {
    minon = new Minon.l();
    minon.x = table.fieldWWithFrame ~/ 2;
  }


  down() {
    setMinon(minon, false);
    minon.y++;
    if(collision(minon)) {
      minon.y--;
      setMinon(minon, true);
      nextMinon();
      setMinon(minon, true);
    } else {
      setMinon(minon, true);
    }
  }

  left() {
    setMinon(minon, false);
    minon.x--;
    if(collision(minon)) {
      minon.x++;
      setMinon(minon, true);
      nextMinon();
      setMinon(minon, true);
    } else {
      setMinon(minon, true);
    }
  }

  right() {
    setMinon(minon, false);
    minon.x++;
    if(collision(minon)) {
      minon.x--;
      setMinon(minon, true);
      nextMinon();
      setMinon(minon, true);
    } else {
      setMinon(minon, true);
    }
  }

  bool collision(Minon minon) {
    for (MinonElm e in minon.minos) {
      Mino m = table.getMino(minon.x + e.x, minon.y + e.y);
      if(!(m.type == MinoTyoe.empty || m.type == MinoTyoe.out)) {
        return true;
      }
    }
    return false;
  }

  setMinon(Minon minon, bool on) {
    for (MinonElm e in minon.minos) {
      Mino m = table.getMino(minon.x + e.x, minon.y + e.y);
      if (m.type != MinoTyoe.out) {
        if (on == true) {
          m.type = e.type;
        } else {
          m.type = MinoTyoe.empty;
        }
      }
    }
  }
}

class MinoTableUI extends TinyDisplayObject {
  TinyGameBuilder builder;
  MinoTable table;
  TinyColor colorEmpty = new TinyColor.argb(0xaa, 0xff, 0xaa, 0xaa);
  TinyColor colorFrame = new TinyColor.argb(0xaa, 0x55, 0x33, 0x33);
  TinyColor colorL = new TinyColor.argb(0xaa, 0xaa, 0xff, 0xaa);

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
        if (table.getMino(x, y).type == MinoTyoe.frame) {
          p.color = colorFrame;
        } else if (table.getMino(x, y).type == MinoTyoe.empty) {
          p.color = colorEmpty;
        } else if (table.getMino(x, y).type == MinoTyoe.l) {
          p.color = colorL;
        }
        canvas.drawRect(stage, rect, p);
      }
    }
  }
}

class MinoTable {
  List<Mino> minos = [];
  final int fieldW;
  final int fieldH;

  int get fieldWWithFrame => fieldW + 2;
  int get fieldHWithFrame => fieldH + 1;

  Mino outMino = new Mino(MinoTyoe.out);
  MinoTable({this.fieldW: 11, this.fieldH: 21}) {
    for (int y = 0; y < fieldHWithFrame; y++) {
      for (int x = 0; x < fieldWWithFrame; x++) {
        if (x == 0 || x == fieldWWithFrame - 1 || y == fieldH) {
          minos.add(new Mino(MinoTyoe.frame));
        } else {
          minos.add(new Mino(MinoTyoe.empty));
        }
      }
    }
  }

  Mino getMino(int x, int y) {
    if (x < 0 || x >= fieldHWithFrame || y < 0 || y >= fieldHWithFrame) {
      return outMino;
    }
    return minos[x + y * fieldWWithFrame];
  }
}

enum MinoTyoe { empty, frame, out, l, o, s, z, j, t }

class Minon {
  int x = 0;
  int y = 0;
  List<MinonElm> minos = [];
  Minon.l() {
    minos.add(new MinonElm(MinoTyoe.l, 0, 0));
    minos.add(new MinonElm(MinoTyoe.l, -1, 0));
    minos.add(new MinonElm(MinoTyoe.l, 1, 0));
    minos.add(new MinonElm(MinoTyoe.l, 2, 0));
  }
}

class MinonElm extends Mino {
  int x;
  int y;
  MinonElm(MinoTyoe type, this.x, this.y) : super(type) {
    ;
  }
}

class Mino {
  MinoTyoe type;
  Mino(this.type) {}
}
