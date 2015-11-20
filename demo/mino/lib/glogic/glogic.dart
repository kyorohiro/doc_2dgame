part of gamelogic;


class MinoGame {
  MinoTable table = new MinoTable();
  List<Minon> nexts = [];
  Minon get minon => nexts.first;
  Minon get minon2 => nexts[1];
  
  static final int levelMax = 5;
  static final List<int> levelAutoDownIntervalTimes = [500, 250, 200, 150, 110];
  static final List<int> levelMoveIntervalTimes = [150, 150, 125, 100, 85];
  static final List<int> levelRotateIntervalTimes = [150, 125, 100, 95, 85];
  int get moveInterval => levelMoveIntervalTimes[level];
  int get atuoMoveInterval => levelAutoDownIntervalTimes[level]; 
  int get rotateInterval =>levelRotateIntervalTimes[level];

  bool _isGmaeOver = false;
  int score = 0;
  int level = 1;
  int baseLevel = 1;

  int lastMoveTimeStamp = 0;
  int lastRotateTimeStamp = 0;
  int lastAutoDownTimeStamp = 0;
  MinoGame() {
    nextMinon();
  }
  
  nextMinon() {
    if(nexts.length > 0) {
      nexts.removeAt(0);
    }
    while(nexts.length < 3) {
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
    if(numOfClear > 0) {
      score += math.pow(level*10, numOfClear);
    }
  }

  bool get isGameOver =>_isGmaeOver;

  onTouchStart(int timeStamp) {
    if(lastAutoDownTimeStamp+atuoMoveInterval < timeStamp) {
      lastAutoDownTimeStamp = timeStamp;
      down();
    }
  }
  onTouchEnd(int timeStamp) {
    
  }
  downWithLevel(int timeStamp, {fource:false}) {
    if(fource == true || lastMoveTimeStamp+moveInterval/2 < timeStamp) {
      lastMoveTimeStamp = timeStamp;
      down();
    }
  }

  leftWithLevel(int timeStamp){
    if(lastMoveTimeStamp+moveInterval < timeStamp) {
      lastMoveTimeStamp = timeStamp;
      left();
    }
  }

  rightWithLevel(int timeStamp){
    if(lastMoveTimeStamp+moveInterval  < timeStamp) {
      lastMoveTimeStamp = timeStamp;
      right();
    }
  }

  rotateRWithLevel(int timeStamp){
    if(lastRotateTimeStamp+rotateInterval < timeStamp) {
      lastRotateTimeStamp = timeStamp;
      rotateR();
    }
  }
  rotateLWithLevel(int timeStamp){
    if(lastRotateTimeStamp+rotateInterval < timeStamp) {
      lastRotateTimeStamp = timeStamp;
      rotateL();
    }
  }
  down() {
    if(false == move(0, 1)){
      if(collision(minon2)){
        _isGmaeOver = true;
      }
      nextMinon();
      List<int> t = table.clearableLines();
      updateScore(t.length);
      table.clearLines(t);
    }
  }

  left() => move(-1, 0);
  right() => move(1, 0);

  bool move(int dx, int dy) {
    setMinon(minon, false);
    minon.x += dx;
    minon.y += dy;
    if (collision(minon)) {
      minon.x-=dx;
      minon.y-=dy;
      setMinon(minon, true);
      return false;
    } else {
      setMinon(minon, true);
      return true;
    }
  }

  rotateR() {
    setMinon(minon, false);
    minon.rotateRight();
    if (collision(minon)) {
      minon.rotateLeft();
      setMinon(minon, true);
    } else {
      setMinon(minon, true);
    }
  }

  rotateL() {
    setMinon(minon, false);
    minon.rotateRight();
    if (collision(minon)) {
      minon.rotateLeft();
      setMinon(minon, true);
    } else {
      setMinon(minon, true);
    }
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

