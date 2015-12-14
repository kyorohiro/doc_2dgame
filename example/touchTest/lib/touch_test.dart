import 'package:umiuni2d/tinygame.dart';
import 'dart:math' as math;

class PrimitiveTest extends TinyDisplayObject {
  TinyGameBuilder builder;
  PrimitiveTest(this.builder) {
    // for container test
    mat.rotateZ(math.PI/10);
  }

  Map<int, List<double>> touches = {};

  bool onTouch(TinyStage stage, int id, TinyStagePointerType type, double x, double y,
      double globalX, globalY) {
    touches[id] = [x, y];
    if (type == TinyStagePointerType.UP || type == TinyStagePointerType.CANCEL) {
      touches.remove(id);
    }
    return false;
  }

  void onPaint(TinyStage stage, TinyCanvas canvas) {
    TinyPaint p = new TinyPaint();
    for (List<double> xy in touches.values) {
      p.color = new TinyColor.argb(0xff, 0x00, 0xff, 0xff);
      p.style = TinyPaintStyle.stroke;
      p.strokeWidth = 2.5;
      canvas.drawRect(
          null, new TinyRect(xy[0] - 25.0, xy[1] - 25.0, 50.0, 50.0), p);
    }
  }
}
