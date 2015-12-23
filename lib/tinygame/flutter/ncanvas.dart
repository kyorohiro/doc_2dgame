part of tinygame_flutter;

class TinyFlutterNCanvas extends TinyCanvas {
  Canvas canvas;


  List<Point> _vertices = [];
  List<Point> _textureCoordinates = [];
  List<Color> _colors = [];
  List<int> _indicies = [];

  int _numOfCircleElm;
  int get numOfCircleElm => _numOfCircleElm;
  TinyFlutterNCanvas(this.canvas) {
    numOfCircleElm = 25;
  }
  List<double> circleCash = [];
  void set numOfCircleElm(int v) {
    if(circleCash.length ==0 || _numOfCircleElm != v){
      _numOfCircleElm = v;
      circleCash.clear();
      for (int i = 0; i < _numOfCircleElm+1; i++) {
        circleCash.add(math.cos(2 * math.PI * (i / _numOfCircleElm)));
        circleCash.add(math.sin(2 * math.PI * (i / _numOfCircleElm)));
      }
    }
  }

  void drawOval(TinyStage stage, TinyRect rect, TinyPaint paint, {List<Object>cache:null}) {
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
      int bbb = _vertices.length;

      //
      s1.x = cx + circleCash[i*2+0] * c;
      s1.y = cy + circleCash[i*2+1] * d;
      s1.z = 0.0;
      s1 = m * s1;

      s2.x = cx + circleCash[i*2+0] * a;
      s2.y = cy + circleCash[i*2+1] * b;
      s1.z = 0.0;
      s2 = m * s2;

      s3.x = cx + circleCash[i*2+2] * a;
      s3.y = cy + circleCash[i*2+3] * b;
      s1.z = 0.0;
      s3 = m * s3;

      s4.x = cx + circleCash[i*2+2] * c;
      s4.y = cy + circleCash[i*2+3] * d;
      s1.z = 0.0;
      s4 = m * s4;

      _vertices.addAll([new Point(s1.x, s1.y),new Point(s2.x, s2.y),new Point(s3.x, s3.y),new Point(s4.x, s4.y)]);
      _colors.addAll([color,color,color,color]);
      _indicies.addAll([bbb + 0, bbb + 1, bbb + 2]);
      _indicies.addAll([bbb + 0, bbb + 2, bbb + 3]);
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
      int bbb = _vertices.length;

      //
      s.x = cx;
      s.y = cy;
      s.z = flZ;
      s = m * s;
      _vertices.addAll([new Point(s.x, s.y)]);
      _colors.add(c);

      //
      s.x = cx + circleCash[i*2] * a;
      s.y = cy + circleCash[i*2+1] * b;
      s.z = flZ;
      s = m * s;
      _vertices.addAll([new Point(s.x, s.y)]);
      _colors.add(c);

      //
      s.x = cx + circleCash[i*2+2] * a;
      s.y = cy + circleCash[i*2+3] * b;
      s.z = flZ;
      s = m * s;
      _vertices.addAll([new Point(s.x, s.y)]);
      _colors.add(c);
//      textureCoordinates.addAll([new Point(-1.0, -1.0),

      _indicies.addAll([bbb + 0, bbb + 1, bbb + 2]);

      flZ += 0.0001;
    }

  }

  Vector3 v1 = new Vector3(0.0, 0.0, 0.0);
  Vector3 v2 = new Vector3(0.0, 0.0, 0.0);
  Vector3 v3 = new Vector3(0.0, 0.0, 0.0);
  Vector3 v4 = new Vector3(0.0, 0.0, 0.0);
  void drawLine(TinyStage stage, TinyPoint p1, TinyPoint p2, TinyPaint paint, {List<Object>cache:null}) {
    if (curImage != null) {
      flush();
    }
    int bi = _vertices.length;
    Matrix4 m = calcMat();
    double d = math.sqrt(math.pow(p1.x-p2.x, 2)+ math.pow(p1.y-p2.y, 2));
    double dy = -1*paint.strokeWidth*(p2.x-p1.x)/(d*2);
    double dx = paint.strokeWidth*(p2.y-p1.y)/(d*2);
    double sx = p1.x;
    double sy = p1.y;
    double ex = p2.x;
    double ey = p2.y;

    v1.x= sx-dx; v1.y =sy-dy; v1.z =0.0;
    v2.x= sx+dx; v2.y=sy+dy;v2.z= 0.0;
    v3.x=ex+dx; v3.y=ey+dy; v3.z=0.0;
    v4.x=ex-dx;v4.y=ey-dy;v4.z=0.0;
    v1 = m * v1;
    v2 = m * v2;
    v3 = m * v3;
    v4 = m * v4;
    _vertices.addAll([
      new Point(v1.x, v1.y),
      new Point(v2.x, v2.y),
      new Point(v3.x, v3.y),
      new Point(v4.x, v4.y)
    ]);
    Color c = new Color.fromARGB(paint.color.a,paint.color.r,paint.color.g,paint.color.b);
    _colors.addAll([c, c, c, c]);
    _indicies.addAll([bi + 0, bi + 1, bi + 2, bi + 0, bi + 2, bi + 3]);
  }

  void drawRect(TinyStage stage, TinyRect rect, TinyPaint paint, {List<Object>cache:null}) {
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
    drawLine(stage, new TinyPoint(sx+dx, ey), new TinyPoint(ex-dx, ey), paint);
    drawLine(stage, new TinyPoint(ex, sy-dx), new TinyPoint(ex, ey+dx), paint);
    drawLine(stage, new TinyPoint(sx+dx, sy), new TinyPoint(ex-dx, sy), paint);
  }


  void drawFillRect(TinyStage stage, TinyRect rect, TinyPaint paint) {
    if (curImage != null) {
      flush();
    }
    int bi = _vertices.length;
    Matrix4 m = calcMat();
    Vector3 v1 = new Vector3(rect.x, rect.y, 0.0);
    Vector3 v2 = new Vector3(rect.x, rect.y + rect.h, 0.0);
    Vector3 v3 = new Vector3(rect.x + rect.w, rect.y + rect.h, 0.0);
    Vector3 v4 = new Vector3(rect.x + rect.w, rect.y, 0.0);
    v1 = m * v1;
    v2 = m * v2;
    v3 = m * v3;
    v4 = m * v4;
    _vertices.addAll([
      new Point(v1.x, v1.y),
      new Point(v2.x, v2.y),
      new Point(v3.x, v3.y),
      new Point(v4.x, v4.y)
    ]);
    Color c = new Color.fromARGB(paint.color.a,paint.color.r,paint.color.g,paint.color.b);
    _colors.addAll([c, c, c, c]);
    _indicies.addAll([bi + 0, bi + 1, bi + 2, bi + 0, bi + 2, bi + 3]);
  }

  void clearClip(TinyStage stage, {List<Object>cache:null}) {
    flush();
    canvas.restore();
    canvas.save();
  }

  void clipRect(TinyStage stage, TinyRect rect) {
    flush();
    Matrix4 m = calcMat();
    Vector3 v1 = new Vector3(rect.x, rect.y, 0.0);
    Vector3 v2 = new Vector3(rect.x, rect.y + rect.h, 0.0);
    Vector3 v3 = new Vector3(rect.x +rect.w, rect.y + rect.h, 0.0);
    Vector3 v4 = new Vector3(rect.x +rect.w, rect.y, 0.0);
    v1 = m * v1;
    v2 = m * v2;
    v3 = m * v3;
    v4 = m * v4;
    Path path = new Path();
    path.moveTo(v1.x, v1.y);
    path.lineTo(v2.x, v2.y);
    path.lineTo(v3.x, v3.y);
    path.lineTo(v4.x, v4.y);
    canvas.clipPath(path);
//    canvas.clipRect(new Rect.fromLTRB(v1.x, v1.y, v2.x, v2.y));
  }

  clear() {
    canvas.save();
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
    canvas.drawVertices(sky.VertexMode.triangles, _vertices, _textureCoordinates,
        _colors, sky.TransferMode.color, _indicies, p);
    _vertices.clear();
    _textureCoordinates.clear();
    _colors.clear();
    _indicies.clear();
    curImage = null;
  }

  TinyImage curImage = null;
  void drawImageRect(TinyStage stage, TinyImage image, TinyRect src,
      TinyRect dst, TinyPaint paint,{TinyCanvasTransform transform:TinyCanvasTransform.NONE, List<Object>cache:null}) {

        if(curImage == null && _indicies.length > 0) {
          flush();
        }

        if(curImage == null) {
          curImage = image;
        }
        if(curImage != null && curImage != image) {
          flush();
        }
        int bi = _vertices.length;
        List primiveVertics = null;
        List primitveColors = null;
        List primitveTexInf = null;


        Matrix4 m = this.getMatrix();
        v1.x= dst.x; v1.y =dst.y; v1.z =0.0;
        v2.x= dst.x; v2.y=dst.y + dst.h;v2.z= 0.0;
        v3.x=dst.x + dst.w; v3.y=dst.y; v3.z=0.0;
        v4.x=dst.x + dst.w; v4.y=dst.y + dst.h;v4.z=0.0;

        v1 = m * v1;
        v2 = m * v2;
        v3 = m * v3;
        v4 = m * v4;
        primiveVertics = [
          new Point(v1.x, v1.y),
          new Point(v2.x, v2.y),
          new Point(v3.x, v3.y),
          new Point(v4.x, v4.y)
        ];
        Color c = new Color.fromARGB(0x00, 0x00, 0x00, 0x00);
        primitveColors = [c,c,c,c];

        {
          double xs = src.x;
          double ys = src.y;
          double xe = src.x+src.w;
          double ye = src.y+src.h;
          switch(transform) {
            case TinyCanvasTransform.NONE:
              primitveTexInf =
                [new Point(xs, ys),new Point(xs, ye),
                 new Point(xe, ys),new Point(xe, ye)];
            break;
            case TinyCanvasTransform.ROT90:
              primitveTexInf =
              [new Point(xs, ye),new Point(xe, ye),
               new Point(xs, ys),new Point(xe, ys)];
            break;
            case TinyCanvasTransform.ROT180:
              primitveTexInf =
              [new Point(xe, ye),new Point(xe, ys),
               new Point(xs, ye),new Point(xs, ys)];
            break;
            case TinyCanvasTransform.ROT270:
              primitveTexInf =
              [new Point(xe, ys),new Point(xs, ys),
               new Point(xe, ye),new Point(xs, ye)];
            break;
            case TinyCanvasTransform.MIRROR:
              primitveTexInf =
              [new Point(xe, ys),new Point(xe, ye),
               new Point(xs, ys),new Point(xs, ye)];
            break;
            case TinyCanvasTransform.MIRROR_ROT90:
              primitveTexInf =
              [new Point(xs, ys),new Point(xe, ys),
               new Point(xs, ye),new Point(xe, ye)];
            break;
            case TinyCanvasTransform.MIRROR_ROT180:
              primitveTexInf =
              [new Point(xs, ye),new Point(xs, ys),
               new Point(xe, ye),new Point(xe, ys)];
            break;
            case TinyCanvasTransform.MIRROR_ROT270:
              primitveTexInf =
              [new Point(xe, ye),new Point(xs, ye),
               new Point(xe, ys),new Point(xs, ys)];
            break;
            default:
              primitveTexInf =
                [new Point(xs, ys),new Point(xs, ye),
                 new Point(xe, ys),new Point(xe, ye)];
          }
        }
        _vertices.addAll(primiveVertics);
        _colors.addAll(primitveColors);
        _textureCoordinates.addAll(primitveTexInf);
        _indicies.addAll([bi+0,bi+1,bi+2, bi+2,bi+1,bi+3]);
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
