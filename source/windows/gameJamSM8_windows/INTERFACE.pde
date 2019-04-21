//class Interface {
//  float em;

//  Interface() {
//    em = canvas.h/20;
//  }
//}

void oldDisplayScores() {
  //Calcular placar
  int player1flowers = 0;
  int player2flowers = 0;
  for (int i = 0; i < terrain.cols; i++) {
    for (int j = 0; j < terrain.rows; j++) {
      if (!terrain.active[i][j] && terrain.owner[i][j] == 0) {
        player1flowers++;
      }
      if (!terrain.active[i][j] && terrain.owner[i][j] == 1) {
        player2flowers++;
      }
    }
  }

  textFont(font);

  float distanceFromTop = 3.5*em;
  float ellipseR = em;

  //Placar Player 2
  noStroke();
  //fill(shadow);
  //rect(0, 3.25*em, (canvas.x+4*em) * p2.power, 0.5*em);
  fill(red);
  rect(0, distanceFromTop, canvas.x+2*em, 2*ellipseR);
  ellipse(canvas.x+2*em, distanceFromTop + ellipseR, 2*ellipseR, 2*ellipseR);
  fill(white);
  textAlign(RIGHT, CENTER);
  text(player2flowers, canvas.x+2*em, 3.5*em + em);

  //Placar Player 1
  noStroke();
  //fill(shadow);
  //rect(0, 3.25*em, canvas.x+4*em, 0.5*em);
  fill(yellow);
  rect(canvas.x + canvas.w - 2*em, distanceFromTop, canvas.x+2*em, 2*ellipseR);
  ellipse(canvas.x + canvas.w - 2*em, distanceFromTop + ellipseR, 2*ellipseR, 2*ellipseR);
  fill(white);
  textAlign(LEFT, CENTER);
  text(player1flowers, canvas.x + canvas.w - 2*em, 3.5*em + em);
}

void displayGameTimer() {
  fill(lightBlue);
  noStroke();
  ellipse(canvas.w/2, em*1.5, 2*em, 2*em);

  fill(lakeColor);
  noStroke();
  ellipse(canvas.w/2, em*1.5, 1.5*em, 1.5*em);

  float porcentageOfTime = (game.timer - 3*60)/game.totalTime;
  if (porcentageOfTime > 1) {
    porcentageOfTime = 1;
  }
  fill(white);
  arc(canvas.w/2, em*1.5, 1.25*em, 1.25*em, -HALF_PI, -HALF_PI + porcentageOfTime*TWO_PI);
}

void displayInfoPlayers() {
  float distanceFromCenter = 2.25*em;
  float ellipseSize = 1.25*em;
  float distanceFromTop = 1.5*em;

  //red
  fill(lightBlue);
  noStroke();
  ellipse(canvas.w/2 - distanceFromCenter, distanceFromTop, ellipseSize + 0.5*em, ellipseSize + 0.5*em);

  fill(p[1].flowersColor);
  noStroke();
  ellipse(canvas.w/2 - distanceFromCenter, distanceFromTop, ellipseSize, ellipseSize);

  fill(white);
  textAlign(CENTER, CENTER);
  textFont(fontSmaller);
  text(p[1].flowersScore, canvas.w/2 - distanceFromCenter, distanceFromTop - em/12);

  //Vitórias contador
  for(int i = 0; i < p[1].winningCount; i++) {
    fill(lightBlue);
    noStroke();
    ellipse(canvas.w/2 - distanceFromCenter*1.75 - i*em, distanceFromTop, ellipseSize, ellipseSize);
    crown(canvas.w/2 - distanceFromCenter*1.75 - i*em, distanceFromTop+em/5, em, p[1].flowersColor);
  }
  
  //yellow
  fill(lightBlue);
  noStroke();
  ellipse(canvas.w/2 + distanceFromCenter, distanceFromTop, ellipseSize + 0.5*em, ellipseSize + 0.5*em);

  fill(p[0].flowersColor);
  noStroke();
  ellipse(canvas.w/2 + distanceFromCenter, distanceFromTop, ellipseSize, ellipseSize);

  fill(white);
  textAlign(CENTER, CENTER);
  textFont(fontSmaller);
  text(p[0].flowersScore, canvas.w/2 + distanceFromCenter, distanceFromTop - em/12);

  //Vitórias contador
  for(int i = 0; i < p[0].winningCount; i++) {
    fill(lightBlue);
    noStroke();
    ellipse(canvas.w/2 + distanceFromCenter*1.75 + i*em, distanceFromTop, ellipseSize, ellipseSize);
    crown(canvas.w/2 + distanceFromCenter*1.75 + i*em, distanceFromTop+em/5, em, p[0].flowersColor);
  }
}

void displayResults() {
  //Calcular placar (de novo)
  int player1flowers = 0;
  int player2flowers = 0;
  for (int i = 0; i < terrain.cols; i++) {
    for (int j = 0; j < terrain.rows; j++) {
      if (!terrain.active[i][j] && terrain.owner[i][j] == 0) {
        player1flowers++;
      }
      if (!terrain.active[i][j] && terrain.owner[i][j] == 1) {
        player2flowers++;
      }
    }
  }

  if (game.timer > 180 + game.totalTime) {
    //playing = false;
    //fill(transparentlakeColor);
    //rect(0, 0, canvas.w, canvas.h);
    String finalMessage = text.getString("end").toUpperCase();
    if (player1flowers == player2flowers) {
      finalMessage = finalMessage + "\n" + text.getString("draw").toUpperCase();
    } else if (numberOfPlayers == 1) {
      if (player1flowers > player2flowers) {
        finalMessage = finalMessage + "\n" + text.getString("youWin").toUpperCase();
      } else {
        finalMessage = finalMessage + "\n" + text.getString("youLost").toUpperCase();
      }
    } else if (numberOfPlayers == 2) {
      if (player1flowers > player2flowers) {
        finalMessage = finalMessage + "\n" + text.getString("yellowWins").toUpperCase();
      } else {
        finalMessage = finalMessage + "\n" + text.getString("redWins").toUpperCase();
      }
    }
    textFont(font);
    textAlign(CENTER, CENTER);

    fill(lakeColor);
    text(finalMessage, canvas.w/2 + 2, canvas.h/2 + 3);    
    fill(white);
    text(finalMessage, canvas.w/2, canvas.h/2);
  }
}

class FlowersCounter {
  int index;
  float timer;
  
  FlowersCounter() {
    index = 0;
    timer = 0;
  }
  
  void count() {
    terrain.flowers[index].maxSize = game.emScale * 1.5;
    
    timer += time.delta;
    
    if(timer > 2 && index < terrain.flowers.length - 1) {
      timer = 0;
      index++;
    }
  }
}

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
    fill(lakeColor);
    float y = map(timer, 60, 0, height, -height);
    rect(0, y, width, height);
  }
}
