part of tinygame_webgl;

class TinyWebglImage extends TinyImage {
  int get w => elm.width;
  int get h => elm.height;
  ImageElement elm;
  Texture _tex = null;
  RenderingContext cacheGL = null;
  Texture getTex(RenderingContext GL) {
    if (cacheGL != null && cacheGL != GL) {
      dispose();
    }
    if (_tex == null) {
      cacheGL = GL;
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

  @override
  void dispose() {
    try {
      if (_tex != null && cacheGL != null) {
        cacheGL.deleteTexture(_tex);
        _tex = null;
        cacheGL = null;
      }
    } catch (e) {
      print("##ERROR # ${e}");
    }
  }
}
