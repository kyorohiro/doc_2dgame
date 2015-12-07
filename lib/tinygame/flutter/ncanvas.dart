part of tinygame_flutter;

class TinyFlutterNCanvas extends TinyCanvas {
  PaintingCanvas canvas;
  TinyFlutterNCanvas(this.canvas) {}

  List<Point> vertices = [];
  List<Point> textureCoordinates = [];
  List<Color> colors = [];
  List<int> indicies = [];
  int numOfCircleElm = 50;
  void drawOval(TinyStage stage, TinyRect rect, TinyPaint paint) {
    if (curImage != null) {
      flush();
    }
    if(paint.style == TinyPaintStyle.fill) {
      drawFillOval(stage, rect, paint);
    } else {
      drawStrokeOval(stage, rect, paint);
    }
  }

  void drawStrokeOval(TinyStage stage, TinyRect rect, TinyPaint paint) {
    if (curImage != null) {
      flush();
    }
    double cx = rect.x + rect.w / 2.0;
    double cy = rect.y + rect.h / 2.0;
    double a = (rect.w+paint.strokeWidth)/ 2;
    double b = (rect.h+paint.strokeWidth)/ 2;
    double c = (rect.w-paint.strokeWidth)/ 2;
    double d = (rect.h-paint.strokeWidth)/ 2;

    Matrix4 m = calcMat();
    Vector3 s1 = new Vector3(0.0, 0.0, 0.0);
    Vector3 s2 = new Vector3(0.0, 0.0, 0.0);
    Vector3 s3 = new Vector3(0.0, 0.0, 0.0);
    Vector3 s4 = new Vector3(0.0, 0.0, 0.0);
    Color color = new Color.fromARGB(paint.color.a,paint.color.r,paint.color.g,paint.color.b);
    for (int i = 0; i < numOfCircleElm; i++) {
      //
      int bbb = vertices.length;

      //
      s1.x = cx + math.cos(2 * math.PI * (i / numOfCircleElm)) * c;
      s1.y = cy + math.sin(2 * math.PI * (i / numOfCircleElm)) * d;
      s1.z = 0.0;
      s1 = m * s1;

      s2.x = cx + math.cos(2 * math.PI * (i / numOfCircleElm)) * a;
      s2.y = cy + math.sin(2 * math.PI * (i / numOfCircleElm)) * b;
      s1.z = 0.0;
      s2 = m * s2;

      s3.x = cx + math.cos(2 * math.PI * ((i + 1) / numOfCircleElm)) * a;
      s3.y = cy + math.sin(2 * math.PI * ((i + 1) / numOfCircleElm)) * b;
      s1.z = 0.0;
      s3 = m * s3;

      s4.x = cx + math.cos(2 * math.PI * ((i + 1) / numOfCircleElm)) * c;
      s4.y = cy + math.sin(2 * math.PI * ((i + 1) / numOfCircleElm)) * d;
      s1.z = 0.0;
      s4 = m * s4;

      vertices.addAll([new Point(s1.x, s1.y),new Point(s2.x, s2.y),new Point(s3.x, s3.y),new Point(s4.x, s4.y)]);
      colors.addAll([color,color,color,color]);
      indicies.addAll([bbb + 0, bbb + 1, bbb + 2]);
      indicies.addAll([bbb + 0, bbb + 2, bbb + 3]);
    }
  }

  void drawFillOval(TinyStage stage, TinyRect rect, TinyPaint paint) {
    if (curImage != null) {
      flush();
    }
    double cx = rect.x + rect.w / 2.0;
    double cy = rect.y + rect.h / 2.0;
    double a = rect.w / 2;
    double b = rect.h / 2;
    Matrix4 m = calcMat();
    Vector3 s = new Vector3(0.0, 0.0, 0.0);
    double flZ = 0.0;
    Color c = new Color.fromARGB(paint.color.a,paint.color.r,paint.color.g,paint.color.b);
    for (int i = 0; i < numOfCircleElm; i++) {
      //
      int bbb = vertices.length;

      //
      s.x = cx;
      s.y = cy;
      s.z = flZ;
      s = m * s;
      vertices.addAll([new Point(s.x, s.y)]);
      colors.add(c);

      //
      s.x = cx + math.cos(2 * math.PI * (i / numOfCircleElm)) * a;
      s.y = cy + math.sin(2 * math.PI * (i / numOfCircleElm)) * b;
      s.z = flZ;
      s = m * s;
      vertices.addAll([new Point(s.x, s.y)]);
      colors.add(c);

      //
      s.x = cx + math.cos(2 * math.PI * ((i + 1) / numOfCircleElm)) * a;
      s.y = cy + math.sin(2 * math.PI * ((i + 1) / numOfCircleElm)) * b;
      s.z = flZ;
      s = m * s;
      vertices.addAll([new Point(s.x, s.y)]);
      colors.add(c);
//      textureCoordinates.addAll([new Point(-1.0, -1.0),

      indicies.addAll([bbb + 0, bbb + 1, bbb + 2]);

      flZ += 0.0001;
    }

  }

  void drawLine(TinyStage stage, TinyPoint p1, TinyPoint p2, TinyPaint paint) {
    if (curImage != null) {
      flush();
    }
    int bi = vertices.length;
    Matrix4 m = calcMat();
    double d = math.sqrt(math.pow(p1.x-p2.x, 2)+ math.pow(p1.y-p2.y, 2));
    double dy = -1*paint.strokeWidth*(p2.x-p1.x)/(d*2);
    double dx = paint.strokeWidth*(p2.y-p1.y)/(d*2);
    double sx = p1.x;
    double sy = p1.y;
    double ex = p2.x;
    double ey = p2.y;

    Vector3 v1 = new Vector3(sx-dx, sy-dy, 0.0);
    Vector3 v2 = new Vector3(sx+dx, sy+dy, 0.0);
    Vector3 v3 = new Vector3(ex+dx, ey+dy, 0.0);
    Vector3 v4 = new Vector3(ex-dx, ey-dy, 0.0);
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
    colors.addAll([c, c, c, c]);
    indicies.addAll([bi + 0, bi + 1, bi + 2, bi + 0, bi + 2, bi + 3]);
  }

  void drawRect(TinyStage stage, TinyRect rect, TinyPaint paint) {
    if (curImage != null) {
      flush();
    }
    if(paint.style == TinyPaintStyle.fill) {
      drawFillRect(stage, rect, paint);
    } else {
      drawStrokeRect(stage, rect, paint);
    }
  }

  void drawStrokeRect(TinyStage stage, TinyRect rect, TinyPaint paint) {
    if (curImage != null) {
      flush();
    }
    double sx = rect.x;
    double sy = rect.y;
    double ex = rect.x + rect.w;//+paint.strokeWidth;
    double ey = rect.y + rect.h;//+paint.strokeWidth;
    double dx = paint.strokeWidth/2;

    drawLine(stage, new TinyPoint(sx, sy-dx), new TinyPoint(sx, ey+dx), paint);
    drawLine(stage, new TinyPoint(sx-dx, ey), new TinyPoint(ex+dx, ey), paint);
    drawLine(stage, new TinyPoint(ex, sy-dx), new TinyPoint(ey, ey+dx), paint);
    drawLine(stage, new TinyPoint(sx-dx, sy), new TinyPoint(ey+dx, sy), paint);
  }

  void drawFillRect(TinyStage stage, TinyRect rect, TinyPaint paint) {
    if (curImage != null) {
      flush();
    }
    int bi = vertices.length;
    Matrix4 m = calcMat();
    Vector3 v1 = new Vector3(rect.x, rect.y, 0.0);
    Vector3 v2 = new Vector3(rect.x, rect.y + rect.h, 0.0);
    Vector3 v3 = new Vector3(rect.x + rect.w, rect.y + rect.h, 0.0);
    Vector3 v4 = new Vector3(rect.x + rect.w, rect.y, 0.0);
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
    colors.addAll([c, c, c, c]);
    indicies.addAll([bi + 0, bi + 1, bi + 2, bi + 0, bi + 2, bi + 3]);
  }


  void clipRect(TinyStage stage, TinyRect rect) {
    Matrix4 m = calcMat();
    Vector3 v1 = new Vector3(rect.x, rect.y, 0.0);
    Vector3 v2 = new Vector3(rect.x +rect.w, rect.y + rect.h, 0.0);
    v1 = m * v1;
    v2 = m * v2;
    canvas.clipRect(new Rect.fromLTRB(v1.x, v1.y, v2.x, v2.y));
  }

  flush() {
    Paint p = new Paint()..style = sky.PaintingStyle.fill;
    if (curImage != null) {
      sky.TileMode tmx = sky.TileMode.clamp;
      sky.TileMode tmy = sky.TileMode.clamp;
      data.Float64List matrix4 = new Matrix4.identity().storage;
      sky.ImageShader imgShader = new sky.ImageShader((curImage as TinyFlutterImage).rawImage, tmx, tmy, matrix4);
      p.shader = imgShader;
    }
    canvas.drawVertices(sky.VertexMode.triangles, vertices, textureCoordinates,
        colors, sky.TransferMode.color, indicies, p);
    vertices.clear();
    textureCoordinates.clear();
    colors.clear();
    indicies.clear();
    curImage = null;
  }

  TinyImage curImage = null;
  void drawImageRect(TinyStage stage, TinyImage image, TinyRect src,
      TinyRect dst, TinyPaint paint) {
        if(curImage == null && indicies.length > 0) {
          flush();
        }
        if(curImage == null) {
          curImage = image;
        }
        if(curImage != null && curImage != image) {
          flush();
        }
        int bi = vertices.length;
        Matrix4 m = calcMat();
        Vector3 v1 = new Vector3(dst.x, dst.y, 0.0);
        Vector3 v2 = new Vector3(dst.x, dst.y + dst.h, 0.0);
        Vector3 v3 = new Vector3(dst.x + dst.w, dst.y + dst.h, 0.0);
        Vector3 v4 = new Vector3(dst.x + dst.w, dst.y, 0.0);
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
    //canvas.setMatrix(this.getMatrix().storage);
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
