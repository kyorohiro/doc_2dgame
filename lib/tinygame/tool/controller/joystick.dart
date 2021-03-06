part of tinygame;

class TinyJoystick extends TinyDisplayObject {
  @override
  String objectName = "joystick";

  double size = 50.0;
  double minWidth = 25.0;
  bool isTouch = false;
  int touchId = 0;
  double minX = 0.0;
  double minY = 0.0;
  double releaseMinX = 0.0;
  double releaseMinY = 0.0;
  double get directionMax => size/2;
  double get directionX => minX/minWidth;
  double get directionY => - minY/minWidth;
  double get directionX_released => releaseMinX/minWidth;
  double get directionY_released => - releaseMinY/minWidth;
  double get directionXAbs => abs(directionX);
  double get directionYAbs =>  abs(directionY);
  // if release joystickm input ture;
  bool registerUp = false;
  // if down joystickm input ture;
  bool registerDown = false;
  double dx = 0.0;
  double dy = 0.0;
  double prevGX = 0.0;
  double prevGY = 0.0;

  TinyJoystick({this.size:50.0,this.minWidth:25.0}) {

  }

  clearStatus() {
    registerUp = false;
    registerDown = false;
    isTouch = false;
    touchId = 0;
    minX = 0.0;
    minY = 0.0;
    releaseMinX = 0.0;
    releaseMinY = 0.0;
  }
  @override
  void onPaint(TinyStage stage, TinyCanvas canvas) {
    TinyPaint p = new TinyPaint();
    if (isTouch) {
      p.color = new TinyColor.argb(0xaa, 0xaa, 0xaa, 0xff);
    } else {
      p.color = new TinyColor.argb(0xaa, 0xff, 0xaa, 0xaa);
    }
    TinyRect r1 = new TinyRect(- size / 2, - size / 2, size, size);
    TinyRect r2 = new TinyRect(minX-(minWidth/2), minY-(minWidth/2), minWidth, minWidth);
    canvas.drawOval(stage, r1, p);
    canvas.drawOval(stage, r2, p);
    //print("x:y=${minX-(minWidth/2)}:${minY-(minWidth/2)}  __ ${minX} ${minY}");
  }

  @override
  bool onTouch(TinyStage stage, int id, TinyStagePointerType type, double x, double y, double globalX, globalY) {
    if (isTouch == false) {
      if (distance(x, y, 0.0, 0.0) < size) {
        registerDown = true;
        touchId = id;
        isTouch = true;
        this.minX = x;
        this.minY = y;
        prevGX = globalX;
        prevGY = globalY;
      }
    } else {
      if (id == touchId) {
        if (type == TinyStagePointerType.UP || type == TinyStagePointerType.CANCEL) {
          //print("--up");
          if(isTouch) {
            registerUp = true;
            releaseMinX = minX;
            releaseMinY = minY;
          }
          isTouch = false;
          this.dx = 0.0;
          this.dy = 0.0;
          this.minX = 0.0;
          this.minY = 0.0;
        } else {
          this.minX = x;
          this.minY = y;
          double d = distance(0.0, 0.0, this.minX, this.minY);
          if (d > size / 2) {
            double dd = abs(this.minX) + abs(this.minY);
            //print("--mv ${dd}");
            this.minX = size / 2 * (this.minX) / dd;
            this.minY = size / 2 * (this.minY) / dd;
          }
          //
          dx = globalX -prevGX;
          dy = globalY -prevGY;
          prevGX = globalX;
          prevGY = globalY;
        }
      }
    }
    return false;
  }

  double abs(double v) {
    return (v > 0 ? v : -1 * v);
  }

  double distance(double x1, double y1, double x2, double y2) {
    return math.sqrt(math.pow(x1 - x2, 2) + math.pow(y1 - y2, 2));
  }
}
