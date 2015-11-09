part of tinygame;

class SpriteSheetInfo {
  String json;
  List<SpriteSheetInfoFrame> frames = [];

  SpriteSheetInfoFrame frameFromFileName(String fileName) {
    for(SpriteSheetInfoFrame f in frames) {
      if(f.fileName == fileName) {
        return f;
      }
    }
    return null;
  }

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

  draw(double x, double y, SpriteSheetInfoFrame f) {
    TinyRect srcRect = f.frame;
    if (f.rotated) {} else {
      TinyRect dstRect = new TinyRect(x + f.spriteSourceSize.x,
          y + f.spriteSourceSize.y, f.spriteSourceSize.w, f.spriteSourceSize.h);
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

  TinyRect get dstRect {
    if (rotated) {
      double x = -1.0 * spriteSourceSize.y - (spriteSourceSize.h);
      double y = 1.0 * spriteSourceSize.x;
      double w = spriteSourceSize.h;
      double h = spriteSourceSize.w;
      return new TinyRect(x, y, w, h);
    } else {
      return new TinyRect(spriteSourceSize.x, spriteSourceSize.y,
          spriteSourceSize.w, spriteSourceSize.h);
    }
  }

  TinyRect get srcRect {
    if (rotated) {
      return new TinyRect(frame.x, frame.y, frame.h, frame.w);
    } else {
      return new TinyRect(frame.x, frame.y, frame.w, frame.h);
    }
  }

  double get angle {
    if(rotated) {
      return -1 + math.PI / 2.0;
    } else {
      return 0.0;
    }
  }

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
