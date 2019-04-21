class MultiTouchControls {
  PVector totalTouchMovementP1;
  PVector totalTouchMovementP2;

  PVector tempTouchMovement;

  MultiTouchControls() {
    totalTouchMovementP1 = new PVector();
    totalTouchMovementP2 = new PVector();

    tempTouchMovement = new PVector();
  }

  void update2players() {
    // =========================================================================APENAS ANDROID (3) VVV

    totalTouchMovementP1.set(0, 0);
    totalTouchMovementP2.set(0, 0);
    int counterTouchesP1 = 0;
    int counterTouchesP2 = 0;

    for (int i = 0; i < touches.length && i < prevTouchesId.length; i++) {
      //println(touches[i].id, touches[i].x, prevTouchesX[i], touches[i].x-prevTouchesX[i]);
      if (prevTouchesX[i] > 0 && prevTouchesY[i] > 0) {
        if (touches[i].x > width/2) {
          counterTouchesP1++;
          //PVector touch = new PVector(touches[i].x, touches[i].y);
          //PVector prevTouch = new PVector(prevTouchesX[i], prevTouchesY[i]);
          //PVector touchMovement = touch.copy();
          //touchMovement.sub(prevTouch);
          tempTouchMovement.set(touches[i].x - prevTouchesX[i], touches[i].y - prevTouchesY[i]);
          tempTouchMovement.mult(1/(2*game.emScale));      
          totalTouchMovementP1.add(tempTouchMovement);
        }
        if (touches[i].x < width/2) {
          counterTouchesP2++;
          //PVector touch = new PVector(touches[i].x, touches[i].y);
          //PVector prevTouch = new PVector(prevTouchesX[i], prevTouchesY[i]);
          //PVector touchMovement = touch.copy();
          //touchMovement.sub(prevTouch);
          tempTouchMovement.set(touches[i].x - prevTouchesX[i], touches[i].y - prevTouchesY[i]);
          tempTouchMovement.mult(1/(2*game.emScale));
          totalTouchMovementP2.add(tempTouchMovement);
        }
      }
    }

    //Adicionar total a velocidade
    p[0].acc.add(totalTouchMovementP1);
    if (p[0].acc.mag() > p[0].acceleration) {
      p[0].acc.setMag(p[0].acceleration);
    }
    p[1].acc.add(totalTouchMovementP2);
    if (p[1].acc.mag() > p[1].acceleration) {
      p[1].acc.setMag(p[1].acceleration);
    }  

    //Se tirar o dedo, zerar acc 
    if (counterTouchesP1 == 0) {
      p[0].acc.set(0, 0);
    }
    if (counterTouchesP2 == 0) {
      p[1].acc.set(0, 0);
    }

    for (int i = 0; i < prevTouchesId.length; i++) {
      if (i < touches.length) {
        prevTouchesX[i] = touches[i].x;
        prevTouchesY[i] = touches[i].y;
        prevTouchesId[i] = touches[i].id;
      } else {
        prevTouchesX[i] = 0;
        prevTouchesY[i] = 0;
        prevTouchesId[i] = 0;
      }
    }
    // =========================================================================APENAS ANDROID ^^^
  }

  void display2players() {
    float controlersDistanceFromSides = 4*em;
    float controlersSize = 3.5*em;
    float controlersSizeSmallBall = controlersSize/3;
    float scaleBolinhaDoMeio = 150; //TODO renomear essa variável depois

    canvas.begin();
    {
      pushMatrix();
      {
        translate(canvas.x + controlersDistanceFromSides, canvas.h-3*em);

        noStroke();
        fill(blueClouds);
        ellipse(0, 0, controlersSize*1.4, controlersSize*1.4);
        ellipse(0 - controlersSize*1.4/2, controlersSize*1.4/2, controlersSize*1.4, controlersSize*1.4);

        strokeWeight(em/5);

        //red bolinha do meio
        fill(p[1].flowersColor);
        stroke(p[1].flowersColor);
        ellipse(cos(p[1].acc.heading()) * p[1].acc.mag()*scaleBolinhaDoMeio*(controlersSizeSmallBall/game.emScale), sin(p[1].acc.heading())*p[1].acc.mag()*scaleBolinhaDoMeio*(controlersSizeSmallBall/game.emScale), controlersSizeSmallBall, controlersSizeSmallBall);  

        //red circulo da volta
        noFill();
        ellipse(0, 0, controlersSize, controlersSize);
      }
      popMatrix();

      pushMatrix();
      {
        translate(canvas.x - controlersDistanceFromSides + canvas.w, canvas.h-3*em);

        noStroke();
        fill(blueClouds);
        ellipse(0, 0, controlersSize*1.4, controlersSize*1.4); 
        ellipse(controlersSize*1.4/2, controlersSize*1.4/2, controlersSize*1.4, controlersSize*1.4);

        strokeWeight(em/5);

        //yellow bolinha do meio
        fill(p[0].flowersColor);
        stroke(p[0].flowersColor);
        ellipse(cos(p[0].acc.heading()) * p[0].acc.mag()*scaleBolinhaDoMeio*(controlersSizeSmallBall/game.emScale), sin(p[0].acc.heading()) * p[0].acc.mag()*scaleBolinhaDoMeio*(controlersSizeSmallBall/game.emScale), controlersSizeSmallBall, controlersSizeSmallBall);

        //yellow circulo da volta
        noFill();
        ellipse(0, 0, controlersSize, controlersSize);
      }
      popMatrix();
    }
    canvas.end();
  }
}
