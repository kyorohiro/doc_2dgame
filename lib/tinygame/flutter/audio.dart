part of tinygame_flutter;

class TinyFlutterAudioSource extends TinyAudioSource {
  MediaPlayerProxy player;
  MojoDataPipeConsumer data;
  TinyFlutterAudioSource(this.player, this.data) {

  }

  static Future<TinyFlutterAudioSource> create(
      MediaServiceProxy service, MojoDataPipeConsumer data) async {
    MediaPlayerProxy player = new MediaPlayerProxy.unbound();
    service.ptr.createPlayer(player);
    await player.ptr.prepare(data);
    return new TinyFlutterAudioSource(player, data);
  }

  bool get isPlayerOpen => player != null && player.impl.isOpen;
  Future prepare() async {}

  Future start() async {
    //print("-start");
    //await pause();
   // await player.ptr.prepare(data);
    if (isPlayerOpen) {
//    new Future.delayed(new Duration(milliseconds:10));
    await player.ptr.seekTo(0);
  //  new Future.delayed(new Duration(milliseconds:10));
    await player.ptr.start();
    }
    //print("/start");
  }

  Future pause() async {
    //print("-pause");
    if (isPlayerOpen) {
      await player.ptr.pause();
    }
    //print("/pause");
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
