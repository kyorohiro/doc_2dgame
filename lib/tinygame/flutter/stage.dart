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
  bool isNCanvas = false;
  TinyFlutterStage(this._builder, TinyDisplayObject root) {
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
    animeId = scheduler.requestAnimationFrame(_innerTick);
  }

  void _innerTick(Duration timeStamp) {
    if (startable) {
      kick(timeStamp.inMilliseconds);
    }
    if (animeIsStart == true) {
      animeId = scheduler.requestAnimationFrame(_innerTick);
    }
  }

  void stop() {
    if (animeIsStart == true) {
      scheduler.cancelAnimationFrame(animeId);
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
    root.paint(this, this.canvas);
    this.canvas.flush();
  }

  @override
  void handleEvent(InputEvent event, HitTestEntry en) {
    if (!(event is PointerInputEvent || !(en is BoxHitTestEntry))) {
      return;
    }

    BoxHitTestEntry entry = en;
    PointerInputEvent e = event;
    if (!touchPoints.containsKey(e.pointer)) {
      touchPoints[e.pointer] = new TouchPoint(-1.0, -1.0);
    }

    if (event.type == "pointerdown") {
      touchPoints[e.pointer].x = entry.localPosition.x;
      touchPoints[e.pointer].y = entry.localPosition.y;
    } else {
      touchPoints[e.pointer].x += (e.dx == null ? 0 : e.dx);
      touchPoints[e.pointer].y += (e.dy == null ? 0 : e.dy);
    }
    root.touch(this, e.pointer, event.type, touchPoints[e.pointer].x,
        touchPoints[e.pointer].y);

    if (event.type == "pointerup") {
      touchPoints.remove(e.pointer);
    }
    if (event.type == "pointercancel") {
      touchPoints.clear();
    }
  }
}

class TouchPoint {
  double x;
  double y;
  TouchPoint(this.x, this.y) {}
}
