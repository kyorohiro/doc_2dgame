import 'dart:html';
import 'dart:async';
import 'dart:web_gl';
import 'dart:typed_data';

List<String> vsSource = [
  "attribute vec3 vertexPosition;",
  "attribute vec2 texCoord;",
  "varying vec2 textureCoord;",
  "void main() {",
  "  textureCoord = texCoord;",
  "  gl_Position = vec4(vertexPosition, 1.0);",
  "}"];

List<String> fsSource = [
  "precision mediump float;",
  "uniform sampler2D texture;",
  "varying vec2 textureCoord;",
  "void main() {",
  " gl_FragColor = texture2D(texture, textureCoord);",
  "}"
  ];


main() async {
  ImageElement elm = await loadImage("chara.jpeg");
  CanvasElement canvasElement = new CanvasElement(width: 600, height: 500);
  document.body.append(canvasElement);
  document.body.append(new Text("ad"));

  RenderingContext GL = canvasElement.getContext3d();
  await new Future.delayed(new Duration(seconds:5));
  GL.clearColor(0.5, 0.8, 0.8, 0.7);
  GL.clearDepth(1.0);
  GL.clear(COLOR_BUFFER_BIT);
  GL.flush();
 
  //
  // shader
  Shader vs = GL.createShader(VERTEX_SHADER);
  GL.shaderSource(vs, vsSource.join("\n"));
  GL.compileShader(vs);

  Shader fs = GL.createShader(FRAGMENT_SHADER);
  GL.shaderSource(fs, fsSource.join("\n"));
  GL.compileShader(fs);
 
  Program pro = GL.createProgram();
  GL.attachShader(pro, vs);
  GL.attachShader(pro, fs);
  GL.linkProgram(pro);
  GL.useProgram(pro);
  
  //
  // texture
  Texture tex = GL.createTexture();
  GL.bindTexture(TEXTURE_2D, tex);
  GL.texImage2D(TEXTURE_2D, 0, RGBA, RGBA, UNSIGNED_BYTE, elm);
  GL.bindTexture(TEXTURE_2D, null);
  GL.bindTexture(TEXTURE_2D, tex);

  GL.texParameteri(TEXTURE_2D, TEXTURE_WRAP_S,  CLAMP_TO_EDGE);
  GL.texParameteri(TEXTURE_2D, TEXTURE_WRAP_T,  CLAMP_TO_EDGE);
  GL.texParameteri(TEXTURE_2D, TEXTURE_MIN_FILTER, NEAREST);
  GL.texParameteri(TEXTURE_2D, TEXTURE_MAG_FILTER, NEAREST);
  
  
  //
  //
  Buffer vertexBuffer = GL.createBuffer();
  Buffer indexBuffer = GL.createBuffer();
  int vertexPositionLocation = GL.getAttribLocation(pro, "vertexPosition");
  int texCoordLocation     = GL.getAttribLocation(pro, "texCoord");
  
  
   GL.bindBuffer(ARRAY_BUFFER, vertexBuffer);
  
   GL.enableVertexAttribArray(vertexPositionLocation);
   GL.enableVertexAttribArray(texCoordLocation);
  
   GL.vertexAttribPointer(vertexPositionLocation, 3, FLOAT, false, (3+2)*Float32List.BYTES_PER_ELEMENT, 0);
   GL.vertexAttribPointer(texCoordLocation, 2, FLOAT, false, (3+2)*Float32List.BYTES_PER_ELEMENT, 3 * Float32List.BYTES_PER_ELEMENT);
  
   Float32List vertices = new Float32List.fromList(<double>[
     -1.0,  1.0, 0.0, 0.0, 0.0,       
      1.0,  1.0, 0.0, 1.0, 0.0,
     -1.0, -1.0, 0.0, 0.0, 1.0,
      1.0, -1.0, 0.0, 1.0, 1.0]);
  
   Uint16List indices = new Uint16List.fromList(<int>[
      0, 1, 2, 2, 3, 1]);
  
   GL.bindBuffer(ARRAY_BUFFER, vertexBuffer);
   GL.bufferDataTyped(ARRAY_BUFFER, vertices, STATIC_DRAW);
  
   GL.bindBuffer(ELEMENT_ARRAY_BUFFER, indexBuffer);
   GL.bufferDataTyped(ELEMENT_ARRAY_BUFFER, indices, STATIC_DRAW);
  
   GL.drawElements(TRIANGLES, indices.length, UNSIGNED_SHORT, 0);
}

Future<ImageElement> loadImage(String resName) async {
  ImageElement elm = new ImageElement(src: resName);
  Completer c = new Completer();
  elm.onLoad.listen(c.complete);
  await c.future;
  return elm;
}
