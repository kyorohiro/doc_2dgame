part of tinygame;

class SpriteSheetInfo {
  String json;
  List<SpriteSheetInfoFrame> frames = [];
  SpriteSheetInfo.fronmJson(this.json) {
    parserFrames(this.json); 
  }

  parserFrames(String input) {
    conv.JsonDecoder d = new conv.JsonDecoder();
    Map root = d.convert(input);
    for (Map frame in (root["frames"] as List<Map>)) {
      frames.add(new SpriteSheetInfoFrame.fromMap(frame));
    }
  }
}

class SpriteSheetInfoFrame {
  String fileName;
  bool rotated;
  bool trimmed;
  TinyRect spriteSourceSize;
  TinySize sourceSize;
  TinyPoint pivot;
  TinyRect frame;

  SpriteSheetInfoFrame(this.fileName, this.frame, this.rotated, this.trimmed,
      this.spriteSourceSize, this.sourceSize, this.pivot) {}

  SpriteSheetInfoFrame.fromMap(Map frame) {
    this.fileName = frame["filename"];
    this.frame = parseRect(frame["frame"]);
    this.rotated = frame["rotated"];
    this.trimmed = frame["trimmed"];
    this.spriteSourceSize = parseRect(frame["spriteSourceSize"]);
    this.sourceSize = parseSize(frame["sourceSize"]);
    this.pivot = parsePoint(frame["pivot"]);
  }
  TinyRect parseRect(Map rect) {
    num x = rect["x"];
    num y = rect["y"];
    num w = rect["w"];
    num h = rect["h"];
    return new TinyRect(x.toDouble(), y.toDouble(), w.toDouble(), h.toDouble());
  }

  TinyPoint parsePoint(Map point) {
    num x = point["x"];
    num y = point["y"];
    return new TinyPoint(x.toDouble(), y.toDouble());
  }

  TinySize parseSize(Map size) {
    num w = size["w"];
    num h = size["h"];
    return new TinySize(w.toDouble(), h.toDouble());
  }
}
