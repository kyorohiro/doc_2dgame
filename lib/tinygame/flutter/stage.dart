part of tinygame_flutter;



class TinyFlutterImage implements TinyImage {
  sky.Image rawImage;
  TinyFlutterImage(this.rawImage) {}
  int get w => rawImage.width;
  int get h => rawImage.height;
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
  bool isNCanvas = true;// use drawVertex
  bool tickInPerFrame;

  TinyFlutterStage(this._builder, TinyDisplayObject root,{this.tickInPerFrame:true}) {
    this.root = root;
    this.canvas = null;
    init();
  }

  void init() {}

  void start() {
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
    while (animeIsStart == true) {
      _innerTick(new Duration(milliseconds: new DateTime.now().millisecondsSinceEpoch));
      await new Future.delayed(new Duration(milliseconds: 10));
    }
  }

  int timeCount = 0;
  int timeEpoc = 0;
  void _innerTick(Duration timeStamp) {
    if(timeEpoc == 0) {
      timeEpoc = timeStamp.inMilliseconds;
      timeCount =0;
    }
    if(timeCount > 40) {
      int cTimeEpoc = timeStamp.inMilliseconds;
      print("fps[A]? : ${(cTimeEpoc-timeEpoc)/timeCount}");
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
      if(this.isNCanvas == false) {
        this.canvas = new TinyFlutterCanvas(context.canvas);
      } else {
        this.canvas = new TinyFlutterNCanvas(context.canvas);
      }
    }
    if(this.isNCanvas == false) {
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
