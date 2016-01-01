import 'package:umiuni2d/tinygame.dart';
import 'package:vector_math/vector_math_64.dart';
import 'dart:async';

class PrimitiveTest extends TinyDisplayObject {
  TinyGameBuilder builder;
  TinyImage image = null;
  TinyStage stage = null;

  PrimitiveTest(this.builder, this.stage) {
    tic();
  }

  tic() async {
    //stage.kick(0);
    while(true) {
      await new Future.delayed(new Duration(milliseconds:50));
      stage.markNeedsPaint();
    }
  }

  double i = 1.0;
  void onPaint(TinyStage stage, TinyCanvas canvas) {
    i+=0.1;
    TinyPaint p = new TinyPaint();
    p.color = new TinyColor.argb(0x55, 0xff, 0x44, 0x44);
    canvas.drawRect(null, new TinyRect(0.0, 0.0, 400.0, 300.0), p);

    Matrix4 m = new Matrix4.identity()
    ..translate(200.0, 150.0, 0.0)
    ..rotateZ(i*3.14/4)
    ..translate(-50.0, -50.0, 0.0);

    canvas.pushMulMatrix(m);
    canvas.drawRect(null, new TinyRect(0.0, 0.0, 100.0, 100.0), p);
    canvas.popMatrix();

  }
}
