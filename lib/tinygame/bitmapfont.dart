//
// use http://sapphire-al2o3.github.io/font_tex/
//
part of tinygame;

class BitmapFontInfo {
  Map<int,BitmapFontInfoElem> r = {};
  BitmapFontInfo.fromJson(String input) {
    conv.JsonDecoder d = new conv.JsonDecoder();
    Map<String, Object> root = d.convert(input);
    for (String k in root.keys) {
      Map<String, num> e = root[k];
      r[int.parse(k)] =new BitmapFontInfoElem(
              e["u"].toDouble(), e["v"].toDouble(), e["w"].toDouble(), e["h"].toDouble(),
              e["vx"].toDouble(), e["vy"].toDouble(), e["vw"].toDouble(), e["vh"].toDouble());
    }
  }
}

class BitmapFontInfoElem {
  final double u;
  final double v;
  final double w;
  final double h;
  final double vx;
  final double vy;
  final double vw;
  final double vh;

  TinySize _dst = new TinySize(0.0, 0.0);
  TinyRect _src = new TinyRect(0.0, 0.0, 0.0, 0.0);
  TinySize dstRect(double width, double height) {
    _dst.w = w*width;
    _dst.h = h*height;
    return _dst;
  }
  TinyRect srcRect(double width, double height) {
    _src.x = width*u;
    _src.y = height*v;
    _src.w = w*width;
    _src.h = h*height;
    return _src;
  }
  BitmapFontInfoElem(this.u, this.v, this.w, this.h, this.vx, this.vy, this.vw, this.vh) {
    
  }
}