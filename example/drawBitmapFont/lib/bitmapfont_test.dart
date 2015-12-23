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
    sheet.drawText(stage, canvas, image, "abcdefghijklmn", 25.0, orientation: BitmapFontInfoType.horizontal);
    sheet.drawText(stage, canvas, image, "abcdefghijklmn", 25.0, orientation: BitmapFontInfoType.vertical);
  }

}
