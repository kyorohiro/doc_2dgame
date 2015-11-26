part of tinygame_flutter;

class TinyGameBuilderForFlutter extends TinyGameBuilder {
  String resourceRoot;
  TinyFlutterAudioManager audioManager = new TinyFlutterAudioManager();

  TinyGameBuilderForFlutter(this.resourceRoot) {}

  TinyStage createStage(TinyDisplayObject root) {
    return new TinyFlutterStage(this, root);
  }

  Future<TinyImage> loadImageBase(String path) async {
    return new TinyFlutterImage(
        await ResourceLoader.loadImage("${resourceRoot}${path}"));
  }

  Future<TinyAudioSource> loadAudio(String path) async {
    return await audioManager.loadAudioSource("${resourceRoot}${path}");
  }

  Future<String> loadStringBase(String path) async {
    String a = await ResourceLoader.loadString("${resourceRoot}${path}");
    return a;
  }

  Future<TinyFile> loadFile(String name) async {
    await initFile();
    File f = new File("${rootPath.path}/dummy.txt");
    return new TinyFlutterFile(f);
  }

  PathServiceProxy pathServiceProxy = null;
  Directory rootPath = null;
  Future initFile() async {
    if (rootPath == null) {
      PathServiceProxy pathServiceProxy = new PathServiceProxy.unbound();
      shell.connectToService("dummy", pathServiceProxy);
      PathServiceGetFilesDirResponseParams dirResponse =
          await pathServiceProxy.ptr.getFilesDir();
      rootPath = new Directory(dirResponse.path);
    }
  }

  Future<List<String>> getFiles() async {
    await initFile();
    List<String> ret = [];
    await for (FileSystemEntity fse in rootPath.list()) {
      ret.add(fse.path.split("/").last);
    }
    return ret;
  }
}

class TinyFlutterFile extends TinyFile {
  File f;
  TinyFlutterFile(this.f) {
  }

  Future<int> write(List<int> buffer, int offset) async {
    RandomAccessFile af = await f.open();
    await af.setPosition(offset);
    af.writeFrom(buffer);
    await af.close();
    return buffer.length;
  }

  Future<List<int>> read(int offset, int length) async {
    RandomAccessFile af = await f.open();
    await af.setPosition(offset);
    List<int> ret = await af.read(length);
    await af.close();
    return ret;
  }

  Future<int> getLength() async {
    return f.length();
  }

  Future<int> truncate(int fileSize) async {
    RandomAccessFile af = await f.open();
    await af.truncate(fileSize);
    int ret = await getLength();
    await af.close();
    return ret;
  }
}
