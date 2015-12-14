part of tinygame;

enum TinyStagePointerType {
  CANCEL,
  UP,
  DOWN,
  MOVE
}
abstract class TinyStage {
  double get x;
  double get y;
  double get w;
  double get h;
  double get paddingTop;
  double get paddingBottom;
  double get paddingRight;
  double get paddingLeft;

  bool animeIsStart = false;
  int animeId = 0;
  TinyDisplayObject _root;
  TinyDisplayObject get root => _root;
  void set root(TinyDisplayObject v) {_root = v;}
  TinyGameBuilder get builder;
  bool startable = false;
  bool isInit = false;

  void start();
  void stop();
  void markNeedsPaint();

  //
  void kick(int timeStamp) {
    if (isInit == false) {
      _root.init(this);
      isInit = true;
    }
    _root.tick(this, timeStamp);
    markNeedsPaint();
  }

  void kickPaint(TinyStage stage, TinyCanvas canvas) {
      canvas.pushMulMatrix(root.mat);
      root.paint(stage, canvas);
      canvas.popMatrix();
  }
  bool kickTouch(TinyStage stage, int id, TinyStagePointerType type, double x, double y) {
    stage.pushMulMatrix(root.mat);
    root.touch(stage, id, type, x, y);
    stage.popMatrix();
  }
  //
  //
  List<Matrix4> mats = [new Matrix4.identity()];

  pushMulMatrix(Matrix4 mat) {
    mats.add(mats.last * mat);
    //mats.add(mat*mats.last);
  }

  popMatrix() {
    mats.removeLast();
  }

  Matrix4 getMatrix() {
    return mats.last;
  }
 
  static String toStringPointerType(TinyStagePointerType type) {
    switch(type) {
      case TinyStagePointerType.CANCEL:
        return "pointercancel";
      case TinyStagePointerType.UP:
        return "pointerup";
      case TinyStagePointerType.DOWN:
       return "pointerdown";
      case TinyStagePointerType.MOVE:
       return "pointermove";
      default:
       return "";
    }
  }
}
