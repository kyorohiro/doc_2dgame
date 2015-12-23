part of tinygame_webgl;

class TinyGameBuilderForWebgl extends TinyGameBuilder {
  String assetsRoot;
  int width = 600;
  int height = 400;
  int paintInterval = 40;
  int tickInterval = 15;
  TinyGameBuilderForWebgl({this.assetsRoot:""}) {

  }

  TinyStage createStage(TinyDisplayObject root) {
    return new TinyWebglStage(this, root, width:width, height:height, tickInterval:tickInterval, paintInterval:paintInterval);
  }

  Future<TinyImage> loadImageBase(String path) async {
    ImageElement elm = await TinyWebglLoader.loadImage("${assetsRoot}${path}");
    return new TinyWebglImage(elm);
  }

  Future<TinyAudioSource> loadAudio(String path) async {
    print("--A--");
    Completer<TinyAudioSource> c = new Completer();
    AudioContext context = new AudioContext();
    HttpRequest request = new HttpRequest();
    request.open("GET", "${assetsRoot}${path}");
    request.responseType = "arraybuffer";
    request.onLoad.listen((ProgressEvent e) async {
      print("--B--");
      try {
        AudioBuffer buffer = await context.decodeAudioData(request.response);
        c.complete(new TinyWebglAudioSource(context, buffer));
      } catch(e) {
        print("--D-${path}- ${e}");
        c.completeError(e);
      }
    });
    request.onError.listen((ProgressEvent e) {
      print("--C--");
      c.completeError(e);
    });
    request.send();
    print("--D--");
    return c.future;
  }

  Future<String> loadStringBase(String path) async {
    Completer<String> c = new Completer();
    HttpRequest request = new HttpRequest();
    request.open("GET", "${assetsRoot}${path}");
    request.responseType = "arraybuffer";
    request.onLoad.listen((ProgressEvent e) async {
      ByteBuffer buffer = request.response;
      c.complete(conv.UTF8.decode(buffer.asUint8List(), allowMalformed: true));
    });
    request.onError.listen((ProgressEvent e) {
      c.completeError(e);
    });
    request.send();
    return c.future;
  }

  Future<TinyFile> loadFile(String name) async {
    return new TinyWebglFile(name);
  }

  Future<List<String>> getFiles() async {
    FileSystem e = await window.requestFileSystem(1024, persistent: true);
    List<Entry> files = await e.root.createReader().readEntries();
    List<String> ret = [];
    for (Entry e in files) {
      if (e.isFile) {
        ret.add(e.name);
      }
    }
    return ret;
  }
}
