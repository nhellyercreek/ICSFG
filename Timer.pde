class Timer {
  int duration;
  int startTime;

  Timer(int seconds) {
    this.duration = seconds * 1000;
    start();
  }

  void start() {
    startTime = millis();
  }

  boolean isFinished() {
    return millis() - startTime >= duration;
  }

  int timeLeft() {
    int remainingTime = duration - (millis() - startTime);
    return remainingTime > 0 ? remainingTime / 1000 : 0;
  }

  void reset() {
    startTime = millis();
  }

  int elapsedTime() {
    return (millis() - startTime) / 1000;
  }
}
