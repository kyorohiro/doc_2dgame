part of gamelogic;


class MinoTableUI extends TinyDisplayObject {
  TinyGameBuilder builder;
  MinoTable table;
  TinyColor colorEmpty = new TinyColor.argb(0xaa, 0x88, 0x88, 0x88);
  TinyColor colorFrame = new TinyColor.argb(0xaa, 0x55, 0x33, 0x33);
  TinyColor colorMinon = new TinyColor.argb(0xaa, 0xaa, 0xff, 0xaa);
  TinyColor colorO = new TinyColor.argb(0xaa, 0xaa, 0xff, 0xaa);
  TinyColor colorS = new TinyColor.argb(0xaa, 0xff, 0xaa, 0xaa);
  TinyColor colorZ = new TinyColor.argb(0xaa, 0xaa, 0xaa, 0xff);
  TinyColor colorJ = new TinyColor.argb(0xaa, 0xaa, 0xff, 0xff);
  TinyColor colorL = new TinyColor.argb(0xaa, 0xff, 0xff, 0xaa);
  TinyColor colorT = new TinyColor.argb(0xaa, 0xff, 0xff, 0xff);
  MinoTableUI(this.builder, this.table) {
    ;
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
          p.color = colorFrame;
        } else if (m.type == MinoTyoe.empty) {
          p.color = colorEmpty;
        } else if (m.type == MinoTyoe.l) {
          p.color = colorMinon;
        } else if (m.type == MinoTyoe.o) {
          p.color = colorO;
        } else if (m.type == MinoTyoe.t) {
          p.color = colorT;
        } else if (m.type == MinoTyoe.s) {
          p.color = colorS;
        } else if (m.type == MinoTyoe.z) {
          p.color = colorZ;
        } else if (m.type == MinoTyoe.j) {
          p.color = colorJ;
        } else if (m.type == MinoTyoe.L) {
          p.color = colorL;
        } else {
          p.color = colorL;
        }
        canvas.drawRect(stage, rect, p);
      }
    }
  }
}