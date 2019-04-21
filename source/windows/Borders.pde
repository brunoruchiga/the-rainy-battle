class Borders {
  float x, y, w, h;
  //float finalH;

  Borders(float x_, float y_, float w_, float h_) {
    x = x_ + canvas.x;
    y = y_ + canvas.y;
    w = w_;
    h = h_;
    
    //finalH = h_;
  }
  
  Borders(PlayArea pA) {
    x = pA.x + canvas.x;
    y = pA.y + canvas.y;
    w = pA.w;
    h = pA.h;
    
    //finalH = pA.h;
  }

  void display() {
    //h = lerp(h, finalH, 0.2);
    
    fill(lightBlue);
    noStroke();
    rect(0, 0, width, y); //top
    rect(x+w, 0, width-x-w, height); //right
    rect(0, y+h, width, height-y-h); //bottom
    rect(0, 0, x, height); //left

    //Linhas-nuvem
    float size = 3*em;
    float posVariationAmount = em;
    cloudLine(x, y, x+w, y, w, size, time.realFrameCount+100, 0, -posVariationAmount); //top
    cloudLine(x+w, y, x+w, y+h, h, size, time.realFrameCount+200, posVariationAmount, 0); //right
    cloudLine(x+w, y+h, x, y+h, w, size, time.realFrameCount+300, 0, posVariationAmount); //bottom
    cloudLine(x, y+h, x, y, h, size, time.realFrameCount+400, -posVariationAmount, 0); //left

    //cloudLine(canvas.x+em, canvas.y, canvas.x + canvas.w - em, canvas.y, time.realFrameCount+0);
    //cloudLine(canvas.x+em, canvas.y+canvas.h-em, canvas.x + canvas.w - em, canvas.y+canvas.h-em, time.realFrameCount+1);
    //cloudLine(canvas.x+em, canvas.y, canvas.x + em, canvas.y + canvas.h-em, time.realFrameCount+2);
    //cloudLine(canvas.x+canvas.w-em, canvas.y+em, canvas.x + canvas.w - em, canvas.y+canvas.h-em, time.realFrameCount+3);
  }
  
  void debug() {
    stroke(red);
    strokeWeight(1);
    line(x, y, x+w, y); //top
    line(x+w, y, x+w, y+h); //right
    line(x+w, y+h, x, y+h); //bottom
    line(x, y+h, x, y); //left
  }
}
