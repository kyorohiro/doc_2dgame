library gamelogic;

import 'dart:async';
import 'dart:math' as math;
import 'package:umiuni2d/tinygame.dart';

class MinoRoot extends TinyDisplayObject {
  TinyGameBuilder builder;
  MinoTable table = new MinoTable();

  MinoRoot(this.builder) {
    ;
  }

  void onPaint(TinyStage stage, TinyCanvas canvas) {
    TinyRect rect = new TinyRect(0.0, 0.0, 7.0,7.0);
    TinyPaint p = new TinyPaint();
    p.color = new TinyColor.argb(0xaa, 0xff, 0xaa, 0xaa);
    p.style = TinyPaintStyle.stroke;
    p.strokeWidth = 1.0;

    for (int x = 0; x < table.fieldWWithFrame + 2; x++) {
      for (int y = 0; y < table.fieldHWithFrame + 1; y++) {
        rect.x = x*8.0;
        rect.y = y*8.0;
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
    for (int x = 0; x < fieldW + 2; x++) {
      for (int y = 0; y < fieldH + 1; y++) {
        if (x == 0 || x == this.fieldW + 1 || y == fieldH) {
          minos.add(new Mino(MinoTyoe.block));
        } else {
          minos.add(new Mino(MinoTyoe.empty));
        }
      }
    }
  }

  Mino getMino(int x, int y) {
    return minos[x+y*fieldWWithFrame];
  }
}

enum MinoTyoe { empty, block, l, o, s, z, j, t }

class Mino {
  MinoTyoe type;
  Mino(this.type) {}
}
