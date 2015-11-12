part of gamelogic;



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