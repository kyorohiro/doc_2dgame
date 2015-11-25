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
}

class TinyWebglFile extends TinyFile {
  String _filename;
  String get filename => _filename;
  FileEntry _fileEntry = null;
  TinyWebglFile(this._filename) {}

  Future<Entry> init() async {
    if (_fileEntry != null) {
      return _fileEntry;
    }
    FileSystem f = await window.requestFileSystem(1024, persistent: true);
    Entry e = await f.root.createFile(filename);
    _fileEntry = (e as FileEntry);
    return _fileEntry;
  }

  Future<int> write(List<int> buffer, int start, int length) async {
    if (!(buffer is Uint8List)) {
      buffer = new Uint8List.fromList(buffer);
    }

    Completer<int> completer = new Completer();
    await init();
    FileWriter writer = await _fileEntry.createWriter();
    writer.onWrite.listen((ProgressEvent e) {
      completer.complete(buffer.length);
      writer.abort();
    });
    writer.onError.listen((e) {
      completer.completeError({});
      writer.abort();
    });
    int len = await getLength();
    if (len < start) {
      Uint8List dummy = null;
      dummy = new Uint8List.fromList(new List.filled(start - len, 0));
      writer.seek(len);
      writer.write(new Blob([dummy, buffer]).slice(0, length + dummy.length));
    } else {
      writer.seek(start);
      writer.write(new Blob([buffer]).slice(0, length));
    }

    return completer.future;
  }

  Future<List<int>> read(int offset, int length) async {
    Completer<List<int>> c_ompleter = new Completer();
    await init();
    FileReader reader = new FileReader();
    File f = await _fileEntry.file();
    reader.onLoad.listen((_) {
      List<int> data = new List.from(reader.result);
      c_ompleter.complete(data);
    });
    reader.onError.listen((_) {
      c_ompleter.completeError(_);
    });
    reader.readAsArrayBuffer(f.slice(offset, offset + length));
    return c_ompleter.future;
  }

  Future<int> getLength() async {
    await init();
    File f = await _fileEntry.file();
    return f.size;
  }

  Future<int> truncate(int fileSize) async {
    await init();
    FileWriter writer = await _fileEntry.createWriter();
    writer.truncate(fileSize);
    return fileSize;
  }
}
