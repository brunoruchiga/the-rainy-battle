class Canvas {
  float x, y, w, h;

  Canvas(float ratio) {
    if (height*ratio>width) { //se tela é vertical
      w = width;
      h = w/ratio;

      x = 0;
      y = height/2 - h/2;
    } else { //se tela é horizontal
      h = height;
      w = h*ratio;

      y = 0;
      x = width/2 - w/2;
    }
  }

  void debug() {
    noFill();
    stroke(255, 255, 0);
    strokeWeight(1);

    rect(x, y, w-1, h-1);
  }

  void grid() {
    for (int i = 0; i <= floor(w/em); i++) {
      for (int j = 0; j <= floor(h/em); j++) {
        stroke(200);
        noFill();
        rect(i*em, j*em, em, em);

        fill(0);
        textFont(font);
        textSize(em/5);
        textAlign(LEFT, TOP);
        text("(" + i + "," + j + ")", i*em, j*em);
      }
    }
  }

  void begin() {
    translate(x, y);
  }

  void end() {
    translate(-x, -y);
  }
}

class PlayArea {
  float x, y, w, h;

  PlayArea(float ratio, float margin) {
    if (canvas.h*ratio>canvas.w) { //se tela é vertical
      w = canvas.w - 2*margin;
      h = w/ratio;

      x = 0 + margin;
      y = canvas.h/2 - h/2;
    } else { //se tela é horizontal
      h = canvas.h - 2*margin;
      w = h*ratio;

      y = 0 + margin;
      x = canvas.w/2 - w/2;
    }
  }

  PlayArea(float x_, float y_, float w_, float h_) {
    x = x_;
    y = y_;
    w = w_;
    h = h_;
  }

  void begin() {
    translate(x, y);
  }

  void end() {
    translate(-x, -y);
  }

  void debug() {
    noFill();
    stroke(255, 255, 0);
    strokeWeight(1);

    rect(x, y, w-1, h-1);
  }
}
