part of gamelogic;


class Snow {
  double x = 0.0;
  double y = 0.0;
  double dx = 0.0;
  double dy = 0.0;
  String type = "BG001.png";
  Snow(this.type) {
    reset();
  }
  math.Random r = new math.Random();
  reset() {
    x = r.nextDouble() * 400;
    y = -1*r.nextDouble()*100;
    dx = r.nextDouble()-0.5;
    dy = r.nextDouble();
  }
}

class Snows {
  math.Random r = new math.Random();
  TinyImage bgimg;
  SpriteSheetInfo info;
  List<Snow> idnames = [];
  TinyPaint p = new TinyPaint();

  Snows() {
  }
  addIdName(String name) {
   idnames.add(new Snow(name));
  }
  void onPaint(TinyStage stage, TinyCanvas canvas) {
    if (bgimg != null && info != null) {
      for (Snow se in idnames) {
        TinySize s = info.frameFromFileName(se.type).sourceSize;
        canvas.drawImageRect(
            stage,
            bgimg,
            info.frameFromFileName(se.type).srcRect,
            new TinyRect(se.x, se.y, s.w / 3, s.h / 3),
            p);
        se.x += se.dx;
        se.y += se.dy;
        se.dy += 0.001;
        if(se.x < 0 || se.x > 400 || se.y>300) {
          se.reset();
        }
      }
    }
  }
}
