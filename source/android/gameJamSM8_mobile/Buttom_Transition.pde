class Buttom {
  float x, y, w, h;
  float timer;

  boolean pressed = false;
  boolean confirmed = false;

  Buttom(float x_, float y_, float w_, float h_) {
    x = x_;
    y = y_;
    w = w_;
    h = h_;

    timer = 0;
  }

  boolean selected() {
    return (mouseX - canvas.x > x && mouseX - canvas.x < x+w && mouseY - canvas.y > y && mouseY - canvas.y < y+h);
  }

  void displayRoundedRect() {
    //Display
    stroke(white);
    strokeWeight(em*0.15);
    noFill();
    //fill(blue);
    if (pressed) {
      fill(blueRainHighlight);
    }
    rect(x, y, w, h, 0.5*em, 0.5*em, 0.5*em, 0.5*em);

    update();
  }

  void displayTransparentRoundedRect() {
    //Display
    stroke(white);
    strokeWeight(em*0.15);
    noFill();
    //fill(blue);
    if (pressed) {
      //fill(aLittleLightBlue);
      fill(255, 64);
    }
    rect(x, y, w, h, 0.5*em, 0.5*em, 0.5*em, 0.5*em);

    update();
  }


  void displayTransparentEllipse() {
    //Display
    stroke(white);
    strokeWeight(em*0.15);
    noFill();
    //fill(blue);
    if (pressed) {
      //fill(aLittleLightBlue);
      fill(255, 64);
    }
    //rect(x, y, w, h, 0.5*em, 0.5*em, 0.5*em, 0.5*em);
    ellipse(x+w/2, y+h/2, w, h);

    update();
  }

  void update() {
    confirmed = false;

    if (selected() && mouseReleased) {
      pressed = true;
      //println(this, "pressed");
    }
    if (pressed) {
      timer += time.delta;
      //println(timer);
      if (timer > 30) {
        confirmed = true;
        pressed = false;
        timer = 0;
        //println(this, "confirmed");
      }
    }
  }
}


//class ButtomText {
//  float x, y, w, h;

//  String s;

//  float animationTimer;

//  ButtomText(float x_, float y_, String s_) {
//    s = s_;
//    //textFont(bold);
//    //w = textWidth(s) + 4*em;

//    w = 15*em;
//    h = 3*em;

//    x = x_ - w/2;
//    y = y_ - h/2;

//    animationTimer = random(100);
//  }

//  void display() {
//    float size = em*2/3;
//    cloudCell(x + em, y + h/2 - size/3, size, animationTimer, white);

//    textFont(bold);
//    textAlign(LEFT, CENTER);
//    fill(white);
//    text(s, x + 3*em, y+h/2);

//    //Debug
//    noFill();
//    stroke(255, 255, 0);
//    strokeWeight(1);
//    //rect(x, y, w, h);

//    animationTimer += time.delta*2;
//  }
//}


class Transition {
  float timer;
  float duration;

  Transition() {
    timer = 0;
    duration = 60;
  }

  void run(float d_) {
    duration = d_;
    timer = d_;
  }

  void display() {
    if (timer > 0) {
      timer -= time.delta;
    }

    noStroke();
    fill(blueLake);
    float y = map(timer, 60, 0, height, -height);
    rect(0, y, width, height);
  }
}
