part of tinygame_flutter;

class TinyFlutterCanvas extends TinyCanvas {
  PaintingCanvas canvas;
  TinyFlutterCanvas(this.canvas) {}

  void drawOval(TinyStage stage, TinyRect rect, TinyPaint paint) {
    Paint p = toPaint(paint);
    canvas.drawOval(new Rect.fromLTWH(rect.x, rect.y, rect.w, rect.h), p);
  }

  Paint toPaint(TinyPaint p) {
    Paint pp = new Paint();
    pp.color = new Color(p.color.value);
    pp.strokeWidth = p.strokeWidth;
    switch (p.style) {
      case TinyPaintStyle.fill:
        pp.style = sky.PaintingStyle.fill;
        break;
      case TinyPaintStyle.stroke:
        pp.style = sky.PaintingStyle.stroke;
        break;
    }
    return pp;
  }

  void drawLine(TinyStage stage, TinyPoint p1, TinyPoint p2, TinyPaint paint) {
    canvas.drawLine(
        new Point(p1.x, p1.y), new Point(p2.x, p2.y), toPaint(paint));
  }

  void drawRect(TinyStage stage, TinyRect rect, TinyPaint paint) {
    canvas.drawRect(
        new Rect.fromLTWH(rect.x, rect.y, rect.w, rect.h), toPaint(paint));
  }

  void clipRect(TinyStage stage, TinyRect rect) {
    canvas.clipRect(new Rect.fromLTWH(rect.x, rect.y, rect.w, rect.h));
  }

  void drawImageRect(TinyStage stage, TinyImage image, TinyRect src,
      TinyRect dst, TinyPaint paint) {
    Rect s = new Rect.fromLTWH(src.x, src.y, src.w, src.h);
    Rect d = new Rect.fromLTWH(dst.x, dst.y, dst.w, dst.h);
    sky.Image i = (image as TinyFlutterImage).rawImage;
    canvas.drawImageRect(
        i,
        s,
        d,
//      new Paint());
        toPaint(paint));
  }

  void updateMatrix() {
    canvas.setMatrix(this.getMatrix().storage);
  }
}
