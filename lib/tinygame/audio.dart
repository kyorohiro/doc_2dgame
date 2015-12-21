part of tinygame;

abstract class TinyAudioSource {
  Future prepare();
  //Future seek(int msec);
  Future start();
  Future pause();
}
