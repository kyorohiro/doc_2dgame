import 'package:umiuni2d/tinygame.dart';
import 'package:vector_math/vector_math_64.dart';
import 'dart:math' as math;

class SnowTest extends TinyDisplayObject {
  SpriteSheetInfo spriteInfo = null;
  TinyImage image = null;

  SnowTest(TinyGameBuilder builder) {
    builder.loadImage("assets/nono.png").then((TinyImage i) {
      image = i;
    });
    builder.loadStringBase("assets/nono.json").then((String x) {
      spriteInfo = new SpriteSheetInfo.fronmJson(x);
      for (SpriteSheetInfoFrame f in spriteInfo.frames) {
        print("### fname: ${f.fileName} ###");
        print("##### dst: ${f.dstRect} ###");
        print("##### src: ${f.srcRect} ###");
        print("##### ang: ${f.angle} ###");
      }
    });
  }

  int i = 0;
  int d = 0;
  void onPaint(TinyStage stage, TinyCanvas canvas) {
    if (spriteInfo == null|| image == null) {
      return;
    }
    d++;
    if (d < 2) {} else {
      d = 0;
      i++;
    }
    int index = i % spriteInfo.frames.length;

    canvas.pushMulMatrix(new Matrix4.identity()..translate(50.0, 0.0, 0.0));
    TinyPaint paint =
        new TinyPaint(color: new TinyColor.argb(0xaa, 0xff, 0xaa, 0xaa));
    if (image != null) {
      canvas.drawImageRect(stage, image, spriteInfo.frames[index].srcRect,
          spriteInfo.frames[index].dstRect, paint);
      canvas.popMatrix();
    }
  }

  bool onTouch(TinyStage stage, int id, String type, double x, double y,
      double globalX, globalY) {
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
  Snow(this.type,this.baseSize, {this.randomSize:false}) {
    reset();
  }
  reset() {
    x = r.nextDouble() * 400;
    y = -1*r.nextDouble()*100;
    dx = r.nextDouble()-0.5;
    dy = r.nextDouble();
    if(randomSize) {
      size = this.baseSize *(r.nextDouble()*0.75+0.25);
    } else {
      size = this.baseSize;
    }
  }
}

class Snows extends TinyDisplayObject{
  math.Random r = new math.Random();
  TinyImage bgimg;
  SpriteSheetInfo info;
  List<Snow> idnames = [];
  TinyPaint p = new TinyPaint();

  Snows() {
  }
  addIdName(String name,double baseSize,{bool randomSize:false}) {
   idnames.add(new Snow(name, baseSize, randomSize:randomSize));
  }
  void onPaint(TinyStage stage, TinyCanvas canvas) {
    if (bgimg != null && info != null) {
      for (Snow se in idnames) {
        TinySize s = info.frameFromFileName(se.type).sourceSize;
        canvas.drawImageRect(
            stage,
            bgimg,
            info.frameFromFileName(se.type).srcRect,
            new TinyRect(se.x, se.y, s.w *se.size, s.h *se.size),
            p);
        se.x += se.dx;
        se.y += se.dy;
        se.dy += 0.001;
        if(se.x < 0 || se.x > 400 || se.y>300) {
          se.reset();
        }
      }
    }
  }
}
