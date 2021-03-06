part of tinygame;

abstract class TinyGameBuilder {
  Map<String, TinyImage> cach = {};
  Map<String, String> cachString = {};
  TinyStage createStage(TinyDisplayObject root);
  Future<TinyImage> loadImageBase(String path);
  Future<TinyImage> loadImage(String path) async {
    if (cach.containsKey(path)) {
      return cach[path];
    }
    cach[path] = await loadImageBase(path);
    return cach[path];
  }

  Future<TinyAudioSource> loadAudio(String path);
  Future<String> loadStringBase(String path);

  Future<String> loadString(String path) async {
    if (cachString.containsKey(path)) {
      return cachString[path];
    }
    cachString[path] = await loadStringBase(path);
    return cachString[path];
  }

  TinyImage getImage(String path) {
    if (cach.containsKey(path)) {
      return cach[path];
    }
    loadImage(path);
    return null;
  }

  Future clearImageCash({bool callDispose: true, List<String> excepts: null}) async {
    Map<String, TinyImage> nextImageCach = {};
    excepts = (excepts == null ? [] : excepts);
    if (callDispose == true) {
      for (String k in cach.keys) {
        if (false == excepts.contains(k)) {
          TinyImage i = cach[k];
          i.dispose();
        } else {
          nextImageCach[k] = cach[k];
        }
      }
    }
    cach.clear();
    cach = nextImageCach;
  }

  Future clearStringCash() async {
    cachString.clear();
  }

  Future<TinyFile> loadFile(String name);
  Future<List<String>> getFiles();
  Future<String> getLocale();
}

abstract class TinyFile {
  Future<int> write(List<int> buffer, int offset);
  Future<List<int>> read(int offset, int length);
  Future<int> getLength();
  Future<int> truncate(int fileSize);
}

class TinyRect {
  double x;
  double y;
  double w;
  double h;
  TinyRect(this.x, this.y, this.w, this.h) {}

  @override
  bool operator ==(o) => o is TinyRect && o.x == x && o.y == y && o.w == w && o.h == h;

  @override
  int get hashCode => JenkinsHash.calc([x.hashCode, y.hashCode, w.hashCode, h.hashCode]);

  @override
  String toString() {
    return "x:${x}, y:${y}, w:${w}, h:${h}";
  }
}

class TinyPoint {
  double x;
  double y;
  TinyPoint(this.x, this.y) {}

  @override
  bool operator ==(o) => o is TinyPoint && o.x == x && o.y == y;

  @override
  int get hashCode => JenkinsHash.calc([x.hashCode, y.hashCode]);

  @override
  String toString() {
    return "x:${x}, y:${y}";
  }
}

class TinySize {
  double w;
  double h;
  TinySize(this.w, this.h) {}

  @override
  bool operator ==(o) => o is TinySize && o.w == w && o.h == h;

  @override
  int get hashCode => JenkinsHash.calc([w.hashCode, h.hashCode]);

  @override
  String toString() {
    return "w:${w}, h:${h}";
  }
}

enum TinyPaintStyle { fill, stroke }

class TinyPaint {
  TinyColor color;
  TinyPaintStyle style = TinyPaintStyle.fill;
  double strokeWidth = 1.0;
  TinyPaint({this.color}) {
    if (this.color == null) {
      color = new TinyColor.argb(0xff, 0xff, 0xff, 0xff);
    }
  }
}

class TinyColor {
  int value = 0;
  TinyColor(this.value) {}
  int get a => (value >> 24) & 0xff;
  int get r => (value >> 16) & 0xff;
  int get g => (value >> 8) & 0xff;
  int get b => (value >> 0) & 0xff;
  double get af => a / 255.0;
  double get rf => r / 255.0;
  double get gf => g / 255.0;
  double get bf => b / 255.0;

  TinyColor.argb(int a, int r, int g, int b) {
    value |= (a & 0xff) << 24;
    value |= (r & 0xff) << 16;
    value |= (g & 0xff) << 8;
    value |= (b & 0xff) << 0;
    value &= 0xFFFFFFFF;
  }

  @override
  bool operator ==(o) => o is TinyColor && o.value == value;

  @override
  int get hashCode => JenkinsHash.calc([value.hashCode]);

  @override
  String toString() {
    return "a:${a}, r:${r}, g:${g}, b:${b}";
  }
}

abstract class TinyImage {
  int get h;
  int get w;
  void dispose();
}
