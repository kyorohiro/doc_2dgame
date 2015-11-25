part of tinygame_webgl;

class TinyGameBuilderForWebgl extends TinyGameBuilder {
  int width = 600 + 100;
  int height = 400 + 100;
  TinyStage createStage(TinyDisplayObject root) {
    return new TinyWebglStage(this, root);
  }

  Future<TinyImage> loadImageBase(String path) async {
    ImageElement elm = await TinyWebglLoader.loadImage(path);
    return new TinyWebglImage(elm);
  }

  Future<TinyAudioSource> loadAudio(String path) async {
    Completer<TinyAudioSource> c = new Completer();
    AudioContext context = new AudioContext();
    HttpRequest request = new HttpRequest();
    request.open("GET", path);
    request.responseType = "arraybuffer";
    request.onLoad.listen((ProgressEvent e) async {
      AudioBuffer buffer = await context.decodeAudioData(request.response);
      c.complete(new TinyWebglAudioSource(context, buffer));
    });
    request.onError.listen((ProgressEvent e) {
      c.completeError(e);
    });
    request.send();
    return c.future;
  }

  Future<String> loadStringBase(String path) async {
    Completer<String> c = new Completer();
    HttpRequest request = new HttpRequest();
    request.open("GET", path);
    request.responseType = "arraybuffer";
    request.onLoad.listen((ProgressEvent e) async {
      ByteBuffer buffer = request.response;
      c.complete(conv.UTF8.decode(buffer.asUint8List(),allowMalformed: true));
    });
    request.onError.listen((ProgressEvent e) {
      c.completeError(e);
    });
    request.send();
    return c.future;
  }
  
  Future<TinyFile> loadFile(String name) {
    return null;
  }
}

class TinyWebglFile extends TinyFile {
  Future<int> write(List<int> buffer, int start,[int length=null]) {
    
  }
  Future<List<int>> read(int offset, int length, {List<int> tmp: null}) {
    ;
  }
  Future<int> getLength() {
    ;
  }
}
