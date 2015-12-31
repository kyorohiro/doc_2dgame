part of tinygame;

enum TinyCanvasTransform { NONE, ROT90, ROT180, ROT270, MIRROR, MIRROR_ROT90, MIRROR_ROT180, MIRROR_ROT270, }

abstract class TinyCanvas {
  void drawOval(TinyStage stage, TinyRect rect, TinyPaint paint, {List<Object> cache: null});
  void drawRect(TinyStage stage, TinyRect rect, TinyPaint paint, {List<Object> cache: null});
  void drawLine(TinyStage stage, TinyPoint p1, TinyPoint p2, TinyPaint paint, {List<Object> cache: null});
  void clipRect(TinyStage stage, TinyRect rect, {Matrix4 m:null});
  void clearClip(TinyStage stage);
  void drawImageRect(TinyStage stage, TinyImage image, TinyRect src, TinyRect dst, TinyPaint paint, {TinyCanvasTransform transform, List<Object> cache: null});

  List<Matrix4> mats = [new Matrix4.identity()];
  List<TinyRect> clip = [];

  clear() {
    ;
  }

  flush() {
    ;
  }

  pushMulMatrix(Matrix4 mat) {
    mats.add(mats.last * mat);
    updateMatrix();
  }

  popMatrix() {
    mats.removeLast();
    updateMatrix();
  }

  Matrix4 getMatrix() {
    return mats.last;
  }

  void updateMatrix();

  void pushClipRect(TinyStage stage, TinyRect rect) {
    clip.add(rect);
    clipRect(stage, rect);
  }

  void popClipRect(TinyStage stage) {
    clip.removeLast();
    if (clip.length > 0) {
      clipRect(stage, clip.last);
    } else {
      TinyRect r = new TinyRect(0.0, 0.0, stage.w, stage.h);
      clipRect(stage, r);
    }
  }
  //
  //
}
