part of tinygame_webgl;


class TinyWebglContext {
  RenderingContext GL;
  CanvasElement _canvasElement;
  CanvasElement get canvasElement => _canvasElement;
  double widht;
  double height;
  TinyWebglContext({width: 600.0, height: 400.0}) {
    this.widht = width;
    this.height = height;
    _canvasElement = //new CanvasElement(width: 500, height: 500);//
        new CanvasElement(width: widht.toInt(), height: height.toInt());
    document.body.append(_canvasElement);
    GL = _canvasElement.getContext3d(stencil: true);
  }
}

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
    print("#[A]# ${GL.getParameter(RenderingContext.MAX_VERTEX_TEXTURE_IMAGE_UNITS)}");
    print("#[B]# ${GL.getParameter(RenderingContext.ALIASED_POINT_SIZE_RANGE)}");
    {
      String vs = [
        "attribute vec3 vp;",
        "attribute vec4 color;",
        "uniform mat4 u_mat;",
        "varying float v_mode;",
        "varying vec4 vColor;",
        "",
        "void main() {",
        "  gl_Position = u_mat*vec4(vp.x,vp.y,vp.z,1.0);",
        "  vColor = color;",
        "  gl_PointSize = 1.0;//u_point_size;",
        "}"
      ].join("\n");
      String fs = [
        "precision mediump float;",
        "varying vec4 vColor;",
        "void main() {",
        " gl_FragColor = vColor;",
        "}"
      ].join("\n");
      programShape = TinyWebglProgram.compile(GL, vs, fs);
    }
  }

  int stencilV = 1;
  List<double> flVert = [];
  List<int> flInde = [];
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
  }

  void flush() {
    if(flVert.length != 0) {
      drawVertex(flVert,flInde, new TinyColor.argb(0xaa, 0xff, 0xaa, 0xaa));
    }
  }


  void drawRect(TinyStage stage, TinyRect rect, TinyPaint paint) {
    Matrix4 m = calcMat();
    double sx = rect.x;
    double sy = rect.y;
    Vector3 s = m * new Vector3(sx, sy, 0.0);
    double ex = rect.x + rect.w;
    double ey = rect.y + rect.h;
    Vector3 e = m * new Vector3(ex, ey, 0.0);
    int b = flVert.length~/7;
    double colorR = paint.color.r/0xff;
    double colorG = paint.color.g/0xff;
    double colorB = paint.color.b/0xff;
    double colorA = paint.color.a/0xff;
    flVert.addAll([
      s.x, s.y, flZ, // 7
      colorR, colorG, colorB, colorA,// color
      s.x, e.y, flZ, // 1
      colorR, colorG, colorB, colorA,// color
      e.x, s.y, flZ, // 9
      colorR, colorG, colorB, colorA,// color
      e.x, e.y, flZ, //3
      colorR, colorG, colorB, colorA// color
      ]);
    flZ +=0.0001;
    //b= 0;
    flInde.addAll([
       b+0, b+1, b+2, 
       b+1, b+3, b+2]);
  }



  Matrix4 baseMat = new Matrix4.identity();
  void drawVertex(List<double> svertex, List<int> index, TinyColor color) {
    //
    //
    GL.useProgram(programShape);

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
    {
      TinyWebglProgram.setUniformMat4(GL, programShape, "u_mat", baseMat);
      int colorAttribLocation  = GL.getAttribLocation(programShape, "color");
      int locationVertexPosition = GL.getAttribLocation(programShape, "vp");
      GL.vertexAttribPointer(
          locationVertexPosition, 3, RenderingContext.FLOAT, false, 4*7, 0);
      GL.vertexAttribPointer(
          colorAttribLocation, 4, RenderingContext.FLOAT, false, 4*7, 4*3);
      GL.enableVertexAttribArray(locationVertexPosition);
      GL.enableVertexAttribArray(colorAttribLocation);
      GL.drawElements(
          RenderingContext.TRIANGLES,
          //RenderingContext.LINE_STRIP,
          index.length,//svertex.length ~/ 3, 
          RenderingContext.UNSIGNED_SHORT, 0);
    }
 
    GL.useProgram(null);
  }

  void drawLine(TinyStage stage, TinyPoint p1, TinyPoint p2, TinyPaint paint) {
  }

  void drawOval(TinyStage stage, TinyRect rect, TinyPaint paint) {
  }

  void clipRect(TinyStage stage, TinyRect rect) {
    
  }

  //bool a = false;
  void drawImageRect(TinyStage stage, TinyImage image, TinyRect src,
      TinyRect dst, TinyPaint paint) {
 
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












//
///
//

class TinyWebglCanvas extends TinyCanvas {
  RenderingContext GL;
  TinyWebglContext glContext;
  TinyWebglCanvas(TinyWebglContext c) {
    GL = c.GL;
    glContext = c;
    init();
    clear();
  }
  Program programShape;
  Program programImage;
  
  void flush() {
    
  }
  void init() {
    {
      String vs = [
        "attribute vec3 vp;",
        "uniform mat4 u_mat;",
        "uniform float u_point_size;",
        "varying float v_mode;",
        "void main() {",
        "  gl_Position = u_mat*vec4(vp.x,vp.y,vp.z,1.0);",
        "  gl_PointSize = 1.0;//u_point_size;",
        "}"
      ].join("\n");
      String fs = [
        "precision mediump float;",
        "uniform vec4 color;",
        //"varying vec4 v_mode;",
        "void main() {",
        " gl_FragColor = color;",
        "}"
      ].join("\n");
      programShape = TinyWebglProgram.compile(GL, vs, fs);
    }
    {
      String vs = [
        "attribute vec3 vp;",
        "uniform mat4 u_mat;",
        "attribute vec2 a_tex;",
        "varying vec2 v_tex;",
        "void main() {",
        "  gl_Position = u_mat*vec4(vp.x,vp.y,vp.z,1.0);",
        "  v_tex = a_tex;",
        "}"
      ].join("\n");
      String fs = [
        "precision mediump float;",
        "varying vec2 v_tex;",
        "uniform sampler2D u_image;",
        "uniform vec4 color;",
        "void main() {",
        " gl_FragColor = texture2D(u_image, v_tex);",
        "}"
      ].join("\n");
      programImage = TinyWebglProgram.compile(GL, vs, fs);
    }
  }

  int stencilV = 1;
  void clear() {
    stencilV = 1;
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
  }

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

  void drawRect(TinyStage stage, TinyRect rect, TinyPaint paint) {
    double sx = rect.x;
    double sy = rect.y;
    double ex = rect.x + rect.w;
    double ey = rect.y + rect.h;
    drawVertex(stage, [sx, sy, 0.0, sx, ey, 0.0, ex, sy, 0.0, ex, ey, 0.0],
        [0, 1, 3, 2], paint.color, paint.style, paint.strokeWidth);
  }

  void drawLine(TinyStage stage, TinyPoint p1, TinyPoint p2, TinyPaint paint) {
    drawVertex(stage, [p1.x, p1.y, 0.0, p2.x, p2.y, 0.0], [0, 1], paint.color,
        TinyPaintStyle.stroke, paint.strokeWidth);
  }

  void drawOval(TinyStage stage, TinyRect rect, TinyPaint paint) {
    double cx = rect.x + rect.w / 2.0;
    double cy = rect.y + rect.h / 2.0;
    double a = rect.w / 2;
    double b = rect.h / 2;
    List<double> ver = [];
    List<int> ind = [];
    int num = 50;
    for (int i = 0; i < num; i++) {
      ind.add(i);
      ver.add(cx + math.cos(2 * math.PI * (i / num)) * a);
      ver.add(cy + math.sin(2 * math.PI * (i / num)) * b);
      ver.add(0.0);
    }
    //print("${a} ${b} ${ind} ${ver}");
    drawVertex(stage, ver, ind, paint.color, paint.style, paint.strokeWidth);
  }

  void drawVertex(TinyStage stage, List<double> svertex, List<int> index,
      TinyColor color, TinyPaintStyle style, double strokeWidth) {
    //print("---drawRect");
    //
    //
    GL.useProgram(programShape);

    //
    // vertex
    //

    Buffer rectBuffer = TinyWebglProgram.createArrayBuffer(GL, svertex);
    GL.bindBuffer(RenderingContext.ARRAY_BUFFER, rectBuffer);

    Buffer rectIndexBuffer =
        TinyWebglProgram.createElementArrayBuffer(GL, index);
    GL.bindBuffer(RenderingContext.ELEMENT_ARRAY_BUFFER, rectIndexBuffer);

    //
    // draw
    {
      //print("${GL.getParameter(RenderingContext.ALIASED_POINT_SIZE_RANGE)}");

      TinyWebglProgram.setUniformMat4(GL, programShape, "u_mat", calcMat());
      TinyWebglProgram.setUniformVec4(
          GL, programShape, "color", [color.rf, color.gf, color.bf, color.af]);
      TinyWebglProgram.setUniformF(
          GL, programShape, "u_point_size", strokeWidth);

      int locationVertexPosition = GL.getAttribLocation(programShape, "vp");
      GL.vertexAttribPointer(
          locationVertexPosition, 3, RenderingContext.FLOAT, false, 0, 0);
      GL.enableVertexAttribArray(locationVertexPosition);

      int mode = RenderingContext.TRIANGLE_FAN;
      if (style == TinyPaintStyle.fill) {
        mode = RenderingContext.TRIANGLE_FAN;
      } else {
        GL.lineWidth(strokeWidth);
        mode = RenderingContext.LINE_LOOP;
      }
      GL.drawElements(
          mode, svertex.length ~/ 3, RenderingContext.UNSIGNED_SHORT, 0);
    }
    GL.useProgram(null);
  }

  void clipRect(TinyStage stage, TinyRect rect) {
    GL.colorMask(false, false, false, false);
    GL.depthMask(false);
    GL.stencilOp(RenderingContext.KEEP, RenderingContext.REPLACE,
        RenderingContext.REPLACE);
    GL.stencilFunc(RenderingContext.ALWAYS, stencilV, 0xff);

    //

    TinyPaint p = new TinyPaint();
    p.color = new TinyColor.argb(0xff, 0xff, 0xff, 0xff);
    drawRect(null, rect, p);
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
    TinyWebglImage img = image;
    //print("---drawImageRect");
    //
    //
    GL.useProgram(programImage);
    int texLocation = GL.getAttribLocation(programImage, "a_tex");
    Buffer texBuffer = GL.createBuffer();
    GL.bindBuffer(RenderingContext.ARRAY_BUFFER, texBuffer);
    double xs = src.x/img.w;
    double ys = src.y/img.h;
    double xe = (src.x+src.w)/img.w;
    double ye = (src.y+src.h)/img.h;

    GL.bufferData(
        RenderingContext.ARRAY_BUFFER,
        new Float32List.fromList([
          xs, ys,
          xs, ye,
          xe, ys,
          xe, ye]),
        RenderingContext.STATIC_DRAW);
    GL.enableVertexAttribArray(texLocation);
    GL.vertexAttribPointer(texLocation, 2, RenderingContext.FLOAT, false, 0, 0);
    //
    //if(a == false) {
    Texture tex = img.getTex(GL);
    GL.bindTexture(RenderingContext.TEXTURE_2D, tex);
    /*GL.createTexture();

    GL.texImage2D(RenderingContext.TEXTURE_2D, 0, RenderingContext.RGBA,
        RenderingContext.RGBA, RenderingContext.UNSIGNED_BYTE, img.elm);
    */
    GL.texParameteri(RenderingContext.TEXTURE_2D,
        RenderingContext.TEXTURE_WRAP_S, RenderingContext.CLAMP_TO_EDGE);
    GL.texParameteri(RenderingContext.TEXTURE_2D,
        RenderingContext.TEXTURE_WRAP_T, RenderingContext.CLAMP_TO_EDGE);
    GL.texParameteri(RenderingContext.TEXTURE_2D,
        RenderingContext.TEXTURE_MIN_FILTER, RenderingContext.NEAREST);
    GL.texParameteri(RenderingContext.TEXTURE_2D,
        RenderingContext.TEXTURE_MAG_FILTER, RenderingContext.NEAREST);

    //0 a = true;
    //}
    //
    //
    double sx = dst.x;
    double sy = dst.y;
    double ex = dst.x + dst.w;
    double ey = dst.y + dst.h;
    Buffer rectBuffer = TinyWebglProgram.createArrayBuffer(
        GL, [sx, sy, 0.0, sx, ey, 0.0, ex, sy, 0.0, ex, ey, 0.0]);
    GL.bindBuffer(RenderingContext.ARRAY_BUFFER, rectBuffer);

    Buffer rectIndexBuffer =
        TinyWebglProgram.createElementArrayBuffer(GL, [0, 1, 2, 1, 3, 2]);
    GL.bindBuffer(RenderingContext.ELEMENT_ARRAY_BUFFER, rectIndexBuffer);

    //
    // draw
    {
      int locationVertexPosition = GL.getAttribLocation(programImage, "vp");
      UniformLocation locationMat =
          GL.getUniformLocation(programImage, "u_mat");
      GL.uniformMatrix4fv(
          locationMat, false, new Float32List.fromList(calcMat().storage));

      GL.vertexAttribPointer(
          locationVertexPosition, 3, RenderingContext.FLOAT, false, 0, 0);
      var colorLocation = GL.getUniformLocation(programImage, "color");
      GL.uniform4f(colorLocation, paint.color.rf, paint.color.gf,
          paint.color.bf, paint.color.af);
      GL.enableVertexAttribArray(locationVertexPosition);

      GL.drawElements(
          RenderingContext.TRIANGLES, 6, RenderingContext.UNSIGNED_SHORT, 0);
    }
  }

  void updateMatrix() {}
}
