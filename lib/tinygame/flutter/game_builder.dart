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
    return null;
  }
  Future<List<String>> getFiles() async {
    return [];
  }
}
