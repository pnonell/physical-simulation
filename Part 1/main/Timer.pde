// La classe Timer s'encarrega de la lògica del comptador
class Timer {
  int initialTime;// Instant en què el comptador comença a comptar els milisegons (s'actualitza cada segon)
  int interval;// Quantitat de milisegons que quan s'arriba cal tenir en compte que ha passat 1 segon
  int maxTime;// Temps màxim de la partida (ho diu l'enunciat)
  int time;// Temps restant de la partida
  
  // Constructor de la classe Timer
  Timer() {
    interval = 1000;// Quantitat de milisegons que quan s'arriba cal tenir en compte que ha passat 1 segon
    maxTime = 60;// Temps màxim de la partida (ho diu l'enunciat)
    time = maxTime;// La partida comença amb el temps màxim
    initialTime = millis();// Capturem l'instant en què comença a comptar els milisegons
  }
  
  // La funció update actualitza el comptador
  void update() {
    if (millis() - initialTime > interval && time > 0) {
      // Ha passat 1 segon (i encara no s'ha esgotat el temps)
      time--;// Ha passat 1 segon. El reduim en el temps restant de la partida
      initialTime = millis();// Capturem l'instant en què comença a comptar els milisegons perquè ha passat 1 segon
    }
  }
}