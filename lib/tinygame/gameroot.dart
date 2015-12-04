part of tinygame;

class TinyGameRoot extends TinyDisplayObject {
  double w = 800.0;
  double h = 600.0;
  double ratioW = 1.0;
  double ratioH = 1.0;
  double radio = 1.0;
  double l = 0.0;
  double t = 0.0;
  TinyColor bkcolor;
  bool isClipRect;

  TinyGameRoot(this.w, this.h, {this.bkcolor, this.isClipRect:true}) {
    if (bkcolor == null) {
      bkcolor = new TinyColor.argb(0xff, 0xee, 0xee, 0xff);
    }
  }

  void updatePosition(TinyStage stage, int timeStamp) {
    ratioW = (stage.w - (stage.paddingLeft+stage.paddingRight)) / w;
    ratioH = (stage.h - (stage.paddingTop+stage.paddingBottom)) / h;
    radio = (ratioW < ratioH ? ratioW : ratioH);
    t = stage.paddingTop;
    l = (stage.w - (w * radio)) / 2 + stage.paddingLeft;
    mat = new Matrix4.identity();
    mat.translate(l, t, 0.0);
    mat.scale(radio, radio, 1.0);
  }

  bool touch(TinyStage stage, int id,
    String type, double x, double y) {
    //  stage.pushMulMatrix(mat);
      super.touch(stage, id, type, x, y);
      //stage.popMatrix();
    }

  void onTick(TinyStage stage, int timeStamp) {
    updatePosition(stage, timeStamp);
  }

  void paint(TinyStage stage, TinyCanvas canvas) {
    TinyRect rect = new TinyRect(0.0, 0.0, w, h);
//    canvas.pushMulMatrix(mat);
    if(isClipRect == true) {
      canvas.pushClipRect(stage, rect);
    }
    super.paint(stage, canvas);
    if(isClipRect == true) {
      canvas.popClipRect(stage);
    }
//    canvas.popMatrix();
  }

  void onPaint(TinyStage stage, TinyCanvas canvas) {
    TinyRect rect = new TinyRect(0.0, 0.0, w, h);
    TinyPaint paint = new TinyPaint();
    paint.color = bkcolor;
    canvas.drawRect(stage, rect, paint);
  }
}
