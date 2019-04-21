class Menu {
  Buttom back = new Buttom(em, em, 2*em, 2*em);

  Menu() {
  }

  void display() {
  }

  void bg() {
    background(blue);
  }

  //void oldHome() {
  //  background(darkBlue);

  //  if (time.realFrameCount % 90 < 30) {
  //    if (time.realFrameCount % 12 < 4) {
  //      background(white);
  //    }
  //  }
  //  rayOpening(0, 0, width, height, 4*em);

  //  canvas.begin();
  //  {
  //    //float angle = time.realFrameCount * 0.001;
  //    //rayOpening(canvas.w/2 - cos(angle) * canvas.h, canvas.h/2 - sin(angle) * canvas.h, canvas.w/2 + cos(angle) * canvas.h, canvas.h/2 + sin(angle) * canvas.h, 5*em);
  //    float cloudSize = em*8;
  //    cloudCell(canvas.w/2 - cloudSize*5/6, canvas.h/2 - cloudSize*4/5, cloudSize, time.realFrameCount + 100, darkGrey);
  //    cloudCell(canvas.w/2 - cloudSize*1/6, canvas.h/2 - cloudSize*1/5, cloudSize, time.realFrameCount + 200, white);
  //  }
  //  canvas.end();
  //}

  Buttom startButtom = new Buttom(em, em, canvas.w - 2*em, canvas.h - 2*em);
  void home() {
    canvas.begin();
    {
      startButtom.displayRoundedRect();
      if (startButtom.confirmed) {
        currentScreen++;
        startButtom.confirmed = false;
      }

      bg();

      em = em*25/20;

      //float cloudSize = canvas.w*0.6;
      //cloudCell(canvas.w/2 - cloudSize/2, canvas.h/2 - cloudSize/2, cloudSize, 6, time.realFrameCount, lakeColor);
      //cloudSize = canvas.w*0.967*0.6;
      //cloudCell(canvas.w/2 - cloudSize/2, canvas.h/2 - cloudSize/2, cloudSize, 6, time.realFrameCount, blue);

      float cloudSize = canvas.w*0.75;
      cloudCell(0 - cloudSize/2, canvas.h - cloudSize/2, cloudSize, 6, time.realFrameCount, lakeColor);
      cloudSize = canvas.w*0.65;
      cloudCell(0 - cloudSize/2, canvas.h - cloudSize/2, cloudSize, 6, time.realFrameCount, blue);
      //cloudSize = canvas.w*0.967*0.6;
      //cloudCell(0 - cloudSize/2, 0 - cloudSize/2, cloudSize, 6, time.realFrameCount, blue);

      cloudSize = canvas.w*0.75;
      cloudCell(canvas.w - cloudSize/2, 0 - cloudSize/2, cloudSize, 6, 1000 + time.realFrameCount, lakeColor);
      cloudSize = canvas.w*0.65;
      cloudCell(canvas.w - cloudSize/2, 0 - cloudSize/2, cloudSize, 6, 1000 + time.realFrameCount, blue);


      //cloudSize = canvas.w*0.967*0.6;
      //cloudCell(canvas.w - cloudSize/2, canvas.h - cloudSize/2, cloudSize, 6, 1000 + time.realFrameCount, blue);


      //Texto detalhes
      textFont(fontSmaller);
      textLeading(1*(em/2));
      fill(lightBlue);
      textAlign(CENTER, BOTTOM);
      text(text.getString("homeScreenBottom"), canvas.w/2, canvas.h - em/2);

      textFont(font);
      fill(lightBlue);
      textAlign(RIGHT, BOTTOM);
      text(text.getString("versionName"), canvas.w - em, canvas.h - em/2);

      //Sombra BATALHA CHUVOSA
      textFont(boldBig);
      textAlign(CENTER, CENTER);
      fill(lakeColor);
      textLeading(3*em);
      text(text.getString("gameNameForLogo").toUpperCase(), canvas.w/2 + em*0.15, (canvas.h-3.5*em)/2 + em*0.2);

      //BATALHA CHUVOSA
      textFont(boldBig);
      textAlign(CENTER, CENTER);
      fill(white);
      textLeading(3*em);
      text(text.getString("gameNameForLogo").toUpperCase(), canvas.w/2, (canvas.h-3.5*em)/2);

      textFont(font);
      fill(white);
      textAlign(CENTER, CENTER);
      text(text.getString("play").toUpperCase(), canvas.w/2, canvas.h/2 + 3.5*em);
      
      em = em*20/25;
    }
    canvas.end();
  }

  //ButtomText singlePlayer = new ButtomText(width/2, height/2 - 1.5*em, "1 jogador");
  //ButtomText multiPlayer = new ButtomText(width/2, height/2 + 1.5*em, "2 jogadores");
  //void players() {
  //  bg();

  //  singlePlayer.display();
  //  multiPlayer.display();
  //}

  Buttom n1Players = new Buttom(canvas.w/2 - 12.5*em, canvas.h/2 - 6*em, 12*em, 12*em);
  Buttom n2Players = new Buttom(canvas.w/2 + 0.5*em, canvas.h/2 - 6*em, 12*em, 12*em);
  void selectNumberOfPlayers() {

    canvas.begin();
    {
      bg();

      //fill(blue);
      //noFill();
      //stroke(lakeColor);
      //strokeWeight(em/5);
      //rect(canvas.w/2 - 13.5*em, canvas.h/2 - 7*em, 27*em, 14*em, 0.5*em, 0.5*em, 0.5*em, 0.5*em);
      //rect(-em, canvas.h/2 - 7*em, canvas.w + em, 14*em);

      back.update();
      displayBack(1.5*em, 1.5*em);
      if (back.confirmed) {
        currentScreen--;
      }

      n1Players.displayRoundedRect();
      playerIcon(n1Players.x + n1Players.w/2, n1Players.y + n1Players.h/2);
      if (n1Players.confirmed) {
        numberOfPlayers = 1;
        //newGame();
        game.reset();
        currentScreen++;
      }

      n2Players.displayRoundedRect();
      playerIcon(n2Players.x + n2Players.w/2 - 1.1*em, n2Players.y + n2Players.h/2);
      playerIcon(n2Players.x + n2Players.w/2 + 1.1*em, n2Players.y + n2Players.h/2);
      if (n2Players.confirmed) {
        numberOfPlayers = 2;
        //newGame();
        game.reset();
        currentScreen++;
      }
      
      //Texto detalhes
      textFont(fontSmaller);
      textLeading(1.2*(em/2));
      fill(white);
      textAlign(CENTER, BOTTOM);
      text("CONTROLES\nNuvem clara: SETAS ou MOUSE | Nuvem escura: W A S D", canvas.w/2, canvas.h - em/2);
    }
    canvas.end();
  }

  Buttom nextMatchButtom = new Buttom(canvas.w/2 - 2.5*em, canvas.h/2 - 2.5*em, 5*em, 5*em);
  void matchEnded() {
    canvas.begin();
    {
      back.update();
      displayBack(1.5*em, 1.5*em);
      if (back.confirmed) {
        currentScreen--;
      }

      nextMatchButtom.displayTransparentEllipse();
      playIcon(canvas.w/2, canvas.h/2, 1.5*em);
      if (nextMatchButtom.confirmed) {
        game.nextMatch();
      }
    }
    canvas.end();
  }

  Buttom pauseButtom = new Buttom(canvas.w - 2.5*em, 0.5*em, 2*em, 2*em);
  void pauseCorner() {
    pushMatrix();
    translate(canvas.w - em*1.5, em*1.5);
    noStroke();
    fill(lightBlue);
    ellipse(0, 0, 1.75*em, 1.75*em);

    stroke(darkGrey);
    strokeWeight(em/10);
    noFill();
    ellipse(0, 0, 1.25*em, 1.25*em);
    line(-em/6, -em/5, -em/6, em/5);
    line(em/6, -em/5, em/6, em/5);  
    popMatrix();

    pauseButtom.update();
    if (pauseButtom.confirmed) {
      game.playing = !game.playing;
    }
  }
  
  Buttom bigPauseButtom = new Buttom(canvas.w/2 - 7*em, canvas.h/2 - 7*em, 14*em, 14*em);
  void pauseMenu() {
    noStroke();

    fill(0, 128);
    //noFill();
    stroke(lightGrey);
    strokeWeight(em/2);
    ellipse(canvas.w/2, canvas.h/2, 12*em, 12*em);

    strokeWeight(em*2/3);
    //fill(lightGrey);
    //rect(canvas.w/2 - 1.5*em - 0.5*em, canvas.h/2 - 2.5*em, em, 5*em);
    //rect(canvas.w/2 + 1.5*em - 0.5*em, canvas.h/2 - 2.5*em, em, 5*em);
    line(canvas.w/2 - 1.5*em, canvas.h/2 - 2.5*em, canvas.w/2 - 1.5*em, canvas.h/2 - 2.5*em + 5*em);
    line(canvas.w/2 + 1.5*em, canvas.h/2 - 2.5*em, canvas.w/2 + 1.5*em, canvas.h/2 - 2.5*em + 5*em);

    back.update();
    displayBack(1.5*em, 1.5*em);
    if (back.confirmed) {
      currentScreen--;
    }
    
    bigPauseButtom.update();
    if (bigPauseButtom.confirmed) {
      game.playing = !game.playing;
    }
  }
}

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
    if (selected() || pressed) {
      fill(aLittleLightBlue);
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
    if (selected() || pressed) {
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
    if (selected() || pressed) {
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
