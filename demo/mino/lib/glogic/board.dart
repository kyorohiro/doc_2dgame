part of gamelogic;


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
