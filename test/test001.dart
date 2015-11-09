import 'package:umiuni2d/tinygame.dart';
import 'package:test/test.dart' as test;


String json001 = """
{"frames": [

{
  "filename": "C-001-0001_00000.png",
  "frame": {"x":0,"y":0,"w":300,"h":300},
  "rotated": false,
  "trimmed": false,
  "spriteSourceSize": {"x":0,"y":0,"w":300,"h":300},
  "sourceSize": {"w":300,"h":300},
  "pivot": {"x":0.5,"y":0.5}
},
{
  "filename": "C-001-0001_00001.png",
  "frame": {"x":0,"y":300,"w":300,"h":300},
  "rotated": false,
  "trimmed": false,
  "spriteSourceSize": {"x":0,"y":0,"w":300,"h":300},
  "sourceSize": {"w":300,"h":300},
  "pivot": {"x":0.5,"y":0.5}
}]
}
""";


void main() {
  test.test("..", () {
    SpriteSheetInfo sheet = new SpriteSheetInfo.fronmJson(json001);
    test.expect(2, sheet.frames.length);
    test.expect("C-001-0001_00000.png", sheet.frames[0].fileName);
    test.expect(new TinyRect(0.0, 0.0, 300.0, 300.0), sheet.frames[0].frame);
    test.expect(new TinyPoint(0.5,0.5), sheet.frames[0].pivot);
    test.expect(false, sheet.frames[0].rotated);
    test.expect(false, sheet.frames[0].trimmed);
    test.expect(new TinyRect(0.0, 0.0, 300.0, 300.0), sheet.frames[0].spriteSourceSize);
    test.expect(new TinySize(300.0, 300.0), sheet.frames[0].sourceSize);
    
    //
    //
    //
    test.expect(2, sheet.frames.length);
    test.expect("C-001-0001_00001.png", sheet.frames[1].fileName);
    test.expect(new TinyRect(0.0, 300.0, 300.0, 300.0), sheet.frames[1].frame);
    test.expect(new TinyPoint(0.5,0.5), sheet.frames[1].pivot);
    test.expect(false, sheet.frames[1].rotated);
    test.expect(false, sheet.frames[1].trimmed);
    test.expect(new TinyRect(0.0, 0.0, 300.0, 300.0), sheet.frames[1].spriteSourceSize);
    test.expect(new TinySize(300.0, 300.0), sheet.frames[1].sourceSize);
  });
}
