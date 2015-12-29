part of tinygame_flutter;



class TinyFlutterImage implements TinyImage {
  sky.Image rawImage;
  TinyFlutterImage(this.rawImage) {}
  int get w => rawImage.width;
  int get h => rawImage.height;
  @override
  void dispose() {;}
}

class ResourceLoader {
  static AssetBundle getAssetBundle() {
    if (rootBundle != null) {
      return rootBundle;
    } else {
      return new NetworkAssetBundle(new Uri.directory(Uri.base.origin));
    }
  }

  static Future<sky.Image> loadImage(String url) async {
    AssetBundle bundle = getAssetBundle();
    ImageResource resource = bundle.loadImage(url);
    return resource.first;
  }

  static Future<String> loadString(String url) async {
    AssetBundle bundle = getAssetBundle();
    String b = await bundle.loadString(url);
    //print("-a-${url} -- ${b}");
    return b;
  }

  static Future<MojoDataPipeConsumer> loadMojoData(String url) async {
    AssetBundle bundle = getAssetBundle();
    return await bundle.load(url);
  }
}

class TinyFlutterStage extends RenderBox with TinyStage {
  double get x => paintBounds.left;
  double get y => paintBounds.top;
  double get w => paintBounds.width;
  double get h => paintBounds.height;

  double get paddingTop => sky.window.padding.top;
  double get paddingBottom => sky.window.padding.bottom;
  double get paddingRight => sky.window.padding.right;
  double get paddingLeft => sky.window.padding.left;

  bool animeIsStart = false;
  int animeId = 0;

  bool startable = false;
  static const int kMaxOfTouch = 5;
  Map<int, TouchPoint> touchPoints = {};

  TinyGameBuilder _builder;
  TinyGameBuilder get builder => _builder;
  TinyCanvas canvas;
  bool useTestCanvas = false;// use drawVertex
  bool tickInPerFrame;
  bool useDrawVertexForPrimtive;
  int tickInterval;
  TinyFlutterStage(this._builder, TinyDisplayObject root,{this.tickInPerFrame:true, this.useTestCanvas:false,this.useDrawVertexForPrimtive:false,this.tickInterval:15}) {
    this.root = root;
    this.canvas = null;
    init();
  }

  void init() {}

  void start() {
    print("##useTestCanvas ${useTestCanvas}");
    if (animeIsStart == true) {
      return;
    }
    animeIsStart = true;
    isInit = false;
    if(tickInPerFrame == true) {
      animeId = Scheduler.instance.addFrameCallback(_innerTick);
    } else {
      _innerTickWithOwn();
    }
//    Scheduler.instance.addPersistentFrameCallback(_innerTick);
  }
  _innerTickWithOwn() async{
    print("#####AAAA");
    int a1 = new DateTime.now().millisecondsSinceEpoch;
    while (animeIsStart == true) {
      int a2 = new DateTime.now().millisecondsSinceEpoch;
      _innerTick(new Duration(milliseconds: new DateTime.now().millisecondsSinceEpoch));
      int t = this.tickInterval+(this.tickInterval-(a2-a1));

      if(t < 5) {
        t = 5;
      } else if(t > this.tickInterval) {
        t = this.tickInterval;
      }
      //print("## ${t} ${(a2-a1)}");
     a1 = a2;
      await new Future.delayed(new Duration(milliseconds: t));
    }
  }

  int timeCount = 0;
  int timeEpoc = 0;
  void _innerTick(Duration timeStamp) {
    if(timeEpoc == 0) {
      timeEpoc = timeStamp.inMilliseconds;
      timeCount =0;
    }
    if(timeCount > 60) {
      int cTimeEpoc = timeStamp.inMilliseconds;
      print("fps[A]? : ${1000~/((cTimeEpoc-timeEpoc)/timeCount)} ${timeCount} ${(cTimeEpoc-timeEpoc)/timeCount}");
      timeCount = 0;
      timeEpoc = cTimeEpoc;
    }
    timeCount++;
    if (startable) {
      kick(timeStamp.inMilliseconds);
    }
    if (animeIsStart == true && tickInPerFrame == true) {
      animeId = Scheduler.instance.addFrameCallback(_innerTick);
    }
  }

  void stop() {
    if (animeIsStart == true) {
      Scheduler.instance.cancelFrameCallbackWithId(animeId);
    }
    animeIsStart = false;
  }

  @override
  void performLayout() {
    size = constraints.biggest;
    startable = true;
  }

  @override
  bool hitTest(HitTestResult result, {Point position}) {
    result.add(new BoxHitTestEntry(this, position));
    return true;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if(this.canvas == null) {
      if(this.useTestCanvas == true) {
        this.canvas = new TinyFlutterCanvas(context.canvas);
      } else {
        this.canvas = new TinyFlutterNCanvas(context.canvas, useDrawVertexForPrimtive:useDrawVertexForPrimtive);
      }
    }
    if(this.useTestCanvas == true) {
       (this.canvas as TinyFlutterCanvas).canvas = context.canvas;
    } else {
       (this.canvas as TinyFlutterNCanvas).canvas = context.canvas;
   }
    this.canvas.clear();
    kickPaint(this, this.canvas);
    this.canvas.flush();
  }

  TinyStagePointerType toEvent(PointerEvent e) {
    if(e is PointerUpEvent) {
      return TinyStagePointerType.UP;
    }else if(e is PointerDownEvent) {
      return TinyStagePointerType.DOWN;
    }else if(e is PointerCancelEvent) {
      return TinyStagePointerType.CANCEL;
    }else if(e is PointerMoveEvent) {
      return TinyStagePointerType.MOVE;
    }else if(e is PointerUpEvent) {
      return TinyStagePointerType.UP;
    } else {
      return TinyStagePointerType.CANCEL;
   }

  }
  @override
  void handleEvent(PointerEvent event, HitTestEntry en) {
    if (!(event is PointerEvent || !(en is BoxHitTestEntry))) {
      return;
    }

    BoxHitTestEntry entry = en;
    PointerEvent e = event;
    if (!touchPoints.containsKey(e.pointer)) {
      touchPoints[e.pointer] = new TouchPoint(-1.0, -1.0);
    }

//"pointerdown"
    if (event is PointerDownEvent) {
      touchPoints[e.pointer].x = entry.localPosition.x;
      touchPoints[e.pointer].y = entry.localPosition.y;
    } else {
      touchPoints[e.pointer].x = e.position.x;
      touchPoints[e.pointer].y = e.position.y;
    }
    //print("#### ${toEvent(event)} ${touchPoints[e.pointer].x}, ${touchPoints[e.pointer].y}");
    kickTouch(this, e.pointer, toEvent(event),
     touchPoints[e.pointer].x, touchPoints[e.pointer].y);

//== "pointerup"
    if (event is PointerUpEvent) {
      touchPoints.remove(e.pointer);
    }
//"pointercancel"
    if (event is PointerCancelEvent) {
      touchPoints.clear();
    }
  }
}

class TouchPoint {
  double x;
  double y;
  TouchPoint(this.x, this.y) {}
}
