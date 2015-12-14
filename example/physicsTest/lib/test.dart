library gamelogic;

import 'dart:async';
import 'dart:math' as math;
import 'package:umiuni2d/tinygame.dart';
import 'package:umiuni2d/tinyphysics2d.dart';

class PhysicsTest extends TinyDisplayObject {
  TinyGameBuilder builder;
  math.Random rand = new math.Random();
  World w = new World();
  double worldDx = 0.0;
  double worldDy = 1.0;
  PhysicsTest(this.builder) {
    // ball
    for (int i = 0; i < 40; i++) {
      double size = rand.nextDouble() * 12.0 + 5.0;
      w.primitives.add(new CirclePrimitive()
        ..move(200.0, 200.0)
        ..dxy.y = rand.nextDouble() * 5.0
        ..dxy.x = rand.nextDouble() * 5.0
        ..radius = size
        ..mass = size / 10.0);
    }

// frame
    for (int i = 0; i < 20; i++) {
      w.primitives.add(new CirclePrimitive()
        ..move(20.0 + i * 20, 0.0)
        ..radius = 9.0
        ..mass = 50.0
        ..isFixing = true);
    }
    for (int i = 0; i < 20; i++) {
      w.primitives.add(new CirclePrimitive()
        ..move(20.0, 0.0 + i * 20)
        ..radius = 9.0
        ..isFixing = true);
    }
    for (int i = 0; i < 20; i++) {
      w.primitives.add(new CirclePrimitive()
        ..move(420.0, 0.0 + i * 20)
        ..radius = 9.0
        ..isFixing = true);
    }
    for (int i = 0; i < 20; i++) {
      w.primitives.add(new CirclePrimitive()
        ..move(20.0 + i * 20, 400.0)
        ..radius = 9.0
        ..isFixing = true);
    }
  }

  int prevTime = 0;
  void onTick(TinyStage stage, int timeStamp) {
    if(prevTime == 0) {
      prevTime = timeStamp;
      return;
    }
    w.gravity.x = 2*worldDx / 50.0;
    w.gravity.y = 2*worldDy / 50.0;
    double a = (timeStamp-prevTime) /20;
    for (int i = 0; i < 4; i++) {
      w.next(0.25*a);
    }
    stage.markNeedsPaint();
    prevTime = timeStamp;
  }
  bool touch(TinyStage stage, int id, TinyStagePointerType type, double x, double y) {
    worldDx =3*(x/450-0.5);
    worldDy =3*(y/450-0.5);
  }
  void onPaint(TinyStage stage, TinyCanvas canvas) {
    TinyPaint pa = new TinyPaint();
    TinyRect r = new TinyRect(0.0,0.0,0.0,0.0);
    pa.color = new TinyColor.argb(0xaa, 0xff, 0xff, 0xaa);
    for (Primitive p in w.primitives) {
      CirclePrimitive c = p;
      double rd = c.radius;
      r.x = c.xy.x - rd;
      r.y = c.xy.y - rd;
      r.w = rd * 2;
      r.h = rd * 2;
      canvas.drawOval(stage, r, pa);
    }
  }
}
