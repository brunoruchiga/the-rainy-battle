class Time {
  int prevMillis = 0;
  float delta = 1000/60 - prevMillis; // Delta Time
  
  float realFrameCount = 0;
  float game = 0;

  Time() {
    prevMillis = 0;
    delta = 1000/60.0 - prevMillis;
  }

  void update() {
    delta = (millis() - prevMillis)*60/1000.0;
    if(delta > 6) {
      delta = 6;
    }
    
    prevMillis = millis();
    
    realFrameCount += delta;
    game += delta;
  }

  void debug() {
    println("DeltaTimeFactor: " + delta, "FrameRate: " + frameRate);
  }
}
