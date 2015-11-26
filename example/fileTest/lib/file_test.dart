import 'package:umiuni2d/tinygame.dart';
import 'dart:math' as math;
import 'dart:convert' as conv;

class FileTest extends TinyDisplayObject {
  TinyGameBuilder builder;
  FileTest(this.builder) {
    mat.rotateZ(math.PI / 10);
    initA();
  }

  initA() async {
    {
      List<String> ss = await builder.getFiles();
      for (String s in ss) {
        print("[0]file:${s}");
        TinyFile f = await builder.loadFile(s);
        List<int> v = await f.read(0, await f.getLength());
        print("[0]value:${conv.UTF8.decode(v)}");
      }
    }
    TinyFile f = await builder.loadFile("test1.dat");
    await f.write(conv.UTF8.encode("abcdef"), 0);

    {
      List<String> ss = await builder.getFiles();
      for (String s in ss) {
        print("[1]file:${s}");
      }
    }
  }

  void onPaint(TinyStage stage, TinyCanvas canvas) {}
}
