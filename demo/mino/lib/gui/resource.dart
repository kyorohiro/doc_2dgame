part of gamelogic;

class ResourceLoader extends TinyDisplayObject {
  MinoRoot root;
  TinyGameBuilder builder;
  ResourceLoader(this.builder, this.root) {
    load();
  }

  load() async {
    try {
      await Future.wait([
      builder.loadImage("assets/bg_clear01.png"),
      builder.loadImage("assets/bg_clear02.png"),
      builder.loadImage("assets/bg_clear03.png"),
      builder.loadImage("assets/bg_clear04.png"),
      builder.loadImage("assets/bg_clear05.png")
      ]);
    } catch (e) {}
    ;
    try {
      await Future.wait([
        builder.loadImage("assets/se_start.png"),
        builder.loadString("assets/se_start.json"),
        builder.loadString("assets/se_play.json"),
       builder.loadImage("assets/se_play.png")
      ]);
    } catch (e) {}
    ;

    try {
      await Future.wait([
        builder.loadImage("assets/se_setting.png"),
        builder.loadString("assets/se_setting.json"),
        builder.loadImage("assets/font_a.png"),
        builder.loadString("assets/font_a.json"),
      ]);
    } catch (e) {}
    ;

    await this.root.clearChild();
    await this.root.addChild(root.startScene);
  }

  int count = 0;
  void onPaint(TinyStage stage, TinyCanvas canvas) {
    count++;
    double size = 100.0 + ((count / 2) % 10) * 5;
    canvas.drawRect(
        stage,
        new TinyRect(-size / 2 + 200, -size / 2 + 150, size, size),
        new TinyPaint(color: new TinyColor.argb(0xaa, 0xff, 0xaa, 0xaa)));
  }
}
