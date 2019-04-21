class Player {
  int id;

  float w, h;

  PVector initialPos;
  PVector pos;
  PVector vel;
  PVector acc;

  PVector velTouchControl;
  PVector accTouchControl;
  PVector mouseMovement;
  PVector autoAccelerate;

  PVector colideVectorAngle;

  PVector posCenter = new PVector();

  float acceleration = 0.004*game.emScale;

  //boolean alive = true;
  //boolean raining = true;

  float randomAnimation = random(1000);
  float timer = 0;
  color c;
  color flowersColor;

  boolean leftPressed, rightPressed, upPressed, downPressed; //controles

  float power = 0;
  float wetScore = 0;
  int flowersScore = 0;
  boolean wonLastGame = false;
  int winningCount = 0;

  float bounce = 0.1*game.emScale*time.delta;

  float[] rayTimer;

  boolean auto = true;

  Player(float x, float y, int id_) {
    id = id_;

    w = game.emScale;
    h = game.emScale;

    initialPos = new PVector(x, y);
    pos = new PVector(x, y);
    vel = new PVector(0, 0);
    acc = new PVector();

    velTouchControl = new PVector(0, 0);
    accTouchControl = new PVector(0, 0);
    mouseMovement = new PVector(0, 0);
    autoAccelerate = new PVector(0, 0);

    colideVectorAngle = new PVector();

    power = 0;
    wetScore = 0;   
    flowersScore = 0;
    wonLastGame = false;
    winningCount = 0;

    if (id == 0) {
      c = white;
      flowersColor = yellow;
    } else if (id == 1) {
      c = darkGrey;
      flowersColor = red;
    } else if (id == 2) {
      c = grey;
      flowersColor = c;
    } else {
      c = color(random(255));
      flowersColor = c;
    }

    rayTimer = new float[p.length];
    for (int i = 0; i < rayTimer.length; i++) {
      rayTimer[i] = 0;
    }
  }

  void update() {    
    bounce = 0.1 * game.emScale; //updateVariable

    edges();

    //Atrito
    float friction = (0.01 + (0.01 * power)) * time.delta;
    vel.mult(1 - (friction));
    velTouchControl.mult(1 - (friction));    

    //Update power
    power -= 0.0005 * time.delta;
    power = constrain(power, 0, 1);

    //Update size
    w = (1 + 0.75*power) * game.emScale;
    h = (1 + 0.75*power) * game.emScale;

    //Update rayTimer
    for (int i = 0; i < rayTimer.length; i++) {
      if (rayTimer[i] > 0) {
        rayTimer[i] -= time.delta;
      } else {
        rayTimer[i] = 0;
      }
    }

    //Update local timer
    timer += time.delta;

    //Update flowerScore
    //flowersScore = 0;
    //for (int i = 0; i < terrain.cols; i++) {
    //  for (int j = 0; j < terrain.rows; j++) {
    //    if (!terrain.active[i][j] && terrain.owner[i][j] == id) {
    //      flowersScore++;
    //    }
    //  }
    //}
  }

  void masterControl() {
    if (!auto) {
      //if (numberOfPlayers == 1) {
        acc.set(0, 0);
        if(id ==0) {
        touchControl();
        }
      //}
      keyControl();
    } else {
      autoMove();
    }
  }

  void keyControl() {
    if (!mousePressed) {
      acc.set(0, 0);

      if (rightPressed) {
        acc.x += acceleration;
      }
      if (leftPressed) {
        acc.x += -acceleration;
      }
      if (upPressed) {
        acc.y += -acceleration;
      }
      if (downPressed) {
        acc.y += acceleration;
      }
    }
  }

  void touchControl() {
    acc.set(0, 0);




    // ================================================ APENAS ANDROID VVV

    //if (touches.length > 0) {
    // float averageX = 0;
    // float averageY = 0;
    // for (int i = 0; i < touches.length; i++) {
    // averageX += touches[i].x;
    // averageY += touches[i].y;
    // }
    // averageX = averageX/touches.length;
    // averageY = averageY/touches.length;

    float averageX = mouseX;
    float averageY = mouseY;


    //PVector a = new PVector(mouseX-canvas.x, mouseY-canvas.y-em*4);
    //PVector b = posCenter.copy(); // new PVector(this.pos.x + this.w/2, this.pos.y + this.h/2);
    //a.sub(b);
    accTouchControl.set(averageX-canvas.x-playArea.x - posCenter.x, averageY-canvas.y-playArea.y - posCenter.y);
    if (accTouchControl.mag() > 2*game.emScale) {
      //a.setMag(0.15*em);
      //velTouchControl.set(a);
      accTouchControl.setMag(0.004*game.emScale);        
      acc.set(accTouchControl);
    } else {
      accTouchControl.set(0, 0);
    }

    //if (touches.length == 1) {
    //displayTouch(averageX-canvas.x-playArea.x, averageY-canvas.y-playArea.y);
    //}
    //} else {
    ////velTouchControl.set(0, 0);
    //}

    //================================================ APENAS ANDROID ^^^
  }


  void move() {
    vel.add(acc.x * time.delta, acc.y * time.delta);
    pos.add((vel.x + velTouchControl.x) * time.delta, (vel.y + velTouchControl.y) * time.delta);

    posCenter.set(pos.x + w/2, pos.y + h/2);
  }

  void edges() {
    //Impedir que saia da tela
    if (pos.y < 0 - h/2) {
      pos.y = 0 - h/2;
      vel.y = bounce*1.5;
      //acc.y = 0;
    }
    if (pos.y > playArea.h - h/2) {
      pos.y = playArea.h - h/2;
      vel.y = -bounce*1.5;
      //acc.y = 0;
    }
    if (pos.x < 0 - w/2) {
      pos.x = 0 - w/2;
      vel.x = bounce*1.5;
      //acc.x = 0;
    }
    if (pos.x > playArea.w - w/2) {
      pos.x = playArea.w - w/2;
      vel.x = -bounce*1.5;
      //acc.x = 0;
    }
  }

  void autoMove() {
    //pos.x = map(noise((10*randomAnimation+timer)*0.005), 0, 1, 0, canvas.w);
    //pos.y = map(noise((randomAnimation+timer)*0.005), 0, 1, 0, canvas.h);

    //Find nearest food
    float minDistance = width + height;
    int indexOfFood = 0;
    for (int i = foods.length - 1; i > 0; i--) {
      if (foods[i].active) {
        float margin = 2.5*game.emScale;
        if (foods[i].pos.x > 0 + margin && foods[i].pos.x < playArea.w - margin && foods[i].pos.y > 0 + margin && foods[i].pos.y < playArea.h - margin) {
          //float distance = abs(foods[i].pos.x - this.pos.x) + abs(foods[i].pos.y - this.pos.y);
          //if (distance < minDistance) {
          if ((abs(foods[i].pos.x - this.pos.x) + abs(foods[i].pos.y - this.pos.y)) < minDistance) {
            minDistance = (abs(foods[i].pos.x - this.pos.x) + abs(foods[i].pos.y - this.pos.y));
            indexOfFood = i;
          }
        }
      }
      //PVector a = foods[indexOfFood].pos.copy();
      //PVector b = this.pos.copy();
      //PVector autoAccelerate = a.sub(b);
      autoAccelerate.set(foods[indexOfFood].pos.x - this.pos.x, foods[indexOfFood].pos.y - this.pos.y);
      autoAccelerate.setMag(acceleration * 0.5);
      acc.setMag(acceleration * 0.5);
      acc.lerp(autoAccelerate, 0.2);
    }
    vel.mult(0.98);

    //power -= 0.00025 * time.delta;
  }

  void wet(Terrain t) {
    int cellX = floor(map(pos.x+w/2, 0, playArea.w, 0, t.cols));
    int cellY = floor(map(pos.y+h*2, 0, playArea.h, 0, t.rows));
    cellX = constrain(cellX, 0, terrain.cols-1);
    cellY = constrain(cellY, 0, terrain.rows-1);

    t.wetness[cellX][cellY] += 0.04*power*time.delta;
    if (t.active[cellX][cellY]) {
      t.owner[cellX][cellY] = id;
      wetScore += 0.04*power*time.delta;
      //if (t.wetness[cellX][cellY] > 1) {
      //  score -= t.wetness[cellX][cellY] % 1;
      //}
    }
  }

  void displayShadow() {
    //Sombra
    fill(shadow);
    noStroke();
    ellipse(pos.x+w/2, pos.y + 2*h, 1.2*w, 1.2*h/2);
  }

  void display() {
    //Chuva
    rectRain(pos.x, pos.y + h/2, w, h*1.5, rainColor, power);    

    //Nuvens
    cloudCell(pos.x, pos.y, w, 6, timer + randomAnimation, c);

    //Coroa
    if (wonLastGame) {
      crown(pos.x + w/2, pos.y, w, flowersColor);
    }
  }

  void reset() {
    pos.set(initialPos);
    vel.set(0, 0);
    acc.set(0, 0);
    wetScore = 0;
    flowersScore = 0;
    power = 0;
    timer = 0;

    if (wonLastGame) {
      winningCount++;
    }
  }

  void debug() {
    noFill();
    stroke(255, 0, 0);
    strokeWeight(1);

    rect(pos.x, pos.y, w, h);
    point(pos.x + w/2, pos.y + h/2);
  }

  void colide(Player other) { 
    if (other.pos.x < this.pos.x + this.w &&
      other.pos.x + other.w > this.pos.x &&
      other.pos.y < this.pos.y + this.h &&
      other.pos.y + other.h > this.pos.y) {
      //acc.set(0, 0);

      colideVectorAngle.set(this.pos.x - other.pos.x, this.pos.y - other.pos.y);
      //PVector a = this.pos.copy();
      //PVector b = other.pos.copy();
      //vectorAngle = a.sub(b);
      //this.acc.set(0, 0);
      this.vel.set(bounce, 0);
      this.vel.rotate(colideVectorAngle.heading());
      //other.acc.set(0, 0);
      other.vel.set(-bounce, 0);
      other.vel.rotate(colideVectorAngle.heading());

      this.power = this.power/2;
      other.power = other.power/2;

      this.rayTimer[other.id] = 60;
      other.rayTimer[this.id] = 60;
    }
  }
}

//Controles Teclado
void keyPressed() {
  setMove(keyCode, true);

  if (key == 'r') {
    game.reset();
  }
}
void keyReleased() {
  setMove(keyCode, false);
}
boolean setMove(int k, boolean b) {
  if (currentScreen == 2) {
    switch (k) {
    case LEFT:
      return p[0].leftPressed = b;
    case RIGHT:
      return p[0].rightPressed = b;
    case UP:
      return p[0].upPressed = b;
    case DOWN:
      return p[0].downPressed = b;

    case 65: //a
      return p[1].leftPressed = b;
    case 68: //d
      return p[1].rightPressed = b;
    case 87: //w
      return p[1].upPressed = b;
    case 83: //s
      return p[1].downPressed = b;

    default:
      return b;
    }
  } else {
    return false;
  }
}
