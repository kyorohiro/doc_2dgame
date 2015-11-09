import 'package:umiuni2d/tinygame.dart';
import 'package:umiuni2d/tinygame_webgl.dart';
import 'package:vector_math/vector_math_64.dart';

main() async {
  TinyGameBuilder builder = new TinyGameBuilderForWebgl();
  TinyGameRoot root = new TinyGameRoot(400.0, 300.0);
  TinyStage stage = builder.createStage(root);
  stage.start();
  root.addChild(new Test(builder));
}

class Test extends TinyDisplayObject {
  SpriteSheetInfo spriteInfo = null;
  TinyImage image = null;

  Test(TinyGameBuilder builder) {
    builder.loadImage("./assets/nono.png").then((TinyImage i) {
      image = i;
    });
    builder.loadString("./assets/nono.json").then((String x) {
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
    if (spriteInfo == null) {
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
