library gamelogic;

import 'dart:async';
import 'dart:math' as math;
import 'dart:convert' as conv;
import 'package:umiuni2d/tinygame.dart';

part 'glogic/glogic.dart';
part 'glogic/minon.dart';
part 'glogic/board.dart';
part 'gui/board.dart';
part 'gui/next.dart';
part 'gui/play.dart';
part 'gui/score.dart';
part 'gui/prepare.dart';
part 'gui/start.dart';
part 'gui/clears.dart';
part 'gui/resource.dart';
part 'gui/snow.dart';

class MinoRoot extends TinyDisplayObject {
  TinyGameBuilder builder;
  MinoGame game = new MinoGame();
  ResourceLoader loaderScene;
  StartScene startScene;
  PrepareScene prepareScene;
  ClearScene clearScene;
  PlayScene playScene;
  Database database;
  MinoRoot(this.builder) {
    database = new Database(builder);
    loaderScene = new ResourceLoader(builder, this);
    startScene = new StartScene(builder, this);
    prepareScene = new PrepareScene(builder, this);
    clearScene = new ClearScene(builder, this, 0);
    playScene = new PlayScene(builder, this, this.game, level:1);
    addChild(loaderScene);
    loadScore();
  }

  loadScore() async {
    await database.load();
    List<int> r = await database.getRank();
    for (int i in r) {
      game.updateRanking(currentScore: i);
    }
  }
}

class Database {
  List<int> rank = [0, 0, 0];
  TinyGameBuilder builder;
  Database(this.builder) {}

  Future<List<int>> getRank() async {
    return new List.from(rank);
  }

  Future setRank(List<int> _rank) async {
    this.rank.clear();
    this.rank.addAll(_rank);
  }

  Future<String> createData() async {
    String v = conv.JSON.encode({"v": "1", "rank": rank});
    print("##${v}");
    return v;
  }

  load() async {
    try {
      TinyFile f = await builder.loadFile("database.dat");
      List<int> t = await f.read(0, await f.getLength());
      String v = conv.UTF8.decode(t);
      print("##### load database.dat ${v}");
      Map d = conv.JSON.decode(v);
      rank.clear();
      for (int v in d["rank"]) {
        print("##${v}");
        rank.add(v);
      }
    } catch (e) {
      ;
    }
  }

  save() async {
    TinyFile f = await builder.loadFile("database.dat");
    try {
      await f.truncate(0);
    } catch(e) {
      print("e: truncate ${e}");
    }
    f.write(conv.UTF8.encode(await createData()), 0);
  }
}
