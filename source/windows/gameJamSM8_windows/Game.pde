class Game {
  float emScale;
  int totalNumberOfPlayers, numberOfControlablePlayers;
  float totalTime;
  float timer;
  int playingStage;
  boolean playing = true;

  //FlowersCounter flowersCounter;

  Game() {
    emScale = canvas.h/25;

    totalNumberOfPlayers = 2;
    numberOfControlablePlayers = numberOfPlayers;

    totalTime = 87*60;

    timer = 0;
    playingStage = 0;
    playing = true;

    //flowersCounter = new FlowersCounter();
  }

  void update() {
    if (playing) {
      timer += time.delta;
    }

    if (timer < 3*60) {
      playingStage = 0; //pré-jogo, contador regressivo de 3s
    } else if (timer < 3*60 + totalTime) {
      playingStage = 1; //durante o jogo
    } else { 
      playingStage = 2; //final de jogo
    }

    canvas.begin(); 
    {
      //Gerador de vaporzinhos
      if (playing) {
        foodGenerator.update();
        if (playingStage < 2) {
          foodGenerator.createFood(15); //a cada 15 frames criar vaporzinho
        }
      }

      //Gerador de inimigos
      //if (random(1) < 0.01) {
      //  Enemy e = new Enemy(globalX + canvas.w + 4*em, random(canvas.h/2, canvas.h), random(em, 4*em));
      //  enemies.add(e);
      //}

      playArea.begin();
      {
        if (playing) {
          terrain.update();
        }
        if (playingStage == 1) {
          terrain.displayLow();
        } else {
          terrain.displayHigh();
        }

        //Desenhar sombras
        for (int i = 0; i < foods.length; i++) {
          foods[i].displayShadow();
        }
        for (int i = 0; i < p.length; i++) {
          p[i].displayShadow();
        }

        //Desenhar flores
        terrain.displayFlowers();

        if (numberOfPlayers > 1) {
          multiTouchControls.update();
        }

        for (int i = foods.length-1; i > 0; i--) {
          if (playing) {
            foods[i].update();
          }
          foods[i].display();
          //foods[i].debug();
        }

        if (playing) {
          if (playingStage == 1) {
            for (int i = foods.length-1; i > 0; i--) {
              for (int j = 0; j < p.length; j++) {
                if (foods[i].active && foods[i].intersects(p[j])) {
                  p[j].power += 0.05;
                  foods[i].active = false;
                }
              }
            }
          }
        }

        for (int i = 0; i < p.length; i++) {
          if (playing) {
            p[i].update();
          }
          if (playingStage == 1) {
            //Desenhar Raios
            for (int j = i+1; j < p.length; j++) {
              if (p[i].rayTimer[j] > 0) {
                ray(p[i].pos.x + p[i].w/2, p[i].pos.y + p[i].h/2, p[j].pos.x + p[j].w/2, p[j].pos.y + p[j].h/2, game.emScale*2);
              }
            }
            if (playing) {
              p[i].masterControl();
              p[i].move(); 
              p[i].wet(terrain);

              //p[i].debug();
              for (int j = i+1; j < p.length; j++) {
                p[i].colide(p[j]);
              }
            }
          }
          p[i].display();
        }        

        //terrain.debug();
        //terrain.debugWind();
      }
      playArea.end();
      //if(playing) {playArea.debug();};

      if (playing) {
        for (int i = 0; i < p.length; i++) {
          for (int j = i+1; j < p.length; j++) {
            if (time.realFrameCount % (p.length*0.5*60) < 60) {
              if (p[i].rayTimer[j] > 30) {
                rayFlickering();
              }
            }
          }
        }

        //Relâmpago no início
        if (timer < 30) {
          rayFlickering();
        }

        //Relâmpago no "JÁ"
        if (timer > 3*60 && timer < 3*60 + 30) {
          rayFlickering();
        }

        //Relâmpago quando acaba o jogo
        if (timer > 3*60 + totalTime && timer < 3*60 + totalTime + 30) {
          rayFlickering();
        }
      }

      //displayResults();
    }
    canvas.end();

    borders.display();
    //borders.debug();

    countdown();

    canvas.begin(); //again
    {
      displayGameTimer();
      displayInfoPlayers();
      if(playingStage > 0) {
        menu.pauseCorner();
      }
      if(!playing) {
        menu.pauseMenu();
      }
    }
    canvas.end(); //again

    if (numberOfPlayers == 2) {
      //multiTouchControls.display();
    }

    //displayScores();

    //Acabou a partida
    if (playingStage == 2) {
      int mostFlowers = 0;
      for (int i = 0; i < p.length; i++) {
        p[i].pos = p[i].pos.lerp(p[i].initialPos, 0.04);
        //p[i].power = lerp(p[i].power, 0, 0.02);
        if (p[i].flowersScore > mostFlowers) {
          mostFlowers = p[i].flowersScore;
        }
      }
      for (int i = 0; i < p.length; i++) {
        if (p[i].flowersScore == mostFlowers) {
          p[i].wonLastGame = true;
        } else {
          p[i].wonLastGame = false;
        }
      }

      if(timer > 3*60 + totalTime + 3*60) {
      menu.matchEnded();
      }

      //flowersCounter.count();

      //  fill(lakeColor);
      //  noStroke();
      //  float percentageToReset = (this.timer-(3*60 + this.totalTime))/(10*60);
      //  rect(0, height-em/2, width*percentageToReset, em);
    }

    //Resetar jogo automaticamente
    //if (this.timer > 3*60 + this.totalTime + 10*60) {
    //  game.reset();
    //}
  }

  void reset() {
    timer = 0;
    playingStage = 0;
    playing = true;

    playArea = new PlayArea(16/9.0, em/2);
    terrain = new Terrain();
    borders = new Borders(playArea);

    p = new Player[totalNumberOfPlayers];
    for (int i = 0; i < p.length; i++) {
      //p[i] = new Player((i+1)*(playArea.w/(p.length+1)), playArea.h/2, i+1); 
      float angle = i*(-TWO_PI/p.length) + ((HALF_PI*(p.length-2))/p.length);
      //p[i] = new Player(playArea.w/2 + cos(angle)*(playArea.w/3)/(1+(1/(p.length-1))), playArea.h/2 + sin(angle)*(playArea.h/3)/(1+(1/(p.length-1))), i+1); 
      p[i] = new Player(playArea.w/2 + cos(angle)*(playArea.w/5), playArea.h/2 + sin(angle)*(playArea.h/5), i);

      if (i < numberOfPlayers) {
        p[i].auto = false;
      }
    }

    for (int i = 0; i < foods.length; i++) {
      foods[i] = new Food(-width, -height);
      foods[i].active = false;
    }
  }

  void nextMatch() {
    timer = 0;

    terrain = new Terrain();

    for (int i = 0; i < p.length; i++) {
      p[i].reset();
    }
  }

  void countdown() {
    //Contador regressivo 3 segundos
    pushMatrix();
    translate(width/2, height/2);
    scale(2 - 1*(this.timer/240));
    fill(white);
    textFont(fontBig);
    textAlign(CENTER, CENTER);
    if (this.timer < 1*60) {
      text("3", 0, 0);
    } else if (this.timer < 2*60) {
      text("2", 0, 0);
    } else if (this.timer < 3*60) {
      text("1", 0, 0);
    } else if (this.timer < 4*60) {
      text(text.getString("start").toUpperCase(), 0, 0);
      //playing = true;
    }
    popMatrix();
  }
}
