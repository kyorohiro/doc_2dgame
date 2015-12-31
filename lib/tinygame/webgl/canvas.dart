part of tinygame_webgl;

class TinyWebglContext {
  RenderingContext GL;
  CanvasElement _canvasElement;
  CanvasElement get canvasElement => _canvasElement;
  double widht;
  double height;
  TinyWebglContext({width: 600.0, height: 400.0, String selectors: null}) {
    this.widht = width;
    this.height = height;
    if (selectors == null) {
      _canvasElement = new CanvasElement(width: widht.toInt(), height: height.toInt());
    } else {
      _canvasElement = window.document.querySelector(selectors);
      if (width != null) {
        _canvasElement.width = width;
      }
      if (height != null) {
        _canvasElement.height = height;
      }
    }

    document.body.append(_canvasElement);
    GL = _canvasElement.getContext3d(stencil: true);
  }
}
