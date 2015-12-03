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
  List<int> indicies = [];
  flush() {
    Paint p = new Paint()..style = sky.PaintingStyle.fill;
    if(curImage != null){
    sky.TransferMode transferMode = sky.TransferMode.color;
    sky.TileMode tmx = sky.TileMode.clamp;
    sky.TileMode tmy = sky.TileMode.clamp;
    data.Float64List matrix4 = new Matrix4.identity().storage;
    sky.ImageShader imgShader = new sky.ImageShader((curImage as TinyFlutterImage).rawImage, tmx, tmy, matrix4);
    p.shader = imgShader;
    }
    canvas.drawVertices(
      sky.VertexMode.triangles,
      vertices,
      textureCoordinates,
      colors,
      sky.TransferMode.color,
      indicies, p);
      //
      vertices.clear();
      textureCoordinates.clear();
      colors.clear();
      indicies.clear();
  }

  TinyImage curImage = null;
  void drawImageRect(TinyStage stage, TinyImage image, TinyRect src,
      TinyRect dst, TinyPaint paint) {
        if(curImage == null) {
          curImage = image;
        }
        if(curImage != null && curImage != image) {
        //  flush();
        }
        int bi = vertices.length;
        vertices.addAll([
          new Point(dst.x, dst.y),
          new Point(dst.x, dst.y+dst.h),
          new Point(dst.x+dst.w, dst.y+dst.h),
          new Point(dst.x+dst.w, dst.y),
        ]);
        Color c = new Color.fromARGB(0x33, 0xff, 0xff, 0xff);
        colors.addAll([c,c,c,c]);
        textureCoordinates.addAll([
          new Point(src.x, src.y),
          new Point(src.x, src.y+src.h),
          new Point(src.x+src.w, src.y+src.h),
          new Point(src.x+src.w, src.y)
        ]);
        indicies.addAll([bi+0,bi+1,bi+2, bi+0,bi+2,bi+3]);
      //  flush();
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
