part of gamelogic;


class MinoNextUI extends TinyDisplayObject {
  TinyGameBuilder builder;
  MinoTable table;

  
  MinoNextUI(this.builder) {
    table = new MinoTable(fieldW:5,fieldH:5);
  }

  setMinon(Minon minon) {
    table.clear();
    for (MinonElm e in minon.minos) {
      Mino m = table.getMino(3 + e.x, 3 + e.y);
      if (m.type != MinoTyoe.out) {
        m.type = e.type;
      }
    }
  }

  void onPaint(TinyStage stage, TinyCanvas canvas) {
    TinyRect rect = new TinyRect(0.0, 0.0, 7.0, 7.0);
    TinyPaint p = new TinyPaint();
    p.style = TinyPaintStyle.stroke;
    p.strokeWidth = 1.0;

    for (int y = 0; y < table.fieldHWithFrame; y++) {
      for (int x = 0; x < table.fieldWWithFrame; x++) {
        rect.x = x * 8.0;
        rect.y = y * 8.0;
        Mino m = table.getMino(x, y);
        if (m.type == MinoTyoe.frame) {
          p.color = MinoRoot.colorFrame;
        } else if (m.type == MinoTyoe.empty) {
          p.color = MinoRoot.colorEmpty;
        } else if (m.type == MinoTyoe.l) {
          p.color = MinoRoot.colorMinon;
        } else if (m.type == MinoTyoe.o) {
          p.color = MinoRoot.colorO;
        } else if (m.type == MinoTyoe.t) {
          p.color = MinoRoot.colorT;
        } else if (m.type == MinoTyoe.s) {
          p.color = MinoRoot.colorS;
        } else if (m.type == MinoTyoe.z) {
          p.color = MinoRoot.colorZ;
        } else if (m.type == MinoTyoe.j) {
          p.color = MinoRoot.colorJ;
        } else if (m.type == MinoTyoe.L) {
          p.color = MinoRoot.colorL;
        } else {
          p.color = MinoRoot.colorO;
        }
        canvas.drawRect(stage, rect, p);
      }
    }
  }
}