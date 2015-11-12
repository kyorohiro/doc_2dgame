part of gamelogic;


class MinoGame {
  MinoTable table = new MinoTable();
  Minon minon = new Minon.l();

  MinoGame() {
    nextMinon();
  }

  loop() {
    setMinon(minon, true);
    down();
  }

  nextMinon() {
    minon = new Minon.random();
    minon.x = table.fieldWWithFrame ~/ 2;
  }

  down() {
    setMinon(minon, false);
    minon.y++;
    if (collision(minon)) {
      minon.y--;
      setMinon(minon, true);
      nextMinon();
      setMinon(minon, true);
    } else {
      setMinon(minon, true);
    }
  }

  left() {
    setMinon(minon, false);
    minon.x--;
    if (collision(minon)) {
      minon.x++;
      setMinon(minon, true);
    } else {
      setMinon(minon, true);
    }
  }

  right() {
    setMinon(minon, false);
    minon.x++;
    if (collision(minon)) {
      minon.x--;
      setMinon(minon, true);
    } else {
      setMinon(minon, true);
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

