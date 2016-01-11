part of tinygame_flutter;

class TinyFlutterCanvas extends TinyCanvas {
  Canvas canvas;
  TinyFlutterCanvas(this.canvas) {}

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

  void drawLine(TinyStage stage, TinyPoint p1, TinyPoint p2, TinyPaint paint, {List<Object> cache: null}) {
    canvas.drawLine(new Point(p1.x, p1.y), new Point(p2.x, p2.y), toPaint(paint));
  }

  void drawRect(TinyStage stage, TinyRect rect, TinyPaint paint, {List<Object> cache: null}) {
    canvas.drawRect(new Rect.fromLTWH(rect.x, rect.y, rect.w, rect.h), toPaint(paint));
  }

  void drawOval(TinyStage stage, TinyRect rect, TinyPaint paint, {List<Object> cache: null}) {
    Paint p = toPaint(paint);
    canvas.drawOval(new Rect.fromLTWH(rect.x, rect.y, rect.w, rect.h), p);
  }

  void clipRect(TinyStage stage, TinyRect rect, {Matrix4 m: null}) {
    if (m != null) {
      data.Float64List d = canvas.getTotalMatrix();
      canvas.setMatrix(m.storage);
      canvas.clipRect(new Rect.fromLTWH(rect.x, rect.y, rect.w, rect.h));
      canvas.setMatrix(d);
    } else {
      canvas.clipRect(new Rect.fromLTWH(rect.x, rect.y, rect.w, rect.h));
    }
  }

  void clearClip(TinyStage stage, {List<Object> cache: null}) {
    data.Float64List dd = canvas.getTotalMatrix();
    canvas.restore();
    canvas.save();
    canvas.setMatrix(dd);
  }

  void drawImageRect(TinyStage stage, TinyImage image, TinyRect src, TinyRect dst, TinyPaint paint, {TinyCanvasTransform transform: TinyCanvasTransform.NONE, List<Object> cache: null}) {
    Rect s = new Rect.fromLTWH(src.x, src.y, src.w, src.h);
    Rect d = new Rect.fromLTWH(0.0, 0.0, dst.w, dst.h);

    sky.Image i = (image as TinyFlutterImage).rawImage;
    data.Float64List dd = canvas.getTotalMatrix();
    switch (transform) {
      case TinyCanvasTransform.NONE:
        canvas.translate(dst.x, dst.y);
        break;
      case TinyCanvasTransform.ROT90:
        canvas.translate(dst.x, dst.y);
        canvas.translate(dst.w / 2, dst.h / 2);
        canvas.rotate(math.PI / 2);
        canvas.translate(-dst.w / 2, -dst.h / 2);
        break;
      case TinyCanvasTransform.ROT180:
        canvas.translate(dst.x, dst.y);
        canvas.translate(dst.w / 2, dst.h / 2);
        canvas.rotate(math.PI);
        canvas.translate(-dst.w / 2, -dst.h / 2);
        break;
      case TinyCanvasTransform.ROT270:
        canvas.translate(dst.x, dst.y);
        canvas.translate(dst.w / 2, dst.h / 2);
        canvas.rotate(-math.PI / 2);
        canvas.translate(-dst.w / 2, -dst.h / 2);
        break;
      case TinyCanvasTransform.MIRROR:
        canvas.translate(dst.x, dst.y);
        canvas.translate(dst.w / 2, dst.h / 2);
        Matrix4 t = new Matrix4.fromFloat64List(canvas.getTotalMatrix());
        t = t * new Matrix4(-1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0);
        canvas.setMatrix(t.storage);
        canvas.translate(-dst.w / 2, -dst.h / 2);
        break;
      case TinyCanvasTransform.MIRROR_ROT90:
        canvas.translate(dst.x, dst.y);
        canvas.translate(dst.w / 2, dst.h / 2);

        Matrix4 t = new Matrix4.fromFloat64List(canvas.getTotalMatrix());
        t = t * new Matrix4(-1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0);
        canvas.setMatrix(t.storage);
        canvas.rotate(math.PI / 2);
        canvas.translate(-dst.w / 2, -dst.h / 2);
        break;
      case TinyCanvasTransform.MIRROR_ROT180:
        canvas.translate(dst.x, dst.y);
        canvas.translate(dst.w / 2, dst.h / 2);

        Matrix4 t = new Matrix4.fromFloat64List(canvas.getTotalMatrix());
        t = t * new Matrix4(-1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0);
        canvas.setMatrix(t.storage);
        canvas.rotate(math.PI);
        canvas.translate(-dst.w / 2, -dst.h / 2);
        break;
      case TinyCanvasTransform.MIRROR_ROT270:
        canvas.translate(dst.x, dst.y);
        canvas.translate(dst.w / 2, dst.h / 2);

        Matrix4 t = new Matrix4.fromFloat64List(canvas.getTotalMatrix());
        t = t * new Matrix4(-1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0);
        canvas.setMatrix(t.storage);
        canvas.rotate(-math.PI / 2);
        canvas.translate(-dst.w / 2, -dst.h / 2);
        break;
      default:
    }
    canvas.drawImageRect(
        i,
        s,
        d,
//      new Paint());
        toPaint(paint));
    canvas.setMatrix(dd);
  }

  clear() {
    canvas.save();
  }

  void updateMatrix() {
    canvas.setMatrix(this.getMatrix().storage);
  }
}
