import 'package:umiuni2d/tinygame.dart';

class BitmapFontTest extends TinyDisplayObject {
  String json = null;
  TinyImage image = null;
  SpriteSheet sheet = null;
  BitmapFontTest(TinyGameBuilder builder) {
    print("### Z");
    builder.loadImage("assets/font_a.png").then((TinyImage i) {
      image = i;
      update();
    });
    builder.loadStringBase("assets/font_a.json").then((String x) {
      json = x;
      update();
    });
  }

  update() {
    print("### A");
    if(json == null || image == null) {
      return;
    }
    print("### B");
    sheet = new SpriteSheet.bitmapfont(json, image.w, image.h);

  }
  void onPaint(TinyStage stage, TinyCanvas canvas) {
    if(sheet == null) {
      return;
    }
    sheet.drawText(stage, canvas, image, "雪が降った。abcdefghijklmn", 25.0, rect:new TinyRect(10.0,20.0,200.0, 200.0), orientation: BitmapFontInfoType.horizontal);
    canvas.drawRect(stage, new TinyRect(10.0,20.0,200.0, 200.0), new TinyPaint()..color=new TinyColor.argb(0xff, 0xff, 0xaa, 0xaa)..style=TinyPaintStyle.stroke);
    sheet.drawText(stage, canvas, image, "雪が降った。abcdefgh", 25.0, rect:new TinyRect(100.0,100.0,200.0, 200.0), orientation: BitmapFontInfoType.vertical);
    canvas.drawRect(stage, new TinyRect(100.0,100.0,200.0, 200.0), new TinyPaint()..color=new TinyColor.argb(0xff, 0xaa, 0xaa, 0xff)..style=TinyPaintStyle.stroke);
  }

}
