part of gamelogic;


class MinoGame {
  MinoTable table = new MinoTable();
  List<Minon> nexts = [];
  Minon get minon => nexts.first;
  Minon get minon2 => nexts[1];

  MinoGame() {
    nextMinon();
  }
  
  nextMinon() {
    if(nexts.length > 0) {
      nexts.removeAt(0);
    }
    while(nexts.length < 3) {
     nexts.add(new Minon.random());
    }
    minon.x = table.fieldWWithFrame ~/ 2;
  }

  down() {
    if(false == move(0, 1)){
      nextMinon();
      List<int> t = table.clearableLines();
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

