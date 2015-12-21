part of tinygame;

typedef void TinyButtonCallback(String id);


class TinyButton extends TinyDisplayObject {
  double w;
  double h;
  bool isTouch = false;
  bool isFocus = false;
  double dx = 0.0;
  double dy = 0.0;
  double prevGX = 0.0;
  double prevGY = 0.0;
  TinyImage bgImg = null;
  TinyRect bgImgSrcRect = new TinyRect(0.0, 0.0, 0.0, 0.0);
  TinyRect bgImgDstRect = new TinyRect(0.0, 0.0, 0.0, 0.0);

  String buttonName;
  TinyColor bgcolorOff = new TinyColor.argb(0xaa, 0xff, 0xaa, 0xcc);
  TinyColor bgcolorOn = new TinyColor.argb(0xaa, 0xcc, 0xaa, 0xff);
  TinyColor bgcolorFocus = new TinyColor.argb(0xaa, 0xcc, 0xff, 0xaa);
  TinyButtonCallback onTouchCallback;

  // if release joystickm input ture;
  bool registerUp = false;
  // if down joystickm input ture;
  bool registerDown = false;
  bool exclusiveTouch;

  TinyButton(this.buttonName, this.w, this.h, this.onTouchCallback,{TinyDisplayObject child,this.exclusiveTouch:true}) {
    if(child != null) {
      this.addChild(child);
    }
  }

  bool checkFocus(double x, double y) {
    if (x > 0 && y > 0 && y < h && x < w) {
      return true;
    } else {
      return false;
    }
  }


  bool onTouch(TinyStage stage, int id, TinyStagePointerType type, double x, double y,
      double globalX, globalY) {
    bool ret = false;
    switch (type) {
      case TinyStagePointerType.DOWN:
        if (checkFocus(x, y)) {
          ret = true;
          isTouch = true;
          isFocus = true;
          prevGX = globalX;
          prevGY = globalY;
          registerDown = true;
        }
        break;
      case TinyStagePointerType.MOVE:
        if (checkFocus(x, y)) {
          ret = true;
          isFocus = true;
          dx = globalX -prevGX;
          dy = globalY -prevGY;
          prevGX = globalX;
          prevGY = globalY;
        } else {
          isTouch = false;
          isFocus = false;
          dx = 0.0;
          dy = 0.0;
          registerUp = true;
        }
        break;
      case TinyStagePointerType.UP:
        if (isTouch == true && onTouchCallback != null) {
          registerUp = true;
          new Future(() {
            onTouchCallback(buttonName);
          });
        }
        isTouch = false;
        isFocus = false;
        dx = 0.0;
        dy = 0.0;
        break;
      default:
        isTouch = false;
        isFocus = false;
        dx = 0.0;
        dy = 0.0;
    }
    if(exclusiveTouch == true) {
      return ret;
    } else {
      return false;
    }
  }

  void onPaint(TinyStage stage, TinyCanvas canvas) {
    TinyPaint paint = new TinyPaint();
    if(bgImg != null) {
      canvas.drawImageRect(stage, bgImg, bgImgSrcRect, bgImgDstRect, paint);
    }
    if (isTouch) {
      paint.color = bgcolorOn;
      canvas.drawRect(stage, new TinyRect(0.0, 0.0, w, h), paint);
    } else if (isFocus) {
      paint.color = bgcolorFocus;
      canvas.drawRect(stage, new TinyRect(0.0, 0.0, w, h), paint);
    } else {
      paint.color = bgcolorOff;
      canvas.drawRect(stage, new TinyRect(0.0, 0.0, w, h), paint);
    }
  }
}
