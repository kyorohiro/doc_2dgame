part of tinygame_flutter;

class TinyFlutterNCanvas extends TinyCanvas {
  PaintingCanvas canvas;
  TinyFlutterNCanvas(this.canvas) {}

  void drawOval(TinyStage stage, TinyRect rect, TinyPaint paint) {
  }

  void drawLine(TinyStage stage, TinyPoint p1, TinyPoint p2, TinyPaint paint) {
  }

  void drawRect(TinyStage stage, TinyRect rect, TinyPaint paint) {
  }

  void clipRect(TinyStage stage, TinyRect rect) {
    canvas.clipRect(new Rect.fromLTWH(rect.x, rect.y, rect.w, rect.h));
  }

  List<Point> vertices = [];
  List<Point> textureCoordinates = [];
  List<Color> colors = [];
  List<int> indicies = [0, 1, 2, 3];
  flush() {

    canvas.drawVertices(
      sky.VertexMode.triangles,
      vertices,
      textureCoordinates,
      colors,
      sky.TransferMode.color,
      indicies,
      new Paint()..style = sky.PaintingStyle.fill);
      //
      vertices.clear();
      textureCoordinates.clear();
  }

  void drawImageRect(TinyStage stage, TinyImage image, TinyRect src,
      TinyRect dst, TinyPaint paint) {
        vertices.addAll([]);
    /*Rect s = new Rect.fromLTWH(src.x, src.y, src.w, src.h);
    Rect d = new Rect.fromLTWH(dst.x, dst.y, dst.w, dst.h);
    sky.Image i = (image as TinyFlutterImage).rawImage;
    canvas.drawImageRect(
        i,
        s,
        d,
        new Paint());*/
  }

  void updateMatrix() {
    canvas.setMatrix(this.getMatrix().storage);
  }
}
