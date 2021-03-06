part of tinygame;

abstract class SpriteSheet {
  Iterable<Object> get keys;
  int get length;
  SpriteSheetData operator [](Object key);
  bool containsKey(Object key);
  SpriteSheet() {}
  factory SpriteSheet.spritsheet(String json) {
    return new SpriteSheetInfo.fronmJson(json);
  }

  factory SpriteSheet.bitmapfont(String json, int w, int h) {
    return new BitmapFont(json, w, h);
  }

  TinyPaint p = new TinyPaint();
  void drawImage(TinyStage stage, TinyCanvas canvas, TinyImage image, String name) {
    if (this[name] != null) {
      canvas.drawImageRect(stage, image, this[name].srcRect, this[name].dstRect, p);
    }
  }

  void drawText(TinyStage stage, TinyCanvas canvas, TinyImage image, String text, double size, {TinyRect rect: null, BitmapFontInfoType orientation: BitmapFontInfoType.horizontal, double margine: 5.0}) {
    if(orientation == BitmapFontInfoType.horizontal) {
      drawTextHorizontal(stage, canvas, image, text, size, rect: rect, margine: margine);
    } else {
      drawTextVertical(stage, canvas, image, text, size, rect: rect, margine: margine);
    }
  }

  void drawTextHorizontal(TinyStage stage, TinyCanvas canvas, TinyImage image, String text, double size, {TinyRect rect: null, double margine: 5.0}) {
    if(rect == null) {
      rect = new TinyRect(0.0,0.0,10000.0,10000.0);
    }
    double x = rect.x;
    double y = rect.y;
    for (int i = 0; i < text.length; i++) {
      SpriteSheetData d = this[text[i]];
      if (d == null) {
        continue;
      }
      TinyRect dstRect = d.dstRect;
      dstRect.x = x;
      dstRect.y = y;
      dstRect.w = size * d.srcRect.w / d.srcRect.h;
      dstRect.h = size;
      if (rect != null) {
          if((rect.x+rect.w) < (dstRect.x + dstRect.w)){
              x = rect.x;
              y += dstRect.h + margine;
              dstRect.x = x;
              dstRect.y = y;
          }
      }
      canvas.drawImageRect(stage, image, d.srcRect, dstRect, p);
        x += dstRect.w + margine * d.srcRect.w / d.srcRect.h;
    }
  }

  //
  void drawTextVertical(TinyStage stage, TinyCanvas canvas, TinyImage image, String text, double size, {TinyRect rect: null, double margine: 5.0}) {
    if(rect == null) {
      rect = new TinyRect(0.0,0.0,10000.0,10000.0);
    }
    double x = 0.0;
    double y = 0.0;

    x = rect.x+rect.w;
    y = rect.y;
    double s = 0.0;
    for (int i = 0; i < text.length; i++) {
      SpriteSheetData d = this[text[i]];
      if (d == null) {
        continue;
      }
      TinyRect dstRect = d.dstRect;
      if(s <(size * d.srcRect.w / d.srcRect.h)) {
        s = size * d.srcRect.w / d.srcRect.h;
      }
      dstRect.w = size * d.srcRect.w / d.srcRect.h;
      dstRect.h = size;
      dstRect.x = x-dstRect.w;
      dstRect.y = y;

      if (rect != null) {
          if((rect.y+rect.h) < (dstRect.y + dstRect.h)){
            y = rect.y;
            x -= s;
            s = 0.0;
            dstRect.x = x-dstRect.w;
            dstRect.y = y;
          }
      }
      canvas.drawImageRect(stage, image, d.srcRect, dstRect, p);
        y += dstRect.h + margine;
      }
  }
}

abstract class SpriteSheetData {
  String name;
  TinyRect get dstRect;
  TinyRect get srcRect;
  double get angle;
}

class BitmapFont extends SpriteSheet {
  Map<Object, BitmapFontData> d = {};
  int imageWidth;
  int imageHeight;
  BitmapFont(String json, this.imageWidth, this.imageHeight) {
    BitmapFontInfo info = new BitmapFontInfo.fromJson(json);
    for (int key in info.r.keys) {
      String name = new String.fromCharCode(key);
      BitmapFontData v = new BitmapFontData(name, info.r[key], imageWidth.toDouble(), imageHeight.toDouble());
      d[key] = v;
      d[name] = v;
    }
  }
  Iterable<Object> get keys => d.keys;
  int get length => d.length;
  SpriteSheetData operator [](Object key) => d[key];
  bool containsKey(Object key) => d.containsKey(key);
}

class BitmapFontData extends SpriteSheetData {
  BitmapFontData(this.name, this.elm, this.imageWidth, this.imageHeight) {}
  String name;
  BitmapFontInfoElem elm;
  double imageWidth;
  double imageHeight;
  TinyRect get dstRect => elm.dstRect(imageWidth, imageHeight);
  TinyRect get srcRect => elm.srcRect(imageWidth, imageHeight);
  double get angle => 0.0;
}
