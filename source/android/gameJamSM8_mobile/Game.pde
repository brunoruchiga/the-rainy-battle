class Game {
  float emScale;
  int totalNumberOfPlayers, numberOfControlablePlayers;
  float totalTime;
  float timer;
  int playingStage;
  boolean playing = true;
  
  Game() {
    emScale = canvas.h/20;

    totalNumberOfPlayers = 2;
    numberOfControlablePlayers = numberOfPlayers;

    totalTime = 87*60;

    timer = 0;
    playingStage = 0;
    playing = true;
  }

  void setupGame() {
    timer = 0;
    playingStage = 0;
    playing = true;

    playArea = new PlayArea(16/9.0, em/2);
    terrain = new Terrain();
    borders = new VisibleAreaWithBorders(playArea);
    foods = new Food[20]; //max number of foods at the same time
    
    multiTouchControls = new MultiTouchControls();    

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

  void run() {
    if(playing) {update();}
    display();
  }

  void update() {
    timer += time.delta;

    if (timer < 3*SEC) {
      playingStage = 0; //pré-jogo, contador regressivo de 3s
    } else if (timer < 3*SEC + totalTime) {
      playingStage = 1; //durante o jogo
    } else { 
      playingStage = 2; //final de jogo
    }
    
    if (numberOfPlayers > 1) {
      multiTouchControls.update2players();
    }

    terrain.update();
    
    foodGenerator.update();
    if (playingStage == 0 || playingStage == 1) {
      foodGenerator.createFood(0.25*SEC); //a cada 1/4 de segundo criar vaporzinho
    }
    
    for (int i = foods.length-1; i > 0; i--) {
        foods[i].update();
    }

    //Jogador capturar vaporzinhos
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
  
    //Update player
    for (int i = 0; i < p.length; i++) {
      p[i].update();
      if (playingStage == 1) {
        p[i].masterControl();
        p[i].move(); 
        p[i].wet(terrain);
        for (int j = i+1; j < p.length; j++) {
          p[i].colide(p[j]);
        }
      }
    }
    
    //Acabou a partida
    if(playingStage == 2) {
      //Voltar jogadores pro lugar de origem
      for (int i = 0; i < p.length; i++) {
        p[i].pos = p[i].pos.lerp(p[i].initialPos, 0.04);
      }
      checkVictory();
    }
  }
    
  void display() {
    canvas.begin(); 
    {
      playArea.begin();
      {
        //Desenhar terreno
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

        //Desenhar chuva dos jogadores
        for (int i = 0; i < p.length; i++) {
          p[i].displayRain();
        }

        //Desenhar vaporzinhos
        for (int i = foods.length-1; i > 0; i--) {
          foods[i].display();
          //foods[i].debug();
        }

        //Desenhar jogadores
        for (int i = 0; i < p.length; i++) {
          if (playingStage == 1) {
            //Desenhar Raios entre jogadores
            for (int j = i+1; j < p.length; j++) {
              if (p[i].rayTimer[j] > 0) {
                ray(p[i].pos.x + p[i].w/2, p[i].pos.y + p[i].h/2, p[j].pos.x + p[j].w/2, p[j].pos.y + p[j].h/2, game.emScale*2);
              }
            }
          }
          p[i].display();
          //p[i].debug();
        }        
        //terrain.debug();
        //terrain.debugWind();
      }
      playArea.end();

      //Relâmpagos
      if (playingStage == 1) { //apenas durante o jogo
        if (time.realFrameCount % (p.length*0.5*SEC) < 1*SEC) { //diminuir a frequência em que pode piscar a tela se houver mais jogadores
          for (int i = 0; i < p.length; i++) {
            for (int j = i+1; j < p.length; j++) {
              if (p[i].rayTimer[j] > 0.5*SEC) {
                rayFlickering();
              }
            }
          }
        }
      }

      //Relâmpago no início
      if (timer < 0.5*SEC) {
        rayFlickering();
      }

      //Relâmpago no "JÁ"
      if (timer > 3*SEC && timer < 3*SEC + 30) {
        rayFlickering();
      }

      //Relâmpago quando acaba o jogo
      if (timer > 3*SEC + totalTime && timer < 3*SEC + totalTime + 0.5*SEC) {
        rayFlickering();
      }
    }
    canvas.end();

    if(numberOfPlayers == 1) {
      p[0].displayTouchControl1Player();
    }

    borders.display();
    //borders.debug();

    displayCountdown321Go();

    if (numberOfPlayers == 2) {
      multiTouchControls.display2players();
    }

    //Acabou a partida
    if (playingStage == 2) {
      if(timer > 3*SEC + totalTime + 3*SEC) {
        screens.matchEnded();
      }
    }
    
    canvas.begin(); //again
    {
      displayGameTimer();
      //displayScores();      
      displayInfo2Players();
      if(playingStage > 0) {
        screens.pauseCorner();
      }
      if(!playing) {
        screens.pauseMenu();
      }
    }
    canvas.end(); //again
  }
  
  void checkVictory() {
    int mostFlowers = 0;
    for (int i = 0; i < p.length; i++) {
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
  }

  //INTERFACE ELEMENTS
  void displayCountdown321Go() {
    //Contador regressivo 3 segundos
    pushMatrix();
    translate(width/2, height/2);
    scale(2 - 1*(this.timer/(4*SEC)));
    fill(white);
    textFont(fontBig);
    textAlign(CENTER, CENTER);
    if (this.timer < 1*SEC) {
      text("3", 0, 0);
    } else if (this.timer < 2*SEC) {
      text("2", 0, 0);
    } else if (this.timer < 3*SEC) {
      text("1", 0, 0);
    } else if (this.timer < 4*SEC) {
      text(text.getString("start").toUpperCase(), 0, 0);
      //playing = true;
    }
    popMatrix();
  }
  
  void displayGameTimer() {
    fill(blueClouds);
    noStroke();
    ellipse(canvas.w/2, em*1.5, 2*em, 2*em);
  
    fill(blueLake);
    noStroke();
    ellipse(canvas.w/2, em*1.5, 1.5*em, 1.5*em);
  
    float porcentageOfTime = (game.timer - 3*SEC)/game.totalTime;
    if (porcentageOfTime > 1) {
      porcentageOfTime = 1;
    }
    fill(white);
    arc(canvas.w/2, em*1.5, 1.25*em, 1.25*em, -HALF_PI, -HALF_PI + porcentageOfTime*TWO_PI);
  }
  
  void displayInfo2Players() {
    float distanceFromCenter = 2.25*em;
    float ellipseSize = 1.25*em;
    float distanceFromTop = 1.5*em;
  
    //red
    fill(blueClouds);
    noStroke();
    ellipse(canvas.w/2 - distanceFromCenter, distanceFromTop, ellipseSize + 0.5*em, ellipseSize + 0.5*em);
  
    fill(p[1].flowersColor);
    noStroke();
    ellipse(canvas.w/2 - distanceFromCenter, distanceFromTop, ellipseSize, ellipseSize);
  
    fill(white);
    textAlign(CENTER, CENTER);
    textFont(fontSmaller);
    text(p[1].flowersScore, canvas.w/2 - distanceFromCenter, distanceFromTop);
  
    //Vitórias contador
    if(p[1].winningCount < 10 && p[0].winningCount < 10) {
      for(int i = 0; i < p[1].winningCount; i++) {
        fill(blueClouds);
        noStroke();
        ellipse(canvas.w/2 - distanceFromCenter*1.75 - i*em, distanceFromTop, ellipseSize, ellipseSize);
        crown(canvas.w/2 - distanceFromCenter*1.75 - i*em, distanceFromTop+em/5, em, p[1].flowersColor);
      }
    } else {
      for(int i = 0; i < 2; i++) {
        fill(blueClouds);
        noStroke();
        ellipse(canvas.w/2 - distanceFromCenter*1.75 - i*em, distanceFromTop, ellipseSize, ellipseSize);
      }
      crown(canvas.w/2 - distanceFromCenter*1.75 - 0*em, distanceFromTop+em/5, em, p[1].flowersColor);
      fill(p[1].flowersColor);
      text(p[1].winningCount, canvas.w/2 - distanceFromCenter*1.75 - 1*em, distanceFromTop);
    }
    
    //yellow
    fill(blueClouds);
    noStroke();
    ellipse(canvas.w/2 + distanceFromCenter, distanceFromTop, ellipseSize + 0.5*em, ellipseSize + 0.5*em);
  
    fill(p[0].flowersColor);
    noStroke();
    ellipse(canvas.w/2 + distanceFromCenter, distanceFromTop, ellipseSize, ellipseSize);
  
    fill(white);
    textAlign(CENTER, CENTER);
    textFont(fontSmaller);
    text(p[0].flowersScore, canvas.w/2 + distanceFromCenter, distanceFromTop);
  
    //Vitórias contador
    if(p[1].winningCount < 10 && p[0].winningCount < 10) {
      for(int i = 0; i < p[0].winningCount; i++) {
        fill(blueClouds);
        noStroke();
        ellipse(canvas.w/2 + distanceFromCenter*1.75 + i*em, distanceFromTop, ellipseSize, ellipseSize);
        crown(canvas.w/2 + distanceFromCenter*1.75 + i*em, distanceFromTop+em/5, em, p[0].flowersColor);
      }
    } else {
      for(int i = 0; i < 2; i++) {
        fill(blueClouds);
        noStroke();
        ellipse(canvas.w/2 + distanceFromCenter*1.75 + i*em, distanceFromTop, ellipseSize, ellipseSize);
      }
      crown(canvas.w/2 + distanceFromCenter*1.75 + 0*em, distanceFromTop+em/5, em, p[0].flowersColor);
      fill(p[0].flowersColor);
      text(p[0].winningCount, canvas.w/2 + distanceFromCenter*1.75 + 1*em, distanceFromTop);
    }
  }
}
