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
  double get directionMax => size/2;
  double get directionX => - minX;
  double get directionY => - minY;

  TinyJoystick({this.size:50.0,this.minWidth:25.0}) {
    
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
    print("x:y=${minX-(minWidth/2)}:${minY-(minWidth/2)}  __ ${minX} ${minY}");
  }

  @override
  bool onTouch(TinyStage stage, int id, String type, double x, double y, double globalX, globalY) {
    if (isTouch == false) {
      if (distance(x, y, 0.0, 0.0) < minWidth) {
        touchId = id;
        isTouch = true;
        this.minX = x;
        this.minY = y;
      }
    } else {
      if (id == touchId) {
        if (type == "pointerup") {
          //print("--up");
          isTouch = false;
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