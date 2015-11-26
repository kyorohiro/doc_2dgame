library gamelogic;

import 'dart:async';
import 'dart:math' as math;
import 'package:umiuni2d/tinygame.dart';

part 'glogic/glogic.dart';
part 'glogic/minon.dart';
part 'glogic/board.dart';
part 'gui/board.dart';
part 'gui/next.dart';
part 'gui/playscene.dart';
part 'gui/score.dart';
part 'gui/prepare.dart';
part 'gui/start.dart';
part 'gui/clearscene.dart';
part 'gui/resource.dart';

class MinoRoot extends TinyDisplayObject {
  TinyGameBuilder builder;
  MinoGame game = new MinoGame();
  MinoRoot(this.builder) {
    addChild(new ResourceLoader(builder, this));
  }
}

