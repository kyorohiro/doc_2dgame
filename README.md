# MOVE repository
https://github.com/kyorohiro/umiuni2d

<br>
<br>
<br>



# Warning
Umiuni2d use master branch now!!

* 2016/1/9
umiuni2d is not executable on flutter
https://github.com/flutter/flutter/issues/1159

but testcanvas mode is executable

```
  TinyGameBuilderForFlutter builder = new TinyGameBuilderForFlutter(assetsRoot:"web/");
  builder.tickInPerFrame = false;
  builder.useTestCanvas = true;
```

* 2016/1/12
--> current default builder property
builder.useTestCanvas = true;
so, umiuni2d is executable on current flutter.


# Memo: 2d game math x physics (pre now making)

This Book write about 2dgame physics and math. I am making a 2d game library to get this knowledge now.

This Book follow these concept.


## Umiuni2D

![](wonder_minon_AB01.png)

Umiuni2D is 2D Game Library for writing this book.

http://kyorohiro.github.io/umiuni2d/web/demo/wonderminon/main.html
https://github.com/kyorohiro/doc_2dgame
http://kyorohiro.github.io/umiuni2d/web/index.html


#### Use Dart
Umiuni2D use flutter and Dart and WebGL as Develop Environment.

#### multiple-platform library
Umiuni2D's game is executable on android and iOS and modern browser.


## Index
* Math & Sprite
 * Velocity
 * Matrix
 * move
 * rotate
 * scale
 * inverse matrix and touch point
* 2D Physics
 * circle primitive
   * verocity
   * collision
   * rotate
   * grouping
  * other primitve
  * Cellular Automata
* Tech
 * texture atlass
 * algo
