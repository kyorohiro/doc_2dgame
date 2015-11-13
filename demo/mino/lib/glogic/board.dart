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

  clear() {
    for (int y = 0; y < fieldHWithFrame; y++) {
      for (int x = 0; x < fieldWWithFrame; x++) {
        if (x == 0 || x == fieldWWithFrame - 1 || y == fieldH) {
          getMino(x, y).type = MinoTyoe.frame;
        } else {
          getMino(x, y).type = MinoTyoe.empty;
        }
      }
    }
  }

  Mino getMino(int x, int y) {
    if (x < 0 || x > fieldHWithFrame || y < 0 || y > fieldHWithFrame) {
      return outMino;
    }
    return minos[x + y * fieldWWithFrame];
  }
  
  List<int> clearableLines() {
    List<int> ret = [];
    bool cleable = true;
    for (int y = 0; y < fieldHWithFrame-1; y++) {
      cleable = true;
      for (int x = 1; x < fieldWWithFrame-1; x++) {
       if(getMino(x, y).type == MinoTyoe.empty) {
         cleable = false;
         break;
       }
      }
      //
      if(cleable == true) {
        ret.add(y);
      }
    }
    ret.sort();
    return ret;
  }
  
  clearLines(List<int> target) {
    for(int v in target) {
      clearLine(v);
    }
  }

  clearLine(int yS) {
    for (int y = yS; y >=0; y--) {
      for (int x = 1; x < fieldWWithFrame-1; x++) {
        if(getMino(x, y-1).type == MinoTyoe.out) {
          getMino(x, y).type = MinoTyoe.empty;   
        } else {
         getMino(x, y).type = getMino(x, y-1).type;
        }
      }
    }
  }
}
