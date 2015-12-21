part of gamelogic;

class MinoGame {
  MinoTable table = new MinoTable();
  List<Minon> nexts = [];
  Minon get minon => nexts.first;
  Minon get minon2 => nexts[1];

  static final int levelMax = 5;
//  static final List<int> levelAutoDownIntervalTimes = [500, 250, 200, 150, 125];
  static final List<int> levelAutoDownIntervalTimes = [500, 225, 150, 125, 75];
  static final List<int> levelMoveLRIntervalTimes = [150, 150, 125, 125, 125];
  static final List<int> levelMoveDIntervalTimes = [70, 70, 70, 70, 70];
  static final List<int> levelMoveDPlusIntervalTimesFromNext = [150, 150, 150, 150, 150];
  static final List<int> levelRotateIntervalTimes = [200, 200, 200, 200, 200];
  static final List<int> levelClearable = [1, 2, 2, 2, 3];
  static final List<int> levelScoreBase = [6, 7, 8, 9, 10];
  static final List<int> levelups = [2, 5, 6, 10, 50];

  int get moveLRInterval => levelMoveLRIntervalTimes[level];
  int get moveDInterval => levelMoveDIntervalTimes[level];
  int get atuoMoveInterval => levelAutoDownIntervalTimes[level];
  int get rotateInterval => levelRotateIntervalTimes[level];
  int get moveDPlusInterval => levelMoveDPlusIntervalTimesFromNext[level];

  bool _isGmaeOver = false;
  int score = 0;
  int level = 1;
  int baseLevel = 1;

  int lastMoveLRTimeStamp = 0;
  int lastMoveDTimeStamp = 0;
  int lastRotateTimeStamp = 0;
  int lastAutoDownTimeStamp = 0;
  int lastNextTimeStamp = 0;

  List<int> ranking = [0, 0, 0];

  int get no1Score => (ranking.length >= 3 ? ranking[2] : 0);
  int get no2Score => (ranking.length >= 2 ? ranking[1] : 0);
  int get no3Score => (ranking.length >= 1 ? ranking[0] : 0);

  int countOfMinon = 0;

  bool registerNext = false;
  bool registerClear = false;
  MinoGame() {
    nextMinon();
  }
  levelup() {
    if (countOfMinon > levelups[level]) {
      if ((level + 1) < levelups.length) {
        level++;
        countOfMinon=0;
      }
    }
  }

  nextMinon() {
    registerNext = true;
    if (nexts.length > 0) {
      nexts.removeAt(0);
    }
    while (nexts.length < 3) {
      Minon n = new Minon.random();
      n.x = table.fieldWWithFrame ~/ 2;
      n.y = 0;
      nexts.add(n);
    }
  }

  start() {
    table.clear();
    _isGmaeOver = false;
    score = 0;
    level = baseLevel;
  }

  updateScore(int numOfClear) {
    if (numOfClear > 0) {
      score += math.pow(levelScoreBase[level], numOfClear);
      print("${score}");
    }
    if (numOfClear == 4) {
      countOfMinon++;
    }
    levelup();
  }

  bool get isGameOver => _isGmaeOver;

  onTouchStart(int timeStamp) {
    if (lastAutoDownTimeStamp + atuoMoveInterval < timeStamp) {
      lastAutoDownTimeStamp = timeStamp;
      down(timeStamp);
    }
  }

  onTouchEnd(int timeStamp) {}

  bool downWithLevel(int timeStamp, {force: false}) {
    if (force == true || lastMoveDTimeStamp + moveDInterval  < timeStamp) {
      lastMoveDTimeStamp = timeStamp;
      return down(timeStamp);
    } else {
      return false;
    }
  }

  bool downPlusWithLevel(int timeStamp, {force: false}) {
    if (force == true || lastNextTimeStamp + moveDPlusInterval < timeStamp) {
      return down(timeStamp);
    } else {
      return false;
    }
  }

  leftWithLevel(int timeStamp, {bool force: false}) {
    if (force == true || lastMoveLRTimeStamp + moveLRInterval < timeStamp) {
      lastMoveLRTimeStamp = timeStamp;
      left();
    }
  }

  rightWithLevel(int timeStamp, {bool force: false}) {
    if (force == true || lastMoveLRTimeStamp + moveLRInterval < timeStamp) {
      lastMoveLRTimeStamp = timeStamp;
      right();
    }
  }

  bool rotateRWithLevel(int timeStamp, {bool force: false}) {
    if (force == true || lastRotateTimeStamp + rotateInterval < timeStamp) {
      lastRotateTimeStamp = timeStamp;
      rotateR();
      return true;
    } else {
      return false;
    }
  }

  bool rotateLWithLevel(int timeStamp, {bool force: false}) {
    if (force == true || lastRotateTimeStamp + rotateInterval < timeStamp) {
      lastRotateTimeStamp = timeStamp;
      rotateL();
      return true;
    } else {
      return false;
    }
  }

  int clearable = 0;
  bool down(int timeStamp) {
    if (false == move(0, 1)) {
      if (collision(minon2)) {
        if(_isGmaeOver == false) {
          updateRanking();
        }
        _isGmaeOver = true;
      }
      if (clearable >= levelClearable[level]) {
        clearable = 0;
        nextMinon();
        List<int> t = table.clearableLines();
        updateScore(t.length);
        if(t.length > 0) {
          registerClear = true;
          table.clearLines(t);
        }
        lastNextTimeStamp = timeStamp;
      } else {
        clearable += 1;
      }

      return false;
    } else {
      return true;
    }
  }

  updateRanking({currentScore: null}) {
    if (currentScore == null) {
      currentScore = score;
    }
    while (ranking.length < 3) {
      ranking.add(0);
    }
    ranking.add(currentScore);
    ranking.sort();
    if (ranking.length > 3) {
      ranking.removeAt(0);
    }
  }

  left() => move(-1, 0);
  right() => move(1, 0);

  bool move(int dx, int dy) {
    setMinon(minon, false);
    minon.x += dx;
    minon.y += dy;
    if (collision(minon)) {
      minon.x -= dx;
      minon.y -= dy;
      setMinon(minon, true);
      return false;
    } else {
      setMinon(minon, true);
      return true;
    }
  }

  rotateR() {
    setMinon(minon, false);
    for (int xp in [0, -1, 1, -2, 2]) {
      minon.x += xp;
      minon.rotateRight();
      if (!collision(minon)) {
        break;
      } else {
        minon.rotateLeft();
        minon.x -= xp;
      }
    }
    setMinon(minon, true);
  }

  rotateL() {
    setMinon(minon, false);
    for (int xp in [0, -1, 1, -2, 2]) {
      minon.x += xp;
      minon.rotateLeft();
      if (!collision(minon)) {
        break;
      } else {
        minon.rotateRight();
        minon.x -= xp;
      }
    }
    setMinon(minon, true);
  }

  bool collision(Minon minon) {
    for (MinonElm e in minon.minos) {
      Mino m = table.getMino(minon.x + e.x, minon.y + e.y);
      if (!(m.type == MinoTyoe.empty || m.type == MinoTyoe.out)) {
        return true;
      }
    }
    return false;
  }

  setMinon(Minon minon, bool on) {
    for (MinonElm e in minon.minos) {
      Mino m = table.getMino(minon.x + e.x, minon.y + e.y);
      if (m.type != MinoTyoe.out) {
        if (on == true) {
          m.type = e.type;
        } else {
          m.type = MinoTyoe.empty;
        }
      }
    }
  }
}
