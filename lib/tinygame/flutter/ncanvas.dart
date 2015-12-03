part of tinygame_flutter;

class TinyFlutterNCanvas extends TinyCanvas {
  PaintingCanvas canvas;
  TinyFlutterNCanvas(this.canvas) {}

  List<Point> vertices = [];
  List<Point> textureCoordinates = [];
  List<Color> colors = [];
  List<int> indicies = [];
  void drawOval(TinyStage stage, TinyRect rect, TinyPaint paint) {
  }

  void drawLine(TinyStage stage, TinyPoint p1, TinyPoint p2, TinyPaint paint) {
  }

  void drawRect(TinyStage stage, TinyRect rect, TinyPaint paint) {
      int bi = vertices.length;
      Matrix4 m = calcMat();
      Vector3 v1 = new Vector3(rect.x, rect.y , 0.0);
      Vector3 v2 = new Vector3(rect.x, rect.y+rect.h , 0.0);
      Vector3 v3 = new Vector3(rect.x+rect.w, rect.y+rect.h , 0.0);
      Vector3 v4 = new Vector3(rect.x+rect.w, rect.y, 0.0);
      v1 = m * v1;
      v2 = m * v2;
      v3 = m * v3;
      v4 = m * v4;
      vertices.addAll([
        new Point(v1.x, v1.y),
        new Point(v2.x, v2.y),
        new Point(v3.x, v3.y),
        new Point(v4.x, v4.y)
      ]);
      Color c = new Color.fromARGB(paint.color.a,paint.color.r,paint.color.g,paint.color.b);
      colors.addAll([c,c,c,c]);
      textureCoordinates.addAll([
        new Point(-1.0, -1.0),
        new Point(-1.0, -1.0),
        new Point(-1.0, -1.0),
        new Point(-1.0, -1.0)
      ]);
      indicies.addAll([bi+0,bi+1,bi+2, bi+0,bi+2,bi+3]);
  }

  void clipRect(TinyStage stage, TinyRect rect) {
    canvas.clipRect(new Rect.fromLTWH(rect.x, rect.y, rect.w, rect.h));
  }


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
          flush();
        }
        int bi = vertices.length;
        vertices.addAll([
          new Point(dst.x, dst.y),
          new Point(dst.x, dst.y+dst.h),
          new Point(dst.x+dst.w, dst.y+dst.h),
          new Point(dst.x+dst.w, dst.y),
        ]);
        Color c = new Color.fromARGB(0x00, 0x00, 0x00, 0x00);
        colors.addAll([c,c,c,c]);
        textureCoordinates.addAll([
          new Point(src.x, src.y),
          new Point(src.x, src.y+src.h),
          new Point(src.x+src.w, src.y+src.h),
          new Point(src.x+src.w, src.y)
        ]);
        indicies.addAll([bi+0,bi+1,bi+2, bi+0,bi+2,bi+3]);
  }

  void updateMatrix() {
    canvas.setMatrix(this.getMatrix().storage);
  }
  Matrix4 cacheMatrix = new Matrix4.identity();
  Matrix4 calcMat() {
    cacheMatrix.setIdentity();
    //cacheMatrix = cacheMatrix.translate(-1.0, 1.0, 0.0);
    //cacheMatrix = cacheMatrix.scale(2.0 / glContext.widht, -2.0 / glContext.height, 1.0);
    cacheMatrix = cacheMatrix * getMatrix();
    return cacheMatrix;
  }
}
