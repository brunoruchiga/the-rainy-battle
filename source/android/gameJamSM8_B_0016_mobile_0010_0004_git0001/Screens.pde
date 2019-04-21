class Screens {
  Buttom back = new Buttom(em, em, 2*em, 2*em);

  void bg() {
    background(blueRain);
  }

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

      {
        float cloudSize = canvas.w*0.75;
        cloudCell(0 - cloudSize/2, canvas.h - cloudSize/2, cloudSize, 6, time.realFrameCount, blueLake);
        cloudSize = canvas.w*0.65;
        cloudCell(0 - cloudSize/2, canvas.h - cloudSize/2, cloudSize, 6, time.realFrameCount, blueRain);

        cloudSize = canvas.w*0.75;
        cloudCell(canvas.w - cloudSize/2, 0 - cloudSize/2, cloudSize, 6, 1000 + time.realFrameCount, blueLake);
        cloudSize = canvas.w*0.65;
        cloudCell(canvas.w - cloudSize/2, 0 - cloudSize/2, cloudSize, 6, 1000 + time.realFrameCount, blueRain);
      }

      //Texto detalhes
      textFont(fontSmaller);
      textLeading(1.2*(em/2));
      fill(blueClouds);
      textAlign(CENTER, BOTTOM);
      text(text.getString("homeScreenBottom"), canvas.w/2, canvas.h - em/2);

      //Versão canto direito
      textFont(font);
      fill(blueClouds);
      textAlign(RIGHT, BOTTOM);
      text(gameVersion, canvas.w - em, canvas.h - em/2);

      //Sombra BATALHA CHUVOSA
      textFont(boldBig);
      textAlign(CENTER, CENTER);
      fill(blueLake);
      textLeading(3*em);
      text(text.getString("gameNameForLogo").toUpperCase(), canvas.w/2 + em*0.15, (canvas.h-3.5*em)/2 + em*0.2);

      //BATALHA CHUVOSA
      textFont(boldBig);
      textAlign(CENTER, CENTER);
      fill(white);
      textLeading(3*em);
      text(text.getString("gameNameForLogo").toUpperCase(), canvas.w/2, (canvas.h-3.5*em)/2);

      //PLAY
      textFont(font);
      fill(white);
      textAlign(CENTER, CENTER);
      text(text.getString("play").toUpperCase(), canvas.w/2, canvas.h/2 + 3.5*em);
    }
    canvas.end();
  }

  Buttom n1Players = new Buttom(canvas.w/2 - 12.5*em, canvas.h/2 - 6*em, 12*em, 12*em);
  Buttom n2Players = new Buttom(canvas.w/2 + 0.5*em, canvas.h/2 - 6*em, 12*em, 12*em);
  void selectNumberOfPlayers() {
    canvas.begin();
    {
      bg();

      back.update();
      backIcon(1.5*em, 1.5*em);
      if (back.confirmed) {
        currentScreen--;
      }

      n1Players.displayRoundedRect();
      playerIcon(n1Players.x + n1Players.w/2, n1Players.y + n1Players.h/2);
      if (n1Players.confirmed) {
        numberOfPlayers = 1;
        //newGame();
        game.setupGame();
        currentScreen++;
      }

      n2Players.displayRoundedRect();
      playerIcon(n2Players.x + n2Players.w/2 - 1.1*em, n2Players.y + n2Players.h/2);
      playerIcon(n2Players.x + n2Players.w/2 + 1.1*em, n2Players.y + n2Players.h/2);
      if (n2Players.confirmed) {
        numberOfPlayers = 2;
        //newGame();
        game.setupGame();
        currentScreen++;
      }
    }
    canvas.end();
  }

  Buttom nextMatchButtom = new Buttom(canvas.w/2 - 2.5*em, canvas.h/2 - 2.5*em, 5*em, 5*em);
  void matchEnded() {
    canvas.begin();
    {
      back.update();
      backIcon(1.5*em, 1.5*em);
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
    fill(blueClouds);
    ellipse(0, 0, 1.75*em, 1.75*em);

    stroke(blackGrey);
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
    backIcon(1.5*em, 1.5*em);
    if (back.confirmed) {
      currentScreen--;
    }

    bigPauseButtom.update();
    if (bigPauseButtom.confirmed) {
      game.playing = !game.playing;
    }
  }
}
