import 'package:umiuni2d/tinygame.dart';
import 'package:test/test.dart' as test;


String json001 = """
{
"12354":{"u":0.1640625,"v":0,"w":0.1640625,"h":0.1640625,"vx":0,"vy":0,"vw":42,"vh":42},
"12356":{"u":0,"v":0,"w":0.1640625,"h":0.1640625,"vx":0,"vy":0,"vw":42,"vh":42}
}
""";


void main() {
  test.test("..", () {
    BitmapFontInfo infos = new BitmapFontInfo.fromJson(json001);
    test.expect(infos.r["あ".codeUnitAt(0)].u, 0.1640625);
    test.expect(infos.r["あ".codeUnitAt(0)].v, 0.0);
    test.expect(infos.r["あ".codeUnitAt(0)].w,0.1640625);
    test.expect(infos.r["あ".codeUnitAt(0)].h,0.1640625);
    test.expect(infos.r["あ".codeUnitAt(0)].vx,0.0);
    test.expect(infos.r["あ".codeUnitAt(0)].vy,0.0);
    test.expect(infos.r["あ".codeUnitAt(0)].vw,42.0);
    test.expect(infos.r["あ".codeUnitAt(0)].vh,42.0);
    test.expect(new TinyRect(42.0,0.0,42.0,42.0), infos.r["あ".codeUnitAt(0)].srcRect(256.0, 256.0));
    test.expect(new TinySize(42.0,42.0),  infos.r["あ".codeUnitAt(0)].dstRect(256.0, 256.0));
    test.expect(new TinyRect(0.0,0.0,42.0,42.0),  infos.r["い".codeUnitAt(0)].srcRect(256.0, 256.0));
    test.expect(new TinySize(42.0,42.0),  infos.r["い".codeUnitAt(0)].dstRect(256.0, 256.0));
  });
}
