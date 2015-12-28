part of tinygame_flutter;

class TinyGameBuilderForFlutter extends TinyGameBuilder {
  String assetsRoot;
  bool tickInPerFrame = true;
  bool useTestCanvas = false;
  bool useDrawVertexForPrimtive = false;
  TinyFlutterAudioManager audioManager = new TinyFlutterAudioManager();

  TinyGameBuilderForFlutter({this.assetsRoot:"web/"}) {}

  TinyStage createStage(TinyDisplayObject root) {
    return new TinyFlutterStage(this, root,tickInPerFrame:tickInPerFrame, useTestCanvas:useTestCanvas, useDrawVertexForPrimtive:useDrawVertexForPrimtive);
  }

  Future<TinyImage> loadImageBase(String path) async {
    return new TinyFlutterImage(
        await ResourceLoader.loadImage("${assetsRoot}${path}"));
  }

  Future<TinyAudioSource> loadAudio(String path) async {
    return await audioManager.loadAudioSource("${assetsRoot}${path}");
  }

  Future<String> loadStringBase(String path) async {
    String a = await ResourceLoader.loadString("${assetsRoot}${path}");
    return a;
  }

  Future<TinyFile> loadFile(String name) async {
    await initFile();
    File f = new File("${rootPath.path}/${name}");
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

  Future<String> getLocale() async {
    return "en";
  }
}

class TinyFlutterFile extends TinyFile {
  File f;
  TinyFlutterFile(this.f) {
  }

  init() async {
    if(await f.exists() == false) {
      await f.create(recursive: true);
    }
  }

  Future<int> write(List<int> buffer, int offset) async {
    await init();
    RandomAccessFile af = await f.open(mode: FileMode.WRITE);
    await af.setPosition(offset);
    await af.writeFrom(buffer);
    await af.close();
    return buffer.length;
  }

  Future<List<int>> read(int offset, int length) async {
    await init();
    RandomAccessFile af = await f.open();
    await af.setPosition(offset);
    List<int> ret = await af.read(length);
    await af.close();
    return ret;
  }

  Future<int> getLength() async {
    await init();
    return f.length();
  }

  Future<int> truncate(int fileSize) async {
    await init();
    int s = await getLength();
    if(fileSize >= s) {
      return s;
    }
    RandomAccessFile af = await f.open();
    await af.truncate(fileSize);
    int ret = await getLength();
    await af.close();
    return ret;
  }
}
