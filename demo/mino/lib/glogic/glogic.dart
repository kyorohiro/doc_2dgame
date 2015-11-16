part of gamelogic;


class MinoGame {
  MinoTable table = new MinoTable();
  List<Minon> nexts = [];
  Minon get minon => nexts.first;
  Minon get minon2 => nexts[1];
  
  bool _isGmaeOver = false;
  int score = 0;
  int level = 1;

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
  }
  
  updateScore(int numOfClear) {
    if(numOfClear > 0) {
      score += math.pow(level*10, numOfClear);
    }
  }

  bool get isGameOver =>_isGmaeOver;

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

