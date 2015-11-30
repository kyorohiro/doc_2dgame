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
  List<Snow> sn = [];
  math.Random r = new math.Random();
  Snows() {
    for(int i=1;i<=7;i++) {
      sn.add(new Snow("B00${i}.png"));
    }
  }
  void onPaint(TinyStage stage, TinyCanvas canvas, StartScene scene) {
    if (scene.bgimg != null && scene.info != null) {
      for (Snow se in sn) {
        TinySize s = scene.info.frameFromFileName(se.type).sourceSize;
        canvas.drawImageRect(
            stage,
            scene.bgimg,
            scene.info.frameFromFileName(se.type).srcRect,
            new TinyRect(se.x, se.y, s.w / 3, s.h / 3),
            scene.p);
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
