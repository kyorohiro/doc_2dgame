part of tinygame;

abstract class TinyAudioSource {
  Future prepare();
  //Future seek(int msec);
  Future start({double volume:1.0, bool looping:false});
  Future pause();
}
