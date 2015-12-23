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
    for (int key in info.r) {
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
  BitmapFontData(this.name, this.elm, this.imageWidth, this.imageHeigh) {}
  String name;
  BitmapFontInfoElem elm;
  double imageWidth;
  double imageHeight;
  TinyRect get dstRect => elm.dstRect(imageWidth, imageHeight);
  TinyRect get srcRect => elm.srcRect(imageWidth, imageHeight);
  double get angle;
}
