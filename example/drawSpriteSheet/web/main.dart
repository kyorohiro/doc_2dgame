import 'package:umiuni2d/tinygame.dart';
import 'package:umiuni2d/tinygame_webgl.dart';

main() async {
  print("---------NNNN---1--");
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
    print("---------NNNN----2-");
    builder.loadImage("./assets/nono.png").then((TinyImage i){
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
    if(spriteInfo == null) {
      return;
    }
    d++;
    if(d<4) {
      
    } else {
    d=0;
    i++;
    }
    int index = i%spriteInfo.frames.length;

    TinyPaint paint =
        new TinyPaint(color: new TinyColor.argb(0xaa, 0xff, 0xaa, 0xaa));
//    canvas.drawRect(stage, new TinyRect(100.0, 100.0, 150.0, 50.0), paint);
    if(image != null) {
    canvas.drawImageRect(stage, image, 
        spriteInfo.frames[index].srcRect, 
        spriteInfo.frames[index].dstRect,
        paint);
    }
    //canvas.drawRect(stage, new TinyRect(100.0, 100.0, 150.0, 50.0), paint);
  }

  bool onTouch(TinyStage stage, int id, String type, double x, double y,
      double globalX, globalY) {
    return false;
  }
}
