part of tinygame_flutter;

class TinyFlutterAudioSource extends TinyAudioSource {
  MediaPlayerProxy player;
  MojoDataPipeConsumer data;
  TinyFlutterAudioSource(this.player, this.data) {
    ;
  }

  static Future<TinyFlutterAudioSource> create(
      MediaServiceProxy service, MojoDataPipeConsumer data) async {
    MediaPlayerProxy player = new MediaPlayerProxy.unbound();
    return new TinyFlutterAudioSource(player, data);
  }

  Future prepare() async {}

  Future start() async {
    await pause();
    player.ptr.seekTo(0);
    player.ptr.start();
  }

  Future pause() async {
    player.ptr.pause();
  }
}

class TinyFlutterAudioManager {
  MediaServiceProxy service = new MediaServiceProxy.unbound();

  TinyFlutterAudioManager() {
    shell.connectToService(null, service);
  }

  Future<TinyAudioSource> loadAudioSource(String url) async {
    return await TinyFlutterAudioSource.create(
        service, await ResourceLoader.loadMojoData(url));
  }
}
