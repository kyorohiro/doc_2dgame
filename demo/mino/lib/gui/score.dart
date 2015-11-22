part of gamelogic;

class ScoreUI extends TinyDisplayObject {

  SpriteSheetInfo spriteInfo;
  TinyImage image;
  int score = 0;
  int size = 7;
  ScoreUI(this.spriteInfo, this.image) {
    
  }
  
  void onPaint(TinyStage stage, TinyCanvas canvas) {
    if(spriteInfo == null || image == null) {
      return;
    }

    for(int i=0;i<size;i++) {
      int v = (size-1-i);
      v =(v==0?1:math.pow(10,v));
      v = score~/v;
      v = v % 10;
      drawScore(stage, canvas, v, i*12);      
    }
  }
  void drawScore(TinyStage stage, TinyCanvas canvas, int v, int x) {
    TinyPaint p = new TinyPaint();
    TinyRect dst = new TinyRect(0.0+x, 0.0, 15.0, 15.0);
    canvas.drawImageRect(stage, image, 
        spriteInfo.frameFromFileName("NUM00${v}.png").srcRect,
        dst, p);
  }
}