class Time {
  int prevMillis = 0;
  float delta = 1000.0/SEC - prevMillis; // Delta Time
  
  float realFrameCount = 0;

  Time() {
    prevMillis = 0;
    delta = 1000.0/SEC - prevMillis;
  }

  void update() {
    delta = (millis() - prevMillis)*SEC/1000.0;
    if(delta > SEC/10) {
      delta = SEC/10;
    }
    
    prevMillis = millis();
    
    realFrameCount += delta;
  }

  void debug() {
    println("DeltaTimeFactor: " + delta, "FrameRate: " + frameRate);
  }
}
