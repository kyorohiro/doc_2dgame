import 'package:umiuni2d/tinygame.dart';

class Keyboard extends TinyDisplayObject {
  TinyGameBuilder builder;
  TinyAudioSource source = null;
  Keyboard(this.builder, String path) {
    builder.loadAudio("${path}").then((TinyAudioSource s) {
      source = s;
    });
  }
  void onPaint(TinyStage stage, TinyCanvas canvas) {
    TinyPaint p = new TinyPaint();
    if(source != null) {
      p.color = new TinyColor.argb(0x99, 0x00, 0x00, 0x00);
    } else {
      p.color = new TinyColor.argb(0x99, 0xff, 0xaa, 0xaa);
    }
    if(isTouch || source == null) {
      p.style = TinyPaintStyle.fill;
    } else {
      p.style = TinyPaintStyle.stroke;
    }
    canvas.drawRect(stage, new TinyRect(0.0, 0.0, 100.0, 200.0), p);
  }

  bool isIn(double x, double y) {
    if (0 < y && y < 200) {
      if (0 < x && x < 100) {
        return true;
      }
    }
    //print("--isIn ${x} ${y}");
    return false;
  }

  bool isTouch = false;
  bool onTouch(TinyStage stage, int id, String type, double x, double y,
      double globalX, globalY) {
    if ((type == "pointerdown" || type == "pointermove") && isIn(x, y)) {
      if (isTouch == false && source != null) {
        source.start();
        isTouch = true;
      }
    } else if(isTouch == true){
      isTouch = false;
      if(source != null) {
        source.pause();
      }
    }
    return false;
  }
}

class Piano extends TinyDisplayObject {
  TinyGameBuilder builder;
  List<TinyAudioSource> sources = new List.filled(6, null);
  Piano(this.builder) {
    initA();
  }
  initA() async {
    for (int i = 0; i < 6; i++) {
      Keyboard keyboard = new Keyboard(builder, "assets/se_maoudamashii_retro0${i+1}.ogg");
      addChild(keyboard);
      keyboard.mat.translate(i*100.0,150.0, 0.0);
    }
  }

  void onPaint(TinyStage stage, TinyCanvas canvas) {
    TinyPaint p = new TinyPaint();
    p.color = new TinyColor.argb(0xff, 0x00, 0x00, 0x00);
    p.style = TinyPaintStyle.fill;
    canvas.drawRect(stage, new TinyRect(0.0, 0.0, 600.0, 150.0), p);
  }

}
