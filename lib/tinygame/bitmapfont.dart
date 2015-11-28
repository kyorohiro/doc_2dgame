//
// use http://sapphire-al2o3.github.io/font_tex/
//
part of tinygame;

enum BitmapFontInfoType {
  vertical,
  horizontal
}
class BitmapFontInfo {

  Map<int,BitmapFontInfoElem> r = {};
  int errorCodeUnit = " ".codeUnitAt(0);

  BitmapFontInfoElem getFromCOdeUnit(int unit) {
    if(r.containsKey(unit)) {
      return r[unit];
    } else {
      return r[errorCodeUnit];
    }
  }

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
  
  TinyPaint p = new TinyPaint();
  drawText(TinyStage stage,TinyCanvas canvas, TinyImage fontImg, 
           String text, double height,TinyRect rect,
           {BitmapFontInfoType vertical:BitmapFontInfoType.horizontal}) {
    TinyRect src = new TinyRect(0.0, 0.0, 0.0, 0.0);
    TinyRect dst= new TinyRect(0.0, 0.0, 0.0, 0.0);

    double x = rect.x;
    double y = rect.y;
    double imgW = fontImg.w.toDouble();
    double imgH = fontImg.h.toDouble();
    for(int unit in text.codeUnits) {
      BitmapFontInfoElem elm = getFromCOdeUnit(unit);
      src.w = elm.srcRect(imgW, imgH).w;
      src.h = elm.srcRect(imgW, imgH).h;
      src.x = elm.srcRect(imgW, imgH).x;
      src.y = elm.srcRect(imgW, imgH).y;
      dst.x = x;
      dst.y = y;
      dst.w = src.w*height/src.h;
      dst.h = height;
      if((dst.x+dst.w) > rect.w) {
        dst.x  = rect.x;
        dst.y  += height + 5;
      }
      canvas.drawImageRect(stage, fontImg, src, dst, p);
      x = dst.x+dst.w + 2;
      y = dst.y;
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
  TinySize dstSize(double width, double height) {
    _dst.w = w*width;
    _dst.h = h*height;
    return _dst;
  }
  TinyRect srcRect(double width, double height) {
    _src.x = width*u;
    _src.y = height-height*(v)-h*height;
    _src.w = w*width;
    _src.h = h*height;
    return _src;
  }
  BitmapFontInfoElem(this.u, this.v, this.w, this.h, this.vx, this.vy, this.vw, this.vh) {
    
  }
}