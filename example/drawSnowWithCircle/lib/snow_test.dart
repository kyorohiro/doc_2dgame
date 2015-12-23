import 'package:umiuni2d/tinygame.dart';
import 'package:vector_math/vector_math_64.dart';
import 'dart:math' as math;

class SnowTest extends TinyDisplayObject {
  SnowTest(TinyGameBuilder builder) {
    Snows snows = new Snows();
    addChild(snows);
    for (int i = 0; i < 100; i++) {
      snows.addIdName(0.4, randomSize: true);
      snows.addIdName(0.4, randomSize: true);
    }
  }

  bool onTouch(TinyStage stage, int id, TinyStagePointerType type, double x, double y, double globalX, globalY) {
    return false;
  }
}

class Snow {
  double x = 0.0;
  double y = 0.0;
  double dx = 0.0;
  double dy = 0.0;
  double size = 1.0;
  String type = "BG001.png";
  bool randomSize;
  double baseSize = 1.0;
  math.Random r = new math.Random();
  double getWidth(double baseW) => baseW * size;
  double getHeight(double baseH) => baseH * size;
  TinyRect tmp = new TinyRect(0.0, 0.0, 0.0, 0.0);
  List<Object> cache = [];
  TinyPaint p = new TinyPaint();

  Snow(this.baseSize, {this.randomSize: false}) {
    reset();
  }

  reset() {
    x = r.nextDouble() * 400;
    y = -1 * r.nextDouble() * 100 - 100;
    dx = r.nextDouble() - 0.5;
    dy = r.nextDouble();
    if(r.nextDouble() > 0.5) {
     p.color = new TinyColor.argb(0xaa, 0xff, 0xaa, 0xaa);
   } else {
     p.color = new TinyColor.argb(0xaa, 0xaa, 0xaa, 0xff);
   }
    if (randomSize) {
      size = this.baseSize * (r.nextDouble() * 0.75 + 0.25);
    } else {
      size = this.baseSize;
    }
  }
}

class Snows extends TinyDisplayObject {
  math.Random r = new math.Random();
  TinyImage bgimg;
  List<Snow> idnames = [];
  TinyPaint p = new TinyPaint();

  Snows() {}
  addIdName(double baseSize, {bool randomSize: false}) {
    idnames.add(new Snow(baseSize, randomSize: randomSize));
  }

  void onPaint(TinyStage stage, TinyCanvas canvas) {
      for (Snow se in idnames) {
        se.tmp.x = se.x;
        se.tmp.y = se.y;
        se.tmp.w = 50.0;
        se.tmp.h = 50.0;
        canvas.drawOval(stage, se.tmp, se.p);
        se.x += se.dx;
        se.y += se.dy;
        se.dy += 0.001;
        if (se.x + se.getWidth(50.0) < 0 || se.x - se.getWidth(50.0) > 400 || se.y - se.getHeight(50.0) > 300) {
          se.reset();
        }
      }
  }
}
