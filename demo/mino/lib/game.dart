library gamelogic;

import 'dart:async';
import 'dart:math' as math;
import 'package:umiuni2d/tinygame.dart';

class MinoRoot extends TinyDisplayObject {
  TinyGameBuilder builder;
  MinoRoot(this.builder) {
    addChild(new MinoTableUI(builder));
  }
}

class MinoTableUI extends TinyDisplayObject {
  TinyGameBuilder builder;
  MinoTable table = new MinoTable();
  TinyColor colorEmpty = new TinyColor.argb(0xaa, 0xff, 0xaa, 0xaa);
  TinyColor colorFrame = new TinyColor.argb(0xaa, 0x55, 0x33, 0x33);
  MinoTableUI(this.builder) {
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

  MinoTable({this.fieldW: 12, this.fieldH: 22}) {
    for (int y = 0; y < fieldHWithFrame; y++) {
      for (int x = 0; x < fieldWWithFrame; x++) {
        if (x == 0 || x == fieldWWithFrame-1 || y == fieldH) {
          minos.add(new Mino(MinoTyoe.frame));
        } else {
          minos.add(new Mino(MinoTyoe.empty));
        }
      }
    }
  }

  Mino getMino(int x, int y) {
    return minos[x + y * fieldWWithFrame];
  }
}

enum MinoTyoe { empty, frame, l, o, s, z, j, t }

class Mino {
  MinoTyoe type;
  Mino(this.type) {}
}
