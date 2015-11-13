import 'dart:math' as math;
import 'package:umiuni2d/tinygame.dart';
import 'package:vector_math/vector_math_64.dart';

class PrimitiveTest extends TinyDisplayObject {
  TinyGameBuilder builder;
  TinyImage image = null;
  PrimitiveTest(this.builder) {
    builder.loadImage("assets/test.jpg").then((TinyImage i) {
      image = i;
    });
  }

  void onPaint(TinyStage stage, TinyCanvas canvas) {
    if(image == null) {
      return;
    }
    {
      TinyPaint p = new TinyPaint();
      canvas.clipRect(null, new TinyRect(50.0, 100.0, 150.0, 280.0));
      canvas.drawRect(null, new TinyRect(50.0, 50.0, 100.0, 100.0), p);
    }
    canvas.pushMulMatrix(
        new Matrix4.identity().rotateZ(math.PI / 8.0)); //math.PI/100.0));
    {
      TinyPaint p = new TinyPaint();
      p.color = new TinyColor.argb(0xff, 0xff, 0xff, 0x00);

      canvas.drawRect(null, new TinyRect(50.0, 50.0, 100.0, 100.0), p);

      p.color = new TinyColor.argb(0xff, 0x00, 0xff, 0xff);
      p.style = TinyPaintStyle.stroke;
      p.strokeWidth = 2.5;
//    canvas.drawRect(null, new TinyRect(0.0, 0.0, 100.0, 100.0), p);
      canvas.drawRect(null, new TinyRect(150.0, 150.0, 100.0, 100.0), p);

      p.style = TinyPaintStyle.fill;
      canvas.drawOval(null, new TinyRect(150.0, 150.0, 100.0, 100.0), p);
      
      p.style = TinyPaintStyle.stroke;
      p.strokeWidth = 20.0;
      p.color = new TinyColor.argb(0xff, 0xff, 0xaa, 0xaa);
      canvas.drawOval(null, new TinyRect(150.0, 150.0, 100.0, 100.0), p);
    }
    
    {
      TinyPaint p = new TinyPaint();
      p.color = new TinyColor.argb(0xff, 0xff, 0xff, 0x00);
      //
      TinyRect src =
          new TinyRect(0.0, 0.0, image.w.toDouble(), image.h.toDouble());
      canvas.drawImageRect(
          null,
          image,
          src,
          new TinyRect(
              250.0, 25.0, image.w.toDouble() / 2, image.h.toDouble() / 2),
          p);
    }

    {
      TinyPaint p = new TinyPaint();
      p.color = new TinyColor.argb(0xff, 0xff, 0xff, 0x00);
      //p.style = TinyPaintStyle.stroke;
      //
      TinyRect src =
          new TinyRect(0.0, 0.0, image.w.toDouble(), image.h.toDouble());
      canvas.drawLine(
          null, new TinyPoint(200.0, 200.0), new TinyPoint(500.0, 200.0), p);
    }
    canvas.popMatrix();
  }
}
