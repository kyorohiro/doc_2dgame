part of tinygame_webgl;


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

  int lastUpdateTime = 0;
  int tappedEventTime = 0;
  bool animeIsStart = false;
  int animeId = 0;
  int paintInterval;
  TinyGameBuilder _builder;
  TinyGameBuilder get builder => _builder;

  TinyWebglStage(this._builder, TinyDisplayObject root,
      {width: 600.0, height: 400.0, this.paintInterval:40}) {
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

  bool isTMode = false;
  Future _anime() async {
    double sum = 0.0;
    double sum_a = 0.0;
    int count = 0;

    num prevTime = new DateTime.now().millisecond;
    TinyCanvas c = null;
    //if(isTMode==false)
    {
    //  c = new TinyWebglCanvas(glContext);
    //} else {
      c = new TinyWebglCanvasTS(glContext);
    }
    while (animeIsStart) {
      await new Future.delayed(new Duration(milliseconds: 15));
      num currentTime = new DateTime.now().millisecondsSinceEpoch;
      lastUpdateTime = currentTime;

      num s = (currentTime - prevTime);
      kick((prevTime + s).toInt());
     // kick((prevTime + s).toInt());
      sum += s;
      sum_a += s;
      if (s < 0) {}
      count++;
      prevTime = currentTime;
      markNeedsPaint();
      if (isPaint && sum_a > paintInterval) {
        new Future((){
          c.clear();
          kickPaint(this, c);
          c.flush();
        });
        isPaint = false;
        sum_a = 0.0;
      }
//      if (count > 10) {
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
      tappedEventTime = lastUpdateTime;
      for (Touch t in e.changedTouches) {
        int x = t.page.x-glContext._canvasElement.offsetLeft;
        int y = t.page.y-glContext._canvasElement.offsetTop;
          if (touchs.containsKey(t.identifier)) {
            kickTouch(this, t.identifier+1, TinyStagePointerType.MOVE,
                x.toDouble(),
                y.toDouble());
          } else {
            touchs[t.identifier] = t;
            kickTouch(this, t.identifier+1, TinyStagePointerType.DOWN,
                x.toDouble(),
                y.toDouble());
          }
      }
    }
    oEnd(TouchEvent e) {
      tappedEventTime = lastUpdateTime;
      for (Touch t in e.changedTouches) {
          if (touchs.containsKey(t.identifier)) {
            int x = t.page.x-glContext._canvasElement.offsetLeft;
            int y = t.page.y-glContext._canvasElement.offsetTop;
            touchs.remove(t.identifier);
            kickTouch(this, t.identifier+1, TinyStagePointerType.UP,
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
      if(tappedEventTime + 500 < lastUpdateTime) {
       //print("down offset=${e.offsetX}:${e.offsetY}  client=${e.clientX}:${e.clientY} screen=${e.screenX}:${e.screenY}");
      isTap = true;
      kickTouch(
          this, 0, TinyStagePointerType.DOWN, e.offset.x.toDouble(), e.offset.y.toDouble());
    }});
    glContext.canvasElement.onMouseUp.listen((MouseEvent e) {
      if(tappedEventTime + 500 < lastUpdateTime) {
      //print("up offset=${e.offsetX}:${e.offsetY}  client=${e.clientX}:${e.clientY} screen=${e.screenX}:${e.screenY}");
      if (isTap == true) {
        kickTouch(
            this, 0, TinyStagePointerType.UP, e.offset.x.toDouble(), e.offset.y.toDouble());
        isTap = false;
      }
    }});
    glContext.canvasElement.onMouseEnter.listen((MouseEvent e) {
      if(tappedEventTime + 500 < lastUpdateTime) {
      // print("enter offset=${e.offsetX}:${e.offsetY}  client=${e.clientX}:${e.clientY} screen=${e.screenX}:${e.screenY}");
      if (isTap == true) {
        //root.touch(this, 0, "pointercancel", e.offsetX.toDouble(), e.offsetY.toDouble());
      }
    }});
    glContext.canvasElement.onMouseLeave.listen((MouseEvent e) {
      if(tappedEventTime + 500 < lastUpdateTime) {
     //  print("leave offset=${e.offsetX}:${e.offsetY}  client=${e.clientX}:${e.clientY} screen=${e.screenX}:${e.screenY}");
      if (isTap == true) {
        kickTouch(this, 0, TinyStagePointerType.CANCEL, e.offset.x.toDouble(),
            e.offset.y.toDouble());
        isTap = false;
      }
    }});
    glContext.canvasElement.onMouseMove.listen((MouseEvent e) {
      if(tappedEventTime + 500 < lastUpdateTime) {
      //print("move offset=${e.offsetX}:${e.offsetY}  client=${e.clientX}:${e.clientY} screen=${e.screenX}:${e.screenY}");
      if (isTap == true) {
        kickTouch(this, 0, TinyStagePointerType.MOVE, e.offset.x.toDouble(),
            e.offset.y.toDouble());
      }
    }});

    glContext.canvasElement.onMouseOut.listen((MouseEvent e) {
      if(tappedEventTime + 500 < lastUpdateTime) {
     // print("out offset=${e.offsetX}:${e.offsetY}  client=${e.clientX}:${e.clientY} screen=${e.screenX}:${e.screenY}");
      if (isTap == true) {
        kickTouch(this, 0, TinyStagePointerType.CANCEL, e.offset.x.toDouble(),
            e.offset.y.toDouble());
        isTap = false;
      }
    }});

    glContext.canvasElement.onMouseOver.listen((MouseEvent e) {
      if(tappedEventTime + 500 < lastUpdateTime) {
      // print("over offset=${e.offsetX}:${e.offsetY}  client=${e.clientX}:${e.clientY} screen=${e.screenX}:${e.screenY}");
      if (isTap == true) {
        // root.touch(this, 0, event.type, e.offsetX.toDouble(), e.offsetY.toDouble());
      }
    }});
  }
}
