// La classe Worm s'encarrega de la lògica de moviment i de la visualització d'un cuc
class Worm {
  PVector location;// la localització del cuc
  PVector velocity;// la velocitat del cuc
  int type;// el tipus del cuc. Visualment és el color del cuc
  int times;// és el nombre de frames que queden per a que la seva velocitat canvii de direcció
  
  // Constructor de la classe Worm
  Worm() {
      location = new PVector(random(width), random(height));// Posició aleatòria
      type = (int) random(3) + 1;// el tipus del cuc és aleatori. Visualment és el color del cuc
      times = 0;// Inicialment el nombre de frames que queden per a que la seva velocitat canvii de direcció és 0 per a forçar que es calculi una nova velocitat aleatòria
  }
  
  // La funció update actualitza la posició del cuc a cada frame. El cuc es mourà en una direcció random amb velocitat constant 1, doncs random2D genera un vector unitari
  void update() {
    // Mirem el nombre de frames que queden per a que la seva velocitat canvii de direcció
    if (times == 0) {
      // El nombre de frames que queden per a que la seva velocitat canvii de direcció han arribat a 0, per tant, cal calcular una nova velocitat (direcció aleatòria, mòdul 1)
      velocity = PVector.random2D();
      times = 50;// Ara queden 50 frames per a que la seva velocitat canvii de direcció
    }
    else {
      // El nombre de frames que queden per a que la seva velocitat canvii de direcció ENCARA NO ha arribat a 0
      times--;
    }
    location.add(velocity);// Calculem la nova posició sumant la localització i la velocitat
  }
  
  // La funció checkEdges comprova si el cuc ha sortit fora de la pantalla i si ha sortit canvia la velocitat per tal de que reboti
  void checkEdges() {
    // En primer lloc comprovem si el cuc ha sortit fora de la pantalla
    if (!(location.x >= 0 && location.x <= width && location.y >= 0 && location.y <= height)) {
      // La nova localització està fora de la pantalla. Cal canviar la velocitat per tal de que reboti
      if (!(location.x >= 0 && location.x <= width)) {
        velocity.x *= -1;
      }
      if (!(location.y >= 0 && location.y <= height)) {
        velocity.y *= -1;
      }
    }
  }
  
  // La funció display pinta el cuc, representant-lo d'un color o altre en funció de la seva variable 'type'
  void display() {
    // Escollim la imatge per representar-lo d'un color o altre en funció de la seva variable 'type'
    if (type == 1) {
      image(worm1, location.x-20, location.y-20, 40, 40);
    }
    else if (type == 2) {
      image(worm2, location.x-20, location.y-20, 40, 40);
    }
    else if (type == 3) {
      image(worm3, location.x-20, location.y-20, 40, 40);
    }
  }
}