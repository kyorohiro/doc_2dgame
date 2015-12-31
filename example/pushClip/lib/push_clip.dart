import 'package:umiuni2d/tinygame.dart';
import 'package:vector_math/vector_math_64.dart';


class PrimitiveTest extends TinyDisplayObject {
  TinyGameBuilder builder;
  TinyImage image = null;
  PrimitiveTest(this.builder) {}

  void onPaint(TinyStage stage, TinyCanvas canvas) {
    TinyPaint p = new TinyPaint();
    p.color = new TinyColor.argb(0x55, 0xff, 0x44, 0x44);
    canvas.drawRect(null, new TinyRect(0.0, 0.0, 400.0, 300.0), p);
    canvas.pushMulMatrix(
      new Matrix4.identity()
      ..translate(200.0, 150.0, 0.0)
      ..rotateZ(3.14/4)
      ..translate(-50.0, -50.0, 0.0)
    );
//    canvas.pushMulMatrix(new Matrix4.translationValues(200.0, 100.0, 0.0));
    canvas.pushClipRect(stage, new TinyRect(0.0, 0.0, 50.0, 200.0));
    canvas.drawRect(null, new TinyRect(0.0, 0.0, 100.0, 100.0), p);
    canvas.popMatrix();
    canvas.popClipRect(stage);

  }
}
