// La classe Snake s'encarrega de la lògica de moviment i de la visualització d'una bola de la serp
class Snake {
  boolean isHead;// true si la bola és el cap de la serp, false si no
  PVector location;// la localització de la bola
  PVector velocity;// la velocitat de la bola
  float topspeed;// la velocitat màxima de la bola
 
  // Constructor de la classe Snake
  Snake(PVector last) {
    // Inicialitzem la bola al centre de la pantalla o darrere de la última bola en funció de si estem creant la bola del cap o una bola del cos 
    if (last == null) {
      isHead = true;
      location = new PVector(width/2,height/2);
    }
    else { 
      isHead = false;
      location = last;
    }
    velocity = new PVector(0, 0);
    topspeed = 10;
  }
 
  // La funció update actualitza la posició de la bola
  void update(PVector mouse) {
    // Calculem la direcció fent la diferència de vectors entre la localització de la bola i el mouse
    // mouse més lluny --> més velocitat
    // mouse més a prop --> menys velocitat
    PVector dir = PVector.sub(mouse, location);

    // Escalem la direcció
    dir.setMag(dir.mag() * 0.05);

    // L'assignem la velocitat
    velocity = dir;

    // Limitem la velocitat
    velocity.limit(topspeed);

    // Calculem la distància fins a la bola de davant per tal de que si és una bola del cos aquesta no es posi a sobre de la de davant
    float distance = PVector.sub(mouse, location).mag();
    if (isHead || distance > 16) {// distance > 16 perquè 16 és 2R, on R és el radi de cada bola de la serp, que és 8
      // No es posa a sobre de la bola de davant per tant en principi la podem moure
      PVector nextPos = PVector.add(location, velocity);
      // Però abans cal mirar que no surti fora de la pantalla
      if (nextPos.x >= 0 && nextPos.x <= width && nextPos.y >= 0 && nextPos.y <= height) {
        // La bola no surt fora de la pantalla, per tant, la podem moure
        location.add(velocity);
      }
    }
  }

  // La funció display pinta la bola de la serp
  void display() {
    // Pintem la bola, segons si és cap o cos
    if (isHead) {
      image(snakeHead, location.x-8, location.y-8, 16, 16);
    }
    else {
      image(snakeBody, location.x-8, location.y-8, 16, 16);
    }
  }
}