import java.util.*;// Per a fer servir la classe LinkedList implementada per Java

class Satellite {
  PVector location;// La posició del satèl·lit
  PVector velocity;// La velocitat del satèl·lit
  PVector acceleration;// L'acceleració del satèl·lit
  float mass;// La massa del satèl·lit
  LinkedList<PVector> tracePoints;// Els punts de l'òrbita que ha anat deixant el satèl·lit
  int framesSinceLastPoint;// Els frames que han passat des de que s'ha afegit l'últim punt de l'òrbita
  boolean addingPoints;// true si s'estan afegint punts, false si ja no (perquè ja s'ha completat l'òrbita)

  // Constructor del planeta
  Satellite(float locationX, float locationY, float velocityX, float velocityY) {
    mass = 1;// For now, we’ll just set the mass equal to 1 for simplicity.
    location = new PVector(locationX, locationY);
    velocity = new PVector(velocityX, velocityY);
    acceleration = new PVector(0, 0);
    tracePoints = new LinkedList();
    framesSinceLastPoint = 6;
    addingPoints = true;
  }

  // Funció que aplica la força rebuda al satèl·lit, segons la segona llei de Newton
  void applyForce(PVector force) {
    //[full] Receive a force, divide by mass, and add to acceleration.
    PVector f = PVector.div(force,mass);
    acceleration.add(f);
  }

  // Funció que actualitza la posició del satèl·lit
  void update() {
    // Motion 101 from Chapter 1
    velocity.add(acceleration);
    location.add(velocity);
    // Now add clearing the acceleration each time!
    acceleration.mult(0);
  }

  // Funció que mostra el satèl·lit (el mostra explotat si ho indica el paràmetre)
  void display(boolean destroyed) {
    fill(255, 0);
    if (destroyed) {
      image(explosion, location.x-10, location.y-10, 20, 20);
    }
    else {
      image(satellite, location.x-10, location.y-10, 20, 20);
    }
    
    stroke(0);
    for (int i = 0; i < tracePoints.size(); i++) {
      point(tracePoints.get(i).x, tracePoints.get(i).y);
      stroke(0);
    }
  }

  // Funció que comprova si el satèl·lit ha sortit fora de la pantalla i si és així fa que reboti
  void checkEdges() {
    if (location.x > width) {
      location.x = width;
      velocity.x *= -1;
    } else if (location.x < 0) {
      velocity.x *= -1;
      location.x = 0;
    }

    if (location.y > height) {
      // Even though we said we shouldn't touch location and velocity directly, there are some exceptions.
      // Here we are doing so as a quick and easy way to reverse the direction of our object when it reaches the edge.
      velocity.y *= -1;
      location.y = height;
    }
  }
}