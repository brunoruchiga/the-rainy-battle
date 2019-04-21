void cloudCell(float x, float y, float size, int totalSmallEllipses_, float localFrameCount, color c) {
  float centerX = x+size/2;
  float centerY = y+size/2;

  //Estilo dos círculos
  fill(c);
  noStroke();

  //Círculo central
  ellipse(centerX, centerY, size, size);

  //Círculos da volta
  int totalSmallEllipses = totalSmallEllipses_;
  for (int i = 0; i < totalSmallEllipses; i++) {
    float angle = i*(TWO_PI/totalSmallEllipses);
    float offsetFromR = noise(i*10 + localFrameCount*0.0075) * (size/3);
    float distanceFromCenter = size/2 - offsetFromR;
    float smallEllipseX = centerX + (cos(angle) * distanceFromCenter);
    float smallEllipseY = centerY + (sin(angle) * distanceFromCenter);
    ellipse(smallEllipseX, smallEllipseY, size*0.67, size*0.67);
  }

  //Debug
  //noFill();
  //stroke(255, 0, 0);
  //strokeWeight(1);

  //rect(x, y, size, size);
  //point(centerX, centerY);
}

void cloudLine(float x1, float y1, float x2, float y2, float totalDistance, float ellipsesSizes, float localFrameCount, float noiseX, float noiseY) {
  //stroke(red);
  //line(x1, y1, x2, y2);

  for (float position = 0; position < totalDistance; position += ellipsesSizes*0.67) {
    float initialOffsetForNoise = position*100;
    float offsetFromR = noise(initialOffsetForNoise + localFrameCount*0.01);

    float positionFraction = position/totalDistance;
    float ellipseX = lerp(x1, x2, positionFraction);
    float ellipseY = lerp(y1, y2, positionFraction);

    fill(lightBlue);
    noStroke();
    ellipse(ellipseX + offsetFromR*noiseX, ellipseY + offsetFromR*noiseY, ellipsesSizes+offsetFromR, ellipsesSizes+offsetFromR);  

    //stroke(red);
    //point(ellipseX, ellipseY);
  }
}

void rectRain(float x, float y, float w, float h, color c, float power) {
  stroke(c);
  strokeWeight(game.emScale/10);
  //for (float i = x; i < x+w; i+=em/10) {
  //  if (random(1)<0.5) {
  //    float roundH = em + sin(frameCount*0.1 + i*0.5/TWO_PI)*0.5*em;
  //    line(i, y, i, y+roundH);
  //  }
  //}
  for (float i = x; i < x+w; i+=game.emScale/20) {
    if (random(1)<power) {
      line(i, y, i, y+random(h/2, h));
    }
  }

  if (power > 0.8) {
    if (time.realFrameCount % 240 < 10) { 
      ray(x+w/2, y, x+w/2, y + h*power, w*2/3);
    }
  }
}

void flower(float x, float y, float size, color c, float offsetAngle) {
  noStroke();

  //fill(white);
  //for (float angle = 0 + offsetAngle; angle < TWO_PI + offsetAngle; angle += TWO_PI/5) {
  //  ellipse(x + cos(angle)*size/5, y + sin(angle)*size/5, size/3, size/3);
  //}

  fill(white);
  ellipse(x, y, size/3, size/3);

  fill(c);
  for (float angle = 0 + offsetAngle; angle < TWO_PI + offsetAngle; angle += TWO_PI/5) {
    ellipse(x + cos(angle)*size/5, y + sin(angle)*size/5, size/4, size/4);
  }
}

void ray(float x1, float y1, float x2, float y2, float size) {
  stroke(yellow);
  strokeWeight(game.emScale/10);
  noFill(); 

  //line(x1, y1, x2, y2);

  beginShape();
  vertex(x1, y1);

  for (float i = 0; i < 1; i += 0.2) {
    float x_ = lerp(x1, x2, i);
    float y_ = lerp(y1, y2, i);
    vertex(x_+random(-size/2, size/2), y_+random(-size/2, size/2));
  }

  vertex(x2, y2);
  endShape();
}

void rayOpening(float x1, float y1, float x2, float y2, float size) {
  stroke(yellow);
  strokeWeight(game.emScale*2/3);
  noFill(); 

  //line(x1, y1, x2, y2);

  if (time.realFrameCount % 90 < 20) {
    beginShape();
    //vertex(x1, y1);
    for (float i = 0; i <= 1; i += 0.09) {
      float x_ = lerp(x1, x2, i);
      float y_ = lerp(y1, y2, i);
      vertex(x_+random(-size/2, size/2), y_+random(-size/2, size/2));
    }
    //vertex(x2, y2);
    endShape();
  }
}

void rayFlickering() {
  //Animação de relâmpagos
  if (time.realFrameCount % 6 > 5) {
    fill(white);
    noStroke();
    rect(0, 0, canvas.w, canvas.h);
  }
}



void arrow(PVector position, PVector vectorAcceleration) {
  float angle = vectorAcceleration.heading();
  float x = position.x - cos(angle)*1.5*em;
  float y = position.y - sin(angle)*1.5*em;

  float size = em/2 + sin(time.realFrameCount * 0.2) * em/10;

  noStroke();
  fill(white);
  ellipse(x, y, size, size);
}

void displayTouch(float x, float y) {
  float size = em/2 + sin(time.realFrameCount * 0.2) * em/10;

  noStroke();
  fill(white);
  ellipse(x, y, size, size);
}

void playerIcon(float x, float y) {
  fill(white);
  noStroke();
  ellipse(x, y - em/2, em, em);
  arc(x, y + 1.05*em, em*1.75, em*1.75, PI, TWO_PI);
}

void displayBack (float x, float y) {
  stroke(white);
  strokeWeight(em * 0.15);
  noFill();

  line(x + 0, y + 0.5*em, x + em, y + 0.5*em);
  beginShape();
  vertex(x+0.5*em, y);
  vertex(x + 0, y + 0.5*em);
  vertex(x+0.5*em, y+em);
  endShape();
}

void crown(float x, float y, float size, color c) {
  pushMatrix();
  translate(x, y);
  beginShape();
  
  fill(c);
  noStroke();
  
  vertex(-size*0.2,   0         );
  vertex(-size*0.4,   -size*0.40);
  vertex(-size*0.15,  -size*0.30);
  vertex(0,           -size*0.5 );
  vertex(size*0.15,   -size*0.30);
  vertex(size*0.4,    -size*0.40);
  vertex(size*0.2,    0         );
  
  endShape(CLOSE);
  popMatrix();
}

void playIcon(float x, float y, float size) {
  fill(white);
  noStroke();
  
  beginShape();
  vertex(x-size/2, y-size/2);
  vertex(x+size/2, y);
  vertex(x-size/2, y+size/2);
  endShape(CLOSE);
}
