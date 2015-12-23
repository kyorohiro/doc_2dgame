import 'package:umiuni2d/tinygame.dart';

class PrimitiveTest extends TinyDisplayObject {
  TinyGameBuilder builder;
  TinyImage image = null;
  PrimitiveTest(this.builder) {
    builder.loadImage("assets/icon.png").then((TinyImage i) {
      image = i;
    });
  }

  void onPaint(TinyStage stage, TinyCanvas canvas) {
    if(image == null) {
      return;
    }
    {
      TinyPaint p = new TinyPaint();
      canvas.drawImageRect(stage,
          image,
          new TinyRect(0.0,0.0, 1.0*image.w, 1.0*image.h),
          new TinyRect(0.0,50.0, 40.0, 40.0),
          p,transform: TinyCanvasTransform.NONE);
      canvas.drawImageRect(stage,
          image,
          new TinyRect(0.0,0.0, 1.0*image.w, 1.0*image.h),
          new TinyRect(0.0,100.0, 40.0, 40.0),
          p,transform: TinyCanvasTransform.ROT90);
      canvas.drawImageRect(stage,
          image,
          new TinyRect(0.0,0.0, 1.0*image.w, 1.0*image.h),
          new TinyRect(0.0,150.0, 40.0, 40.0),
          p,transform: TinyCanvasTransform.ROT180);
      canvas.drawImageRect(stage,
          image,
          new TinyRect(0.0,0.0, 1.0*image.w, 1.0*image.h),
          new TinyRect(0.0,200.0, 40.0, 40.0),
          p,transform: TinyCanvasTransform.ROT270);
    }
    {
      TinyPaint p = new TinyPaint();
      canvas.drawImageRect(stage,
          image,
          new TinyRect(0.0,0.0, 1.0*image.w, 1.0*image.h),
          new TinyRect(100.0,50.0, 40.0, 40.0),
          p,transform: TinyCanvasTransform.MIRROR);
      canvas.drawImageRect(stage,
          image,
          new TinyRect(0.0,0.0, 1.0*image.w, 1.0*image.h),
          new TinyRect(100.0,100.0, 40.0, 40.0),
          p,transform: TinyCanvasTransform.MIRROR_ROT90);
      canvas.drawImageRect(stage,
          image,
          new TinyRect(0.0,0.0, 1.0*image.w, 1.0*image.h),
          new TinyRect(100.0,150.0, 40.0, 40.0),
          p,transform: TinyCanvasTransform.MIRROR_ROT180);
      canvas.drawImageRect(stage,
          image,
          new TinyRect(0.0,0.0, 1.0*image.w, 1.0*image.h),
          new TinyRect(100.0,200.0, 40.0, 40.0),
          p,transform: TinyCanvasTransform.MIRROR_ROT270);
    }
  }
}
