part of tinygame_webgl;

class TinyWebglCanvasTS extends TinyCanvas {
  RenderingContext GL;
  TinyWebglContext glContext;
  TinyWebglCanvasTS(TinyWebglContext c) {
    GL = c.GL;
    glContext = c;
    init();
    clear();
  }
  Program programShape;

  void init() {
    print(
        "#[A]# ${GL.getParameter(RenderingContext.MAX_VERTEX_TEXTURE_IMAGE_UNITS)}");
    print(
        "#[B]# ${GL.getParameter(RenderingContext.ALIASED_POINT_SIZE_RANGE)}");
    {
      String vs = [
        "attribute vec3 vp;",
        "attribute vec4 color;",
        "attribute float useTex;",
        "varying float v_useTex;",
        "attribute vec2 a_tex;",
        "varying vec2 v_tex;",
        "uniform mat4 u_mat;",
        "varying vec4 vColor;",
        "",
        "void main() {",
        "  v_useTex = useTex;"
            "  gl_Position = u_mat*vec4(vp.x,vp.y,vp.z,1.0);",
        "  if(useTex < 0.0){",
        "    vColor = color;",
        "  }",
        "  else {",
        "    vColor = vec4(0.0,0.0,0.0,1.0);",
        "    v_tex = a_tex;",
        "  }",
        "  gl_PointSize = 1.0;//u_point_size;",
        "",
        "}"
      ].join("\n");
      String fs = [
        "precision mediump float;",
        "varying vec2 v_tex;",
        "varying vec4 vColor;",
        "varying float v_useTex;",
        "uniform sampler2D u_image;",
        "void main() {",
        "  if(v_useTex < 0.0){",
        "    gl_FragColor = vColor;",
        "  }",
        "  else {",
        "    gl_FragColor = texture2D(u_image, v_tex);",
        "  }",
        "}"
      ].join("\n");
      programShape = TinyWebglProgram.compile(GL, vs, fs);
    }
  }

  int stencilV = 1;
  List<double> flVert = [];
  List<int> flInde = [];
  List<double> flTex = [];
  TinyWebglImage flImg = null;
  double flZ = 0.0;
  void clear() {
    stencilV = 1;
    flZ = -0.5;
    double r = 0.0;
    double g = 0.0;
    double b = 0.0;
    double a = 1.0;
    // GL.enable(RenderingContext.DEPTH_TEST);
    GL.enable(RenderingContext.STENCIL_TEST);
    GL.depthFunc(RenderingContext.LEQUAL);
    GL.clearColor(r, g, b, a);
    GL.clearDepth(1.0);
    GL.clearStencil(0);
    GL.enable(RenderingContext.BLEND);
    blendMode(-1);
    GL.clear(RenderingContext.COLOR_BUFFER_BIT |
        RenderingContext.STENCIL_BUFFER_BIT |
        RenderingContext.DEPTH_BUFFER_BIT);
    flVert.clear();
    flInde.clear();
    flTex.clear();
    flImg = null;
  }

  void flush() {
    if (flVert.length != 0) {
      drawVertex(flVert, flInde, new TinyColor.argb(0xaa, 0xff, 0xaa, 0xaa));
      flVert.clear();
      flInde.clear();
      flTex.clear();
      flImg = null;
    }
  }
  void drawOval(TinyStage stage, TinyRect rect, TinyPaint paint) {
    if (paint.style == TinyPaintStyle.fill) {
      drawFillOval(stage, rect, paint);
    } else {
      drawStrokeOval(stage, rect, paint);
    }
  }

  void drawFillOval(TinyStage stage, TinyRect rect, TinyPaint paint) {
    double cx = rect.x + rect.w / 2.0;
    double cy = rect.y + rect.h / 2.0;
    double a = rect.w / 2;
    double b = rect.h / 2;
    int num = 25;

    Matrix4 m = calcMat();
    Vector3 s = new Vector3(0.0, 0.0, 0.0);
    double colorR = paint.color.r / 0xff;
    double colorG = paint.color.g / 0xff;
    double colorB = paint.color.b / 0xff;
    double colorA = paint.color.a / 0xff;
    for (int i = 0; i < num; i++) {
      //
      int bbb = flVert.length ~/ 8;

      //
      s.x = cx;
      s.y = cy;
      s.z = flZ;
      s = m * s;
      flVert.addAll([s.x, s.y, flZ]);
      flVert.addAll([colorR, colorG, colorB, colorA]);
      flVert.addAll([-1.0]);
      flTex.addAll([0.0, 0.0]);
      //
      s.x = cx + math.cos(2 * math.PI * (i / num)) * a;
      s.y = cy + math.sin(2 * math.PI * (i / num)) * b;
      s.z = flZ;
      s = m * s;
      flVert.addAll([s.x, s.y, flZ]);
      flVert.addAll([colorR, colorG, colorB, colorA]);
      flVert.addAll([-1.0]);
      flTex.addAll([0.0, 0.0]);

      //
      s.x = cx + math.cos(2 * math.PI * ((i + 1) / num)) * a;
      s.y = cy + math.sin(2 * math.PI * ((i + 1) / num)) * b;
      s.z = flZ;
      s = m * s;
      flVert.addAll([s.x, s.y, flZ]);
      flVert.addAll([colorR, colorG, colorB, colorA]);
      flVert.addAll([-1.0]);
      flTex.addAll([0.0, 0.0]);

      flInde.addAll([bbb + 0, bbb + 1, bbb + 2]);

      flZ += 0.0001;
    }
  }

  void drawStrokeOval(TinyStage stage, TinyRect rect, TinyPaint paint) {
    double cx = rect.x + rect.w / 2.0;
    double cy = rect.y + rect.h / 2.0;
    double a = (rect.w+paint.strokeWidth) / 2;
    double b = (rect.h+paint.strokeWidth) / 2;
    double c = rect.w / 2;
    double d = rect.h / 2;
    int num = 25;

    Matrix4 m = calcMat();
    Vector3 s1 = new Vector3(0.0, 0.0, 0.0);
    Vector3 s2 = new Vector3(0.0, 0.0, 0.0);
    Vector3 s3 = new Vector3(0.0, 0.0, 0.0);
    Vector3 s4 = new Vector3(0.0, 0.0, 0.0);
    double colorR = paint.color.r / 0xff;
    double colorG = paint.color.g / 0xff;
    double colorB = paint.color.b / 0xff;
    double colorA = paint.color.a / 0xff;
    for (int i = 0; i < num; i++) {
      //
      int bbb = flVert.length ~/ 8;

      //
      s1.x = cx + math.cos(2 * math.PI * (i / num)) * c;
      s1.y = cy + math.sin(2 * math.PI * (i / num)) * d;
      s1.z = flZ;
      s1 = m * s1;
      
      s2.x = cx + math.cos(2 * math.PI * (i / num)) * a;
      s2.y = cy + math.sin(2 * math.PI * (i / num)) * b;
      s2.z = flZ;
      s2 = m * s2;

      s3.x = cx + math.cos(2 * math.PI * ((i + 1) / num)) * a;
      s3.y = cy + math.sin(2 * math.PI * ((i + 1) / num)) * b;
      s3.z = flZ;
      s3 = m * s3;

      s4.x = cx + math.cos(2 * math.PI * ((i + 1) / num)) * c;
      s4.y = cy + math.sin(2 * math.PI * ((i + 1) / num)) * d;
      s4.z = flZ;
      s4 = m * s4;
      _innerDrawFillRect(stage, s1, s2, s4, s3, colorR, colorG, colorB, colorA);

      flZ += 0.0001;
    }
  }
  void drawRect(TinyStage stage, TinyRect rect, TinyPaint paint) {
    if (paint.style == TinyPaintStyle.fill) {
      drawFillRect(stage, rect, paint);
    } else {
      drawStrokeRect(stage, rect, paint);
    }
  }
  void drawFillRect(TinyStage stage, TinyRect rect, TinyPaint paint) {
    Matrix4 m = calcMat();
    double sx = rect.x;
    double sy = rect.y;
    double ex = rect.x + rect.w;
    double ey = rect.y + rect.h;
    Vector3 ss1 = m * new Vector3(sx, sy, 0.0);
    Vector3 ss2 = m * new Vector3(sx, ey, 0.0);
    Vector3 ss3 = m * new Vector3(ex, sy, 0.0);
    Vector3 ss4 = m * new Vector3(ex, ey, 0.0);

    double colorR = paint.color.r / 0xff;
    double colorG = paint.color.g / 0xff;
    double colorB = paint.color.b / 0xff;
    double colorA = paint.color.a / 0xff;
    _innerDrawFillRect(stage, ss1, ss2, ss3, ss4, colorR, colorG, colorB, colorA);
  }

  void _innerDrawFillRect(
       TinyStage stage, 
       Vector3 ss1, Vector3 ss2,Vector3 ss3,Vector3 ss4,
       double colorR, double colorG, double colorB, double colorA) {
    int b = flVert.length ~/ 8;
    flVert.addAll([
      ss1.x, ss1.y, flZ, // 7
      colorR, colorG, colorB, colorA, // color
      -1.0,
      ss2.x, ss2.y, flZ, // 1
      colorR, colorG, colorB, colorA, // color
      -1.0,
      ss3.x, ss3.y, flZ, // 9
      colorR, colorG, colorB, colorA, // color
      -1.0,
      ss4.x, ss4.y, flZ, //3
      colorR, colorG, colorB, colorA, // color
      -1.0
    ]);
    flTex.addAll([0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]);
    flZ += 0.0001;
    flInde.addAll([b + 0, b + 1, b + 2, b + 1, b + 3, b + 2]);
  }

  void drawStrokeRect(TinyStage stage, TinyRect rect, TinyPaint paint) {
    Matrix4 m = calcMat();
    double sx = rect.x;
    double sy = rect.y;
    double ex = rect.x + rect.w;
    double ey = rect.y + rect.h;

    Vector3 ss1 = m * new Vector3(sx, sy, 0.0);
    Vector3 sz1 = m * new Vector3(sx-paint.strokeWidth, sy-paint.strokeWidth, 0.0);
    Vector3 ss2 = m * new Vector3(sx, ey, 0.0);
    Vector3 sz2 = m * new Vector3(sx-paint.strokeWidth, ey+paint.strokeWidth, 0.0);
    Vector3 ss3 = m * new Vector3(ex, sy, 0.0);
    Vector3 sz3 = m * new Vector3(ex+paint.strokeWidth, sy-paint.strokeWidth, 0.0);
    Vector3 ss4 = m * new Vector3(ex, ey, 0.0);
    Vector3 sz4 = m * new Vector3(ex+paint.strokeWidth, ey+paint.strokeWidth, 0.0);
    int b = flVert.length ~/ 8;
    double colorR = paint.color.r / 0xff;
    double colorG = paint.color.g / 0xff;
    double colorB = paint.color.b / 0xff;
    double colorA = paint.color.a / 0xff;
    _innerDrawFillRect(stage, sz1, sz2, ss1, ss2, colorR, colorG, colorB, colorA);
    _innerDrawFillRect(stage, sz2, sz4, ss2, ss4, colorR, colorG, colorB, colorA);
    _innerDrawFillRect(stage, sz4, sz3, ss4, ss3, colorR, colorG, colorB, colorA);
    _innerDrawFillRect(stage, sz3, sz1, ss3, ss1, colorR, colorG, colorB, colorA);
  }

  Matrix4 baseMat = new Matrix4.identity();
  void drawVertex(List<double> svertex, List<int> index, TinyColor color) {
    //
    //
    GL.useProgram(programShape);
    int texLocation = 0;

      
      texLocation = GL.getAttribLocation(programShape, "a_tex");
      Buffer texBuffer = GL.createBuffer();
      GL.bindBuffer(RenderingContext.ARRAY_BUFFER, texBuffer);

      GL.bufferData(RenderingContext.ARRAY_BUFFER,
          new Float32List.fromList(flTex), RenderingContext.STATIC_DRAW);
      GL.enableVertexAttribArray(texLocation);

      GL.vertexAttribPointer(
          texLocation, 2, RenderingContext.FLOAT, false, 0, 0);
      if (flImg != null) {
      {
        Texture tex = flImg.getTex(GL);
        GL.bindTexture(RenderingContext.TEXTURE_2D, tex);

        GL.texParameteri(RenderingContext.TEXTURE_2D,
            RenderingContext.TEXTURE_WRAP_S, RenderingContext.CLAMP_TO_EDGE);
        GL.texParameteri(RenderingContext.TEXTURE_2D,
            RenderingContext.TEXTURE_WRAP_T, RenderingContext.CLAMP_TO_EDGE);
        GL.texParameteri(RenderingContext.TEXTURE_2D,
            RenderingContext.TEXTURE_MIN_FILTER, RenderingContext.NEAREST);
        GL.texParameteri(RenderingContext.TEXTURE_2D,
            RenderingContext.TEXTURE_MAG_FILTER, RenderingContext.NEAREST);
      }
    }
    //
    // vertex
    Buffer rectBuffer = TinyWebglProgram.createArrayBuffer(GL, svertex);
    GL.bindBuffer(RenderingContext.ARRAY_BUFFER, rectBuffer);

    Buffer rectIndexBuffer =
        TinyWebglProgram.createElementArrayBuffer(GL, index);
    GL.bindBuffer(RenderingContext.ELEMENT_ARRAY_BUFFER, rectIndexBuffer);

    //

    //
    // draw
    int locationAttributeUseTex;
    {
      TinyWebglProgram.setUniformMat4(GL, programShape, "u_mat", baseMat);
      int colorAttribLocation = GL.getAttribLocation(programShape, "color");
      int locationVertexPosition = GL.getAttribLocation(programShape, "vp");
      locationAttributeUseTex = GL.getAttribLocation(programShape, "useTex");

      GL.vertexAttribPointer(
          locationVertexPosition, 3, RenderingContext.FLOAT, false, 4 * 8, 0);
      GL.vertexAttribPointer(
          colorAttribLocation, 4, RenderingContext.FLOAT, false, 4 * 8, 4 * 3);
      GL.vertexAttribPointer(locationAttributeUseTex, 1, RenderingContext.FLOAT,
          false, 4 * 8, 4 * 7);
      GL.enableVertexAttribArray(locationVertexPosition);
      GL.enableVertexAttribArray(colorAttribLocation);
      GL.enableVertexAttribArray(locationAttributeUseTex);
      GL.drawElements(
          RenderingContext.TRIANGLES,
          //RenderingContext.LINE_STRIP,
          index.length, //svertex.length ~/ 3,
          RenderingContext.UNSIGNED_SHORT,
          0);
    }
    if(texLocation != 0) {
      GL.disableVertexAttribArray(texLocation);
      GL.bindTexture(RenderingContext.TEXTURE_2D, null);
    }
    GL.useProgram(null);
  }

  void drawLine(TinyStage stage, TinyPoint p1, TinyPoint p2, TinyPaint paint) {}

  void clipRect(TinyStage stage, TinyRect rect) {
    flush();
    GL.colorMask(false, false, false, false);
    GL.depthMask(false);
    GL.stencilOp(RenderingContext.KEEP, RenderingContext.REPLACE,
        RenderingContext.REPLACE);
    GL.stencilFunc(RenderingContext.ALWAYS, stencilV, 0xff);

    //

    TinyPaint p = new TinyPaint();
    p.color = new TinyColor.argb(0xff, 0xff, 0xff, 0xff);
    drawRect(null, rect, p);
    flush();
    //

    // GL.disable(RenderingContext.STENCIL_TEST);
    //
    GL.colorMask(true, true, true, true);
    GL.depthMask(true);
    GL.stencilOp(
        RenderingContext.KEEP, RenderingContext.KEEP, RenderingContext.KEEP);
    // todo
    GL.stencilFunc(RenderingContext.LEQUAL, stencilV, 0xff);
    stencilV++;

  }

  //bool a = false;
  void drawImageRect(TinyStage stage, TinyImage image, TinyRect src,
      TinyRect dst, TinyPaint paint) {
    //flush();
    //
    //
    if (flImg != null && flImg != image) {
      flush();
    }

    //if(flImg == null) {
    flImg = image;
    //}

    double xs = src.x / flImg.w;
    double ys = src.y / flImg.h;
    double xe = (src.x + src.w) / flImg.w;
    double ye = (src.y + src.h) / flImg.h;
    flTex.addAll([xs, ys, xs, ye, xe, ys, xe, ye]);

    //
    //
    //
    Matrix4 m = calcMat();
    double sx = dst.x;
    double sy = dst.y;
    double ex = dst.x + dst.w;
    double ey = dst.y + dst.h;

    Vector3 ss1 = m * new Vector3(sx, sy, 0.0);
    Vector3 ss2 = m * new Vector3(sx, ey, 0.0);
    Vector3 ss3 = m * new Vector3(ex, sy, 0.0);
    Vector3 ss4 = m * new Vector3(ex, ey, 0.0);

    int b = flVert.length ~/ 8;
    double colorR = paint.color.r / 0xff;
    double colorG = paint.color.g / 0xff;
    double colorB = paint.color.b / 0xff;
    double colorA = paint.color.a / 0xff;
    flVert.addAll([
      ss1.x, ss1.y, flZ, // 7
      colorR, colorG, colorB, colorA, // color
      1.0,
      ss2.x, ss2.y, flZ, // 1
      colorR, colorG, colorB, colorA, // color
      1.0,
      ss3.x, ss3.y, flZ, // 9
      colorR, colorG, colorB, colorA, // color
      1.0,
      ss4.x, ss4.y, flZ, //3
      colorR, colorG, colorB, colorA, // color
      1.0
    ]);
    flZ += 0.0001;
    //b= 0;
    flInde.addAll([b + 0, b + 1, b + 2, b + 1, b + 3, b + 2]);
  }

  void updateMatrix() {}

  blendMode(int type) {
    // http://masuqat.net/programming/csharp/OpenTK01-09.php
    switch (type) {
      case -1:
        GL.blendEquation(RenderingContext.FUNC_ADD);
        GL.blendFuncSeparate(
            RenderingContext.SRC_ALPHA,
            RenderingContext.ONE_MINUS_SRC_ALPHA,
            RenderingContext.SRC_ALPHA,
            RenderingContext.ONE_MINUS_CONSTANT_ALPHA);
        break;
      case 0: //none
        GL.blendEquation(RenderingContext.FUNC_ADD);
        GL.blendFunc(RenderingContext.ONE, RenderingContext.ZERO);
        break;
      case 1: // semi transparent
        GL.blendEquation(RenderingContext.FUNC_ADD);
        GL.blendFunc(
            RenderingContext.SRC_ALPHA, RenderingContext.ONE_MINUS_SRC_ALPHA);
        break;
      case 2: //add
        GL.blendEquation(RenderingContext.FUNC_ADD);
        GL.blendFunc(RenderingContext.SRC_ALPHA, RenderingContext.ONE);
        break;
      case 3: //sub
        GL.blendEquation(RenderingContext.FUNC_REVERSE_SUBTRACT);
        GL.blendFunc(RenderingContext.SRC_ALPHA, RenderingContext.ONE);
        break;
      case 4: //product
        GL.blendEquation(RenderingContext.FUNC_ADD);
        GL.blendFunc(RenderingContext.ZERO, RenderingContext.SRC_COLOR);
        break;
      case 5: //reverse
        GL.blendEquation(RenderingContext.FUNC_ADD);
        GL.blendFunc(
            RenderingContext.ONE_MINUS_DST_COLOR, RenderingContext.ZERO);
        break;
    }
  }

  Matrix4 cacheMatrix = new Matrix4.identity();
  Matrix4 calcMat() {
    cacheMatrix.setIdentity();
    cacheMatrix = cacheMatrix.translate(-1.0, 1.0, 0.0);
    cacheMatrix =
        cacheMatrix.scale(2.0 / glContext.widht, -2.0 / glContext.height, 1.0);
    cacheMatrix = cacheMatrix * getMatrix();
    return cacheMatrix;
  }
}
