class Terrain {
  int cols = 22; //20
  int rows = 15; //15

  float cellW, cellH;

  float[][] wetness = new float[cols][rows];
  float[][] windAngle = new float[cols][rows];
  boolean[][] active = new boolean[cols][rows];
  int[][] owner = new int[cols][rows];
  float windAngleOffsetTime = 0;
  float windInitialRandomAngle = random(TWO_PI);

  //ArrayList<Flower> flowers = new ArrayList<Flower>();
  Flower[] flowers = new Flower[cols*rows];

  //PGraphics img;

  Terrain() {
    cellW = playArea.w / cols;
    cellH = playArea.h / rows;

    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        wetness[i][j] = noise(i*0.1, j*0.1);
        windAngle[i][j] = noise(windAngleOffsetTime+i*0.1, windAngleOffsetTime+j*0.1) * TWO_PI;
        active[i][j] = true;
        owner[i][j] = -1;
      }
    }

    for (int i = 0; i < flowers.length; i++) {
      flowers[i] = new Flower(-width, -height, 0);
    }

    //img = createGraphics(floor(canvas.w), floor(canvas.h));
    //img.beginDraw();
    //img.background(bg);
    //for (int x = 0; x < floor(canvas.w); x++) {
    //  for (int y = 0; y < floor(canvas.h); y++) {
    //    int i = floor(map(x, 0, floor(canvas.w), 0, cols));
    //    int j = floor(map(y, 0, floor(canvas.h), 0, rows));

    //    if(wetness[i][j] > random(1)) {
    //      img.stroke(red(lakeColor), green(lakeColor), blue(lakeColor));
    //      img.point(x, y);
    //    }
    //  }
    //}
    //img.endDraw();
  }

  void update() {
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        if (active[i][j]) {
          //secar
          //if(playing) {
          //  wetness[i][j] -= (noise(time.realFrameCount*i*0.1, time.realFrameCount*j*0.1)*0.00004) * time.delta;
          //}

          if (wetness[i][j] > 0.9) {
            boolean flowerCreated = false;
            for (int k = 0; k < flowers.length; k++) {
              if (!flowers[k].active && !flowerCreated && owner[i][j] >= 0) {
                flowers[k].create(i*cellW + cellW/2 + random(-cellW/3, cellW/3), j*cellH + cellH/2 + random(cellH*2/3), owner[i][j]);
                p[owner[i][j]].flowersScore++;
                flowerCreated = true;
              }
            }

            active[i][j] = false;
          }
        }

        wetness[i][j] = constrain(wetness[i][j], 0, 1);

        windAngle[i][j] = windInitialRandomAngle + (noise(windAngleOffsetTime+i*0.1, windAngleOffsetTime+j*0.1) * TWO_PI);
      }
    }
    windAngleOffsetTime += 0.002 * time.delta;
    windInitialRandomAngle += (TWO_PI / (60*60)) * time.delta;
  }

  void displayLow() {
    //background(green);

    //float r1 = red(green);
    //float g1 = green(green);
    //float b1 = blue(green);
    //float r2 = red(lakeColor);
    //float g2 = green(lakeColor);
    //float b2 = blue(lakeColor);

    //int i = floor(random(wetness.length));
    //int j = floor(random(wetness[0].length));
    //fill(lerp(r1, r2, wetness[i][j]), lerp(g1, g2, wetness[i][j]), lerp(b1, b2, wetness[i][j]));
    //rect(i*cellW, j*cellH, cellW+1, cellH+1);

    for (int i = 0; i < wetness.length; i++) {
      for (int j = 0; j < wetness[0].length; j++) {
        noStroke();

        float visibleWetness = wetness[i][j];
        if (i > 0 && i < wetness.length-1 && j > 0 && j < wetness[0].length - 1) {
          //float neighborAverageWetness = (wetness[i-1][j-1] + wetness[i][j-1] + wetness[i+1][j-1] + wetness[i-1][j] + wetness[i][j] + wetness[i+1][j] + wetness[i-1][j+1] + wetness[i][j+1] + wetness[i+1][j+1]) / 9;
          float neighborAverageWetness = (wetness[i][j] + wetness[i][j-1] + wetness[i-1][j] + wetness[i+1][j] + wetness[i][j+1]) / 5;
          visibleWetness = (wetness[i][j]*0.5 + neighborAverageWetness*0.5);
        }

        //fill(red(lakeColor), green(lakeColor), blue(lakeColor), 255*wetness[i][j]); // com alpha
        //fill(lerp(r1, r2, visibleWetness), lerp(g1, g2, visibleWetness), lerp(b1, b2, visibleWetness)); //sem alpha, com lerp
        fill(lerpColor(ground, blueLake, visibleWetness)); //sem alpha, com lerp
        //rect(i*cellW, j*cellH + ((i % 2)-0.5)*(cellH/10), cellW+1, cellH+1); //ziguezaguear
        rect(i*cellW, j*cellH, cellW+1, cellH+1);

        //color c = color(lerp(r1, r2, wetness[i][j]), lerp(g1, g2, wetness[i][j]), lerp(b1, b2, wetness[i][j]));
        //terrainCellRect(i*cellW + (cellW/4), j*cellH + (cellH/4), cellW+1, cellH+1, c);
      }
    }

    //loadPixels();
    //for(int index = 0; index < pixels.length; index++) {
    //  pixels[index] = color(red);
    //}
    //updatePixels();
  }
  
  void displayHigh() {
    for (int i = 0; i < wetness.length; i++) {
      for (int j = 0; j < wetness[0].length; j++) {
        noStroke();

        float visibleWetness = wetness[i][j];
        if (i > 0 && i < wetness.length-1 && j > 0 && j < wetness[0].length - 1) {
          float neighborAverageWetness = (wetness[i-1][j-1] + wetness[i][j-1] + wetness[i+1][j-1] + wetness[i-1][j] + wetness[i][j] + wetness[i+1][j] + wetness[i-1][j+1] + wetness[i][j+1] + wetness[i+1][j+1]) / 9;
          //float neighborAverageWetness = (wetness[i][j] + wetness[i][j-1] + wetness[i-1][j] + wetness[i+1][j] + wetness[i][j+1]) / 5;
          visibleWetness = neighborAverageWetness; // (wetness[i][j]*0.5 + neighborAverageWetness*0.5);
        }

        color c = lerpColor(ground, blueLake, visibleWetness);
        terrainCellRect(i*cellW + (cellW/4), j*cellH + (cellH/4), cellW+1, cellH+1, c);
      }
    }

    //loadPixels();
    //for(int index = 0; index < pixels.length; index++) {
    //  pixels[index] = color(red);
    //}
    //updatePixels();
  }

  void displayFlowers() {
    for (int i = 0; i < flowers.length; i++) {
      flowers[i].update();
      flowers[i].display();
    }
  }

  void terrainCellRect(float x, float y, float w, float h, color c_) {
    noStroke();
    fill(c_);
    beginShape();
    //vertex(x, y);
    //vertex(x+w, y);

    for (float d = 0; d <= w; d += w/3) {
      vertex(x+d, y - noise(10*y+x+d)*(cellH));
    }

    vertex(x+w, y+h);
    //vertex(x, y+h);

    for (float d = h; d >= 0; d -= h/4) {
      vertex(x - noise(10*x+y+d)*(cellW), y+d);
    }

    endShape(CLOSE);
  }

  void debug() {
    for (int i = 0; i < wetness.length; i++) {
      for (int j = 0; j < wetness[0].length; j++) {
        noFill();
        stroke(0, 255, 0);
        strokeWeight(1);
        rect(i*cellW, j*cellH, cellW, cellH);

        stroke(0, 0, 255);
        strokeWeight(1);
        line(i*cellW, j*cellH, i*cellW+cellW*wetness[i][j], j*cellH+cellH*wetness[i][j]);

        //Owner
        textFont(fontSmall);
        fill(255);
        text(owner[i][j], i*cellW + cellW/2, j*cellH + cellH/2);
      }
    }
  }

  void debugWind() {
    for (int i = 0; i < wetness.length; i++) {
      for (int j = 0; j < wetness[0].length; j++) {
        stroke(0, 0, 255);
        strokeWeight(1);
        line(i*cellW + cellW/2, j*cellH + cellH/2, i*cellW + cellW/2 + cos(windAngle[i][j])*cellW, j*cellH + cellH/2 + sin(windAngle[i][j])*cellH);

        stroke(255);
        strokeWeight(1);
        point(i*cellW + cellW/2, j*cellH + cellH/2);
      }
    }
  }
}

class Flower {
  float x, y;
  float size, maxSize;

  float randomAnimation = random(1000);
  float timer = 0;

  boolean active;

  int owner;

  Flower(float x_, float y_, int owner_) {
    x = x_;
    y = y_;

    size = 0;
    maxSize = 0;

    active = false;

    owner = owner_;
  }

  void create(float x_, float y_, int owner_) {
    x = x_; // + random(-em/6, em/6);
    y = y_; // + random(0, em/3);

    size = 0;
    //maxSize = random(game.emScale*0.8, game.emScale*1.2);
    maxSize = random(game.emScale*1, game.emScale*1.2);

    active = true;

    owner = owner_;
  }

  void update() {
    if (active) {
      timer += time.delta;

      if (size < maxSize) {
        size += 0.01*game.emScale*time.delta;
      }
    }
  }

  void display() {
    if (active) {
      //Wind
      int cellX = floor(map(x+size/2, 0, playArea.w, 0, terrain.cols));
      int cellY = floor(map(y+size*2, 0, playArea.h, 0, terrain.rows));
      cellX = constrain(cellX, 0, terrain.cols-1);
      cellY = constrain(cellY, 0, terrain.rows-1);
      float angle = terrain.windAngle[cellX][cellY];

      //Definir cor
      //color c;
      //if (owner == 0) {
      //  c = yellow;
      //} else if (owner == 1) {
      //  c = red;
      //} else if (owner == 2) {
      //  c = blue;
      //} else {
      //  c = grey;
      //}

      flower(x, y, size, p[owner].flowersColor, angle);

      //Balançando com o vento
      //flower(x + cos(angle)*0.2*size, y+sin(angle)*0.2*size, size, c);
    }
  }
}
