part of tinygame_webgl;

class TinyWebglAudioSource extends TinyAudioSource {
  AudioContext context;
  AudioBuffer buffer;
  AudioBufferSourceNode s = null;
  TinyWebglAudioSource(this.context, this.buffer) {}

  Future prepare() async {}
  Future start({double volume: 1.0, bool looping: false}) async {
    await pause();
    s = context.createBufferSource();
    GainNode gain = context.createGain();
    s.connectNode(gain);
    gain.connectNode(context.destination);
    s.buffer = buffer;
    s.loop = looping;
    gain.gain.value = volume;

    s.connectNode(context.destination);
    s.start(0);
  }

  Future pause() async {
    if (s != null) {
      s.stop(0);
      s = null;
    }
  }

  double _volume = 0.5;
  double get volume => _volume;
  void set volume(double v) {
    _volume = v;
  }
}

class TinyWebglImage extends TinyImage {
  int get w => elm.width;
  int get h => elm.height;
  ImageElement elm;
  Texture _tex = null;
  Texture getTex(RenderingContext GL) {
    if (_tex == null) {
      _tex = GL.createTexture();
      GL.bindTexture(RenderingContext.TEXTURE_2D, _tex);
      GL.texImage2D(RenderingContext.TEXTURE_2D, 0, RenderingContext.RGBA, RenderingContext.RGBA, RenderingContext.UNSIGNED_BYTE, elm);
      GL.bindTexture(RenderingContext.TEXTURE_2D, null);
    }
    return _tex;
  }

  TinyWebglImage(this.elm) {
    ;
  }
}
