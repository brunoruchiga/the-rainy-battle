class Food {
  float size, maxSize;

  PVector pos;
  PVector vel;
  PVector acc;

  float randomAnimation = random(1000);
  float timer = 0;

  boolean active;

  Food(float x, float y) {
    size = 0;
    maxSize = random(game.emScale/2 - game.emScale/8, game.emScale/2 + game.emScale/8);

    pos = new PVector(x, y);
    vel = new PVector();
    acc = new PVector();
    
    active = false;
  }
  
  void create(float x, float y) {
    size = 0;
    maxSize = random(game.emScale/2 - game.emScale/8, game.emScale/2 + game.emScale/8);

    pos.set(x, y);
    vel.set(0, 0);
    acc.set(0, 0);
    
    active = true;    
  }

  void update() {
    if (active) {
      //Born animation
      if (size < maxSize) {
        size += 0.005*game.emScale*time.delta;
      } else {
        size = maxSize;
      }

      accelerateFromWind();
      move();

      timer += time.delta;
    }

    if (pos.x < 0 || pos.x > canvas.w || pos.y < 0 - 3*size || pos.y > canvas.h) {
      active = false;
    }
  }

  void accelerateFromWind() {
    //Wind
    int cellX = floor(map(pos.x+size/2, 0, playArea.w, 0, terrain.cols));
    int cellY = floor(map(pos.y+size*2, 0, playArea.h, 0, terrain.rows));
    cellX = constrain(cellX, 0, terrain.cols-1);
    cellY = constrain(cellY, 0, terrain.rows-1);

    float angle = terrain.windAngle[cellX][cellY];
    acc.set(0.0001*game.emScale, 0);
    acc.rotate(angle);
  }

  void move() {
    vel.add(acc.x * time.delta, acc.y * time.delta);
    pos.add(vel.x * time.delta, vel.y * time.delta);
  }

  void displayShadow() {
    if (active) {
      //Sombra
      fill(shadow);
      noStroke();
      ellipse(pos.x+size/2, pos.y + 3*size, 1.2*size, 1.2*size/2);
    }
  }

  void display() {
    if (active) {
      cloudCell(pos.x, pos.y, size, 6, timer + randomAnimation, lightBlue);
    }
  }

  void debug() {
    noFill();
    stroke(255, 0, 0);
    strokeWeight(1);

    rect(pos.x, pos.y, size, size);
    point(pos.x + size/2, pos.y + size/2);
  }

  boolean intersects(Player player) {
    float extra = this.size/2;

    if (active &&
      player.pos.x < this.pos.x + this.size + extra &&
      player.pos.x + player.w > this.pos.x - extra &&
      player.pos.y < this.pos.y + this.size + extra &&
      player.pos.y + player.h > this.pos.y - extra) {
      return true;
    } else {
      return false;
    }
  }
}

class FoodGenerator {
  float timer;

  FoodGenerator() {
    timer = 0;
  }

  void update() {
    timer += time.delta;
  }

  void createFood(float periodOfTimeInFrames) {
    if (timer > periodOfTimeInFrames) {
      boolean foodCreated = false;
      for(int i = 0; i < foods.length; i++) {
        if(!foods[i].active && !foodCreated) {
          foods[i].create(random(playArea.w), random(playArea.h)); // = new Food(random(canvas.w), random(canvas.h));
          foodCreated = true;
        }
      }
      
      timer = 0;
    }
  }
}
