import 'dart:math' as  math;
import 'package:umiuni2d/tinygame.dart';
import 'package:umiuni2d/tinygame_webgl.dart';
import 'package:vector_math/vector_math_64.dart';
import 'package:touch_test/touch_test.dart';

void main() {
  TinyGameBuilderForWebgl builder = new TinyGameBuilderForWebgl();
  TinyGameRoot root = new TinyGameRoot(400.0,300.0);
  TinyStage stage = builder.createStage(root);
  stage.start();
  PrimitiveTest test = new PrimitiveTest(builder);
  root.addChild(test);
}

