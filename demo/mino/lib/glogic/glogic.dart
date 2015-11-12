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


class MinoTable {
  List<Mino> minos = [];
  final int fieldW;
  final int fieldH;

  int get fieldWWithFrame => fieldW + 2;
  int get fieldHWithFrame => fieldH + 1;

  Mino outMino = new Mino(MinoTyoe.out);
  MinoTable({this.fieldW: 11, this.fieldH: 21}) {
    for (int y = 0; y < fieldHWithFrame; y++) {
      for (int x = 0; x < fieldWWithFrame; x++) {
        if (x == 0 || x == fieldWWithFrame - 1 || y == fieldH) {
          minos.add(new Mino(MinoTyoe.frame));
        } else {
          minos.add(new Mino(MinoTyoe.empty));
        }
      }
    }
  }

  Mino getMino(int x, int y) {
    if (x < 0 || x >= fieldHWithFrame || y < 0 || y >= fieldHWithFrame) {
      return outMino;
    }
    return minos[x + y * fieldWWithFrame];
  }
}

enum MinoTyoe { empty, frame, out, l, o, s, z, j, t, L }

class Minon {
  int x = 0;
  int y = 0;
  List<MinonElm> minos = [];
  static math.Random r = new math.Random();
  factory Minon.random() {
    switch (r.nextInt(7)) {
      case 0:
        return new Minon.l();
      case 1:
        return new Minon.o();
      case 2:
        return new Minon.s();
      case 3:
        return new Minon.z();
      case 4:
        return new Minon.L();
      case 5:
        return new Minon.j();
      case 6:
        return new Minon.t();
      case 7:
        print("#### WARNING");
    }
  }
  Minon.l() {
    minos.add(new MinonElm(MinoTyoe.l, 0, 0));
    minos.add(new MinonElm(MinoTyoe.l, -1, 0));
    minos.add(new MinonElm(MinoTyoe.l, 1, 0));
    minos.add(new MinonElm(MinoTyoe.l, 2, 0));
  }
  Minon.o() {
    minos.add(new MinonElm(MinoTyoe.o, 0, 0));
    minos.add(new MinonElm(MinoTyoe.o, 1, 0));
    minos.add(new MinonElm(MinoTyoe.o, 0, -1));
    minos.add(new MinonElm(MinoTyoe.o, 1, -1));
  }
  Minon.s() {
    minos.add(new MinonElm(MinoTyoe.s, 0, 0));
    minos.add(new MinonElm(MinoTyoe.s, 1, 0));
    minos.add(new MinonElm(MinoTyoe.s, 0, -1));
    minos.add(new MinonElm(MinoTyoe.s, -1, -1));
  }
  Minon.z() {
    minos.add(new MinonElm(MinoTyoe.z, 0, 0));
    minos.add(new MinonElm(MinoTyoe.z, -1, 0));
    minos.add(new MinonElm(MinoTyoe.z, 0, -1));
    minos.add(new MinonElm(MinoTyoe.z, 1, -1));
  }
  Minon.L() {
    minos.add(new MinonElm(MinoTyoe.L, 1, 0));
    minos.add(new MinonElm(MinoTyoe.L, 1, -1));
    minos.add(new MinonElm(MinoTyoe.L, 0, 0));
    minos.add(new MinonElm(MinoTyoe.L, -1, 0));
  }
  Minon.j() {
    minos.add(new MinonElm(MinoTyoe.j, -1, 0));
    minos.add(new MinonElm(MinoTyoe.j, -1, -1));
    minos.add(new MinonElm(MinoTyoe.j, 0, 0));
    minos.add(new MinonElm(MinoTyoe.j, 1, 0));
  }
  Minon.t() {
    minos.add(new MinonElm(MinoTyoe.t, -1, 0));
    minos.add(new MinonElm(MinoTyoe.t, 0, -1));
    minos.add(new MinonElm(MinoTyoe.t, 0, 0));
    minos.add(new MinonElm(MinoTyoe.t, 1, 0));
  }
  rotateRight() {
    for (MinonElm e in minos) {
      int t = e.x;
      e.x = -1 * e.y;
      e.y = t;
    }
  }

  rotateLeft() {
    for (MinonElm e in minos) {
      int t = e.x;
      e.x = e.y;
      e.y = -1 * t;
    }
  }
}

class MinonElm extends Mino {
  int x;
  int y;
  MinonElm(MinoTyoe type, this.x, this.y) : super(type) {
    ;
  }
}

class Mino {
  MinoTyoe type;
  Mino(this.type) {}
}
