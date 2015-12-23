import 'package:umiuni2d/tinygame.dart';

class PrimitiveTest extends TinyDisplayObject {
  TinyGameBuilder builder;
  TinyImage image = null;
  PrimitiveTest(this.builder) {
  }

  void onPaint(TinyStage stage, TinyCanvas canvas) {
    {
      TinyPaint p = new TinyPaint();
      p.color = new TinyColor.argb(0x55, 0xff, 0x44, 0x44);
      canvas.drawRect(null, new TinyRect(0.0, 0.0, 400.0, 300.0), p);
      canvas.clipRect(null, new TinyRect(10.0, 10.0, 380.0, 280.0));
      canvas.drawRect(null, new TinyRect(0.0, 0.0, 400.0, 300.0), p);
      canvas.clipRect(null, new TinyRect(100.0, 20.0, 100.0, 300.0));
      canvas.drawRect(null, new TinyRect(0.0, 0.0, 400.0, 300.0), p);
    }
    {
      canvas.clearClip(stage);
      canvas.clipRect(null, new TinyRect(0.0, 150.0, 400.0, 150.0));
      TinyPaint p = new TinyPaint();
      p.color = new TinyColor.argb(0xff, 0x44, 0x44, 0xff);
      canvas.drawRect(null, new TinyRect(0.0, 150.0, 400.0, 300.0), p);
    }
  }
}
