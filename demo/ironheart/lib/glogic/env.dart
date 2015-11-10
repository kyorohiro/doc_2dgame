part of glogic;

class GameEnvirone {
  World world = new World();

  GameTarget _targetRed;
  GameTarget _targetBlue;
  GameTarget get targetRed => _targetRed;
  GameTarget get targetBlue => _targetBlue;
  List<GameBullet> bullets = [];
  double fieldX = 50.0;
  double fieldY = 50.0;
  double fieldWidth = 700.0;
  double fieldHeight = 500.0;

  GameEnvirone() {
    _targetRed = new GameTargetSource(this, 50.0, "red");
    _targetBlue = new GameTargetSource(this, 50.0, "blue");
    world.primitives.add(_targetRed);
    world.primitives.add(_targetBlue);

    //
    //
    bullets.add(new GameBullet()
      ..xy.x = 100.0
      ..xy.y = 100.0
      ..radius = 3.5);
  }

  String getEnemy(GameTarget own) {
    if (own.groupName != targetRed.groupName) {
      return targetRed.groupName;
    } else if (own.groupName != targetBlue.groupName) {
      return targetBlue.groupName;
    }
    return null;
  }

  void next(int timeStamp) {
    List<GameTarget> l = [targetRed, targetBlue];
    for (GameTarget t in l) {
      t.program.next(this, t);
      //  t.next(1.0);
    }
    world.next(1.0);
  }

  bool searchEnemy(GameTarget base, double direction, double range,
      double startDist, double endDist) {
    List<Primitive> p =
        world.searchPrimitive(base, direction, range,
          startDist, endDist,
          kind:getEnemy(base));
    if (0 < p.length) {
      return true;
    } else {
      return false;
    }
  }

  static double normalizeAngle(double a) {
    a += math.PI * 2 * 4;
    a = a % (2 * math.PI);
    if (a < math.PI) {
      return a;
    } else {
      return -math.PI + (a - math.PI);
    }
  }

  void init() {
    targetRed.angle = 0.0; //-math.PI/1.4;
    targetRed.dx = 0.0;
    targetRed.dy = 0.0;
    targetRed.x = 200.0;
    targetRed.y = 300.0;

    targetBlue.angle = math.PI;
    targetBlue.dx = 0.0;
    targetBlue.dy = 0.0;
    targetBlue.x = 700.0;
    targetBlue.y = 300.0;
  }

  void red() {
    //
    targetBlue.program.setTip(1, 1, new GameTip.nop(dx: 0, dy: 1));
    targetBlue.program.setTip(1, 2, new GameTip.nop(dx: 0, dy: 1));
    targetBlue.program.setTip(1, 3, new GameTip.nop(dx: 0, dy: 1));
    targetBlue.program.setTip(1, 4, new GameTip.turningRight(dx: -1, dy: 0));

    //
    targetRed.program.setTip(1, 1, new GameTip.nop(dx: 0, dy: 1));
    targetRed.program.setTip(1, 2, new GameTip.nop(dx: 0, dy: 1));
    targetRed.program.setTip(1, 3, new GameTip.nop(dx: 0, dy: 1));
    targetRed.program.setTip(1, 4, new GameTip.nop(dx: 0, dy: 1));
    targetRed.program.setTip(
        1, 5, new GameTip.searchEnemy(yesDx: 1, yesDy: 0, noDx: -1, noDy: 0));
    targetRed.program.setTip(2, 5, new GameTip.front(dx: 1, dy: 0));
    targetRed.program.setTip(3, 5, new GameTip.front(dx: 1, dy: 0));
    targetRed.program.setTip(4, 5, new GameTip.front(dx: 0, dy: 1));
  }
}
