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

class VisibleAreaWithBorders {
  float x, y, w, h;
  //float finalH;

  VisibleAreaWithBorders(float x_, float y_, float w_, float h_) {
    x = x_ + canvas.x;
    y = y_ + canvas.y;
    w = w_;
    h = h_;
    
    //finalH = h_;
  }
  
  VisibleAreaWithBorders(PlayArea pA) {
    x = pA.x + canvas.x;
    y = pA.y + canvas.y;
    w = pA.w;
    h = pA.h;
    
    //finalH = pA.h;
  }

  void display() {
    //h = lerp(h, finalH, 0.2);
    
    fill(blueClouds);
    noStroke();
    rect(0, 0, width, y); //top
    rect(x+w, 0, width-x-w, height); //right
    rect(0, y+h, width, height-y-h); //bottom
    rect(0, 0, x, height); //left

    //Linhas-nuvem
    float size = 3*em;
    float posVariationAmount = em;
    cloudLine(x, y, x+w, y, w, size, time.realFrameCount+100, 0, -posVariationAmount); //top
    cloudLine(x+w, y, x+w, y+h, h, size, time.realFrameCount+200, posVariationAmount, 0); //right
    cloudLine(x+w, y+h, x, y+h, w, size, time.realFrameCount+300, 0, posVariationAmount); //bottom
    cloudLine(x, y+h, x, y, h, size, time.realFrameCount+400, -posVariationAmount, 0); //left

    //cloudLine(canvas.x+em, canvas.y, canvas.x + canvas.w - em, canvas.y, time.realFrameCount+0);
    //cloudLine(canvas.x+em, canvas.y+canvas.h-em, canvas.x + canvas.w - em, canvas.y+canvas.h-em, time.realFrameCount+1);
    //cloudLine(canvas.x+em, canvas.y, canvas.x + em, canvas.y + canvas.h-em, time.realFrameCount+2);
    //cloudLine(canvas.x+canvas.w-em, canvas.y+em, canvas.x + canvas.w - em, canvas.y+canvas.h-em, time.realFrameCount+3);
  }
  
  void debug() {
    stroke(red);
    strokeWeight(1);
    line(x, y, x+w, y); //top
    line(x+w, y, x+w, y+h); //right
    line(x+w, y+h, x, y+h); //bottom
    line(x, y+h, x, y); //left
  }
}
