part of tinygame_webgl;

class TinyGameBuilderForWebgl extends TinyGameBuilder {
  int width = 600 + 100;
  int height = 400 + 100;
  TinyStage createStage(TinyDisplayObject root) {
    return new TinyWebglStage(this, root);
  }

  Future<TinyImage> loadImageBase(String path) async {
    ImageElement elm = await TinyWebglLoader.loadImage(path);
    return new TinyWebglImage(elm);
  }

  Future<TinyAudioSource> loadAudio(String path) async {
    Completer<TinyAudioSource> c = new Completer();
    AudioContext context = new AudioContext();
    HttpRequest request = new HttpRequest();
    request.open("GET", path);
    request.responseType = "arraybuffer";
    print("---d-1--");
    request.onLoad.listen((ProgressEvent e) async {
      print("---d-2-");
      AudioBuffer buffer = await context.decodeAudioData(request.response);
      c.complete(new TinyWebglAudioSource(context, buffer));
    });
    request.onError.listen((ProgressEvent e) {
      c.completeError(e);
    });
    request.send();
    return c.future;
  }
}

class TinyWebglStage extends Object with TinyStage {
  TinyWebglContext glContext;
  double get x => 0.0;
  double get y => 0.0;
  double get w => glContext.widht;
  double get h => glContext.height;

  double get paddingTop => 0.0;
  double get paddingBottom => 0.0;
  double get paddingRight => 0.0;
  double get paddingLeft => 0.0;

  bool animeIsStart = false;
  int animeId = 0;

  TinyGameBuilder _builder;
  TinyGameBuilder get builder => _builder;

  TinyWebglStage(this._builder, TinyDisplayObject root,
      {width: 600.0, height: 400.0}) {
    glContext = new TinyWebglContext(width: width, height: height);
    this.root = root;
    ttest();
  }

  bool isPaint = false;
  void markNeedsPaint() {
    isPaint = true;
  }

  void init() {}

  void start() {
    if (animeIsStart == false) {
      animeIsStart = true;
      _anime();
    }
  }

  Future _anime() async {
    double sum = 0.0;
    int count = 0;

    num prevTime = new DateTime.now().millisecond;
    TinyWebglCanvas c = new TinyWebglCanvas(glContext);
    while (animeIsStart) {
      await new Future.delayed(new Duration(milliseconds: 30));
      num currentTime = new DateTime.now().millisecondsSinceEpoch;

      num s = (currentTime - prevTime);
      kick((prevTime + s).toInt());
      kick((prevTime + s).toInt());
      sum += s;
      if (s < 0) {}
      count++;
      prevTime = currentTime;
      markNeedsPaint();
      if (isPaint && sum > 40.0) {
        c.clear();
        root.paint(this, c);
        isPaint = false;
      }

      if (count > 60) {
        print("###fps  ${sum~/count}");
        sum = 0.0;
        count = 0;
      }
    }
  }

  void stop() {
    animeIsStart = false;
  }

  void ttest() {
    bool isTap = false;
    glContext.canvasElement.onMouseDown.listen((MouseEvent e) {
      // print("down offset=${e.offsetX}:${e.offsetY}  client=${e.clientX}:${e.clientY} screen=${e.screenX}:${e.screenY}");
      isTap = true;
      root.touch(
          this, 0, "pointerdown", e.offset.x.toDouble(), e.offset.y.toDouble());
    });
    glContext.canvasElement.onMouseUp.listen((MouseEvent e) {
      //print("up offset=${e.offsetX}:${e.offsetY}  client=${e.clientX}:${e.clientY} screen=${e.screenX}:${e.screenY}");
      if (isTap == true) {
        root.touch(
            this, 0, "pointerup", e.offset.x.toDouble(), e.offset.y.toDouble());
        isTap = false;
      }
    });
    glContext.canvasElement.onMouseEnter.listen((MouseEvent e) {
      // print("enter offset=${e.offsetX}:${e.offsetY}  client=${e.clientX}:${e.clientY} screen=${e.screenX}:${e.screenY}");
      if (isTap == true) {
        //root.touch(this, 0, "pointercancel", e.offsetX.toDouble(), e.offsetY.toDouble());
      }
    });
    glContext.canvasElement.onMouseLeave.listen((MouseEvent e) {
      // print("leave offset=${e.offsetX}:${e.offsetY}  client=${e.clientX}:${e.clientY} screen=${e.screenX}:${e.screenY}");
      if (isTap == true) {
        root.touch(this, 0, "pointercancel", e.offset.x.toDouble(),
            e.offset.y.toDouble());
        isTap = false;
      }
    });
    glContext.canvasElement.onMouseMove.listen((MouseEvent e) {
      //print("move offset=${e.offsetX}:${e.offsetY}  client=${e.clientX}:${e.clientY} screen=${e.screenX}:${e.screenY}");
      if (isTap == true) {
        root.touch(this, 0, "pointermove", e.offset.x.toDouble(),
            e.offset.y.toDouble());
      }
    });

    glContext.canvasElement.onMouseOut.listen((MouseEvent e) {
      // print("out offset=${e.offsetX}:${e.offsetY}  client=${e.clientX}:${e.clientY} screen=${e.screenX}:${e.screenY}");
      if (isTap == true) {
        root.touch(this, 0, "pointercancel", e.offset.x.toDouble(),
            e.offset.y.toDouble());
        isTap = false;
      }
    });

    glContext.canvasElement.onMouseOver.listen((MouseEvent e) {
      // print("over offset=${e.offsetX}:${e.offsetY}  client=${e.clientX}:${e.clientY} screen=${e.screenX}:${e.screenY}");
      if (isTap == true) {
        // root.touch(this, 0, event.type, e.offsetX.toDouble(), e.offsetY.toDouble());
      }
    });
  }
}

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

  void clear() {
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
    GL.stencilFunc(RenderingContext.ALWAYS, 1, 0xff);

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
    GL.stencilFunc(RenderingContext.EQUAL, 1, 0xff);
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
    GL.bufferData(
        RenderingContext.ARRAY_BUFFER,
        new Float32List.fromList([0.0, 0.0, 0.0, 1.0, 1.0, 0.0, 1.0, 1.0]),
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
