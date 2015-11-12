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

  Future<String> loadString(String path) async {
    Completer<String> c = new Completer();
    HttpRequest request = new HttpRequest();
    request.open("GET", path);
    request.responseType = "arraybuffer";
    request.onLoad.listen((ProgressEvent e) async {
      ByteBuffer buffer = request.response;
      c.complete(conv.UTF8.decode(buffer.asUint8List(),allowMalformed: true));
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
    mouseTest();
    touchTtest();
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
        c.flush();
        isPaint = false;
      }

      if (count > 40) {
        print("###fps  ${sum~/count}");
        sum = 0.0;
        count = 0;
      }
    }
  }

  void stop() {
    animeIsStart = false;
  }

  void touchTtest() {
    Map touchs = {};
    oStu(TouchEvent e) {
      for (Touch t in e.changedTouches) {
        int x = t.page.x-glContext._canvasElement.offsetLeft;
        int y = t.page.y-glContext._canvasElement.offsetTop;
          if (touchs.containsKey(t.identifier)) {
            root.touch(this, t.identifier+1, "pointermove",
                x.toDouble(),
                y.toDouble());
          } else {
            touchs[t.identifier] = t;
            root.touch(this, t.identifier+1, "pointerdown",
                x.toDouble(),
                y.toDouble());
          }
      }
    }
    oEnd(TouchEvent e) {
      for (Touch t in e.changedTouches) {
          if (touchs.containsKey(t.identifier)) {
            int x = t.page.x-glContext._canvasElement.offsetLeft;
            int y = t.page.y-glContext._canvasElement.offsetTop;
            touchs.remove(t.identifier);
            root.touch(this, t.identifier+1, "pointerup",
                x.toDouble(),
                y.toDouble());
          }
      }
    }
    glContext._canvasElement.onTouchCancel.listen(oEnd);
    glContext._canvasElement.onTouchEnd.listen(oEnd);
    glContext._canvasElement.onTouchEnter.listen(oStu);
    glContext._canvasElement.onTouchLeave.listen(oStu);
    glContext._canvasElement.onTouchMove.listen(oStu);
    glContext._canvasElement.onTouchStart.listen(oStu);
  }

  void mouseTest() {
    bool isTap = false;
    glContext.canvasElement.onMouseDown.listen((MouseEvent e) {
       //print("down offset=${e.offsetX}:${e.offsetY}  client=${e.clientX}:${e.clientY} screen=${e.screenX}:${e.screenY}");
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
     //  print("leave offset=${e.offsetX}:${e.offsetY}  client=${e.clientX}:${e.clientY} screen=${e.screenX}:${e.screenY}");
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
      //  root.touch(this, 0, "pointercancel", e.offset.x.toDouble(),
      //      e.offset.y.toDouble());
      //  isTap = false;
      }
    });

    glContext.canvasElement.onMouseOver.listen((MouseEvent e) {
       print("over offset=${e.offsetX}:${e.offsetY}  client=${e.clientX}:${e.clientY} screen=${e.screenX}:${e.screenY}");
      if (isTap == true) {
        // root.touch(this, 0, event.type, e.offsetX.toDouble(), e.offsetY.toDouble());
      }
    });
  }
}
