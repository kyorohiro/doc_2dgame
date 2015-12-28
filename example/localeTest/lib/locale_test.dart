import 'package:umiuni2d/tinygame.dart';
import 'dart:math' as math;
import 'dart:convert' as conv;

class LocaleTest extends TinyDisplayObject {
  TinyGameBuilder builder;
  LocaleTest(this.builder) {
    initA();
  }

  initA () async {
    print("### locale:${await builder.getLocale()}");
  }

  void onPaint(TinyStage stage, TinyCanvas canvas) {

  }
}
