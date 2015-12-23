part of tinygame_webgl;

class TinyWebglFile extends TinyFile {
  String _filename;
  String get filename => _filename;
  FileEntry _fileEntry = null;
  TinyWebglFile(this._filename) {}

  Future<Entry> init() async {
    await requestQuota();
    if (_fileEntry != null) {
      return _fileEntry;
    }
    FileSystem f = await window.requestFileSystem(1024, persistent: true);
    Entry e = await f.root.createFile(filename);
    _fileEntry = (e as FileEntry);
    return _fileEntry;
  }

  Future<int> requestQuota() {
    Completer<int> ret = new Completer();
    window.navigator.persistentStorage.requestQuota(5 * 1024 * 1024, (a) {
      ret.complete(a);
    }, (b) {
      ret.completeError(b);
    });
    return ret.future;
  }

  Future<int> write(List<int> buffer, int offset) async {
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
    if (len < offset) {
      Uint8List dummy = null;
      dummy = new Uint8List.fromList(new List.filled(offset - len, 0));
      writer.seek(len);
      writer.write(new Blob([dummy, buffer]).slice(0, buffer.length + dummy.length));
    } else {
      writer.seek(offset);
      writer.write(new Blob([buffer]).slice(0, buffer.length));
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
