class Planet {
  float mass;// La massa del planeta
  PVector location;// La posició del planeta
  float G;// La constant de gravitació universal. Per a aquesta simulació, utilitzem un valor arbitrari
  float rMin[];// Els 3 últims valors de r. Permeten determinar quan s'ha trobat un mínim relatiu
  float rMax[];// Els 3 últims valors de r. Permeten determinar quan s'ha trobat un màxim relatiu
  boolean raisedMin;// true quan s'ha trobat un mínim relatiu, false quan no
  boolean raisedMax;// true quan s'ha trobat un màxim relatiu, false quan no

  // Constructor del planeta
  Planet() {
    location = new PVector(width/2,height/2);
    mass = 20;
    G = 2.8;// La constant de gravitació universal. Per a aquesta simulació, utilitzem un valor arbitrari
    // Per començar
    rMin = new float[3];
    rMin[0] = -1;
    rMin[1] = -1;
    rMin[2] = -1;
    // Per començar
    rMax = new float[3];
    rMax[0] = -1;
    rMax[1] = -1;
    rMax[2] = -1;
    raisedMin = false;// Per defecte encara no s'ha trobat el mínim
    raisedMax = false;// Per defecte encara no s'ha trobat el màxim
  }

  /// Funció que calcula la força que cal aplicar sobre el satèl·lit ja que la Terra l'atrau
  PVector attract(Satellite m) {
    PVector force = PVector.sub(location,m.location);
    float distance = force.mag();
    
    if (!raisedMin && distance != rMin[2]) {
      rMin[0] = rMin[1];
      rMin[1] = rMin[2];
      rMin[2] = distance;
    }
    
    if (!raisedMax && distance != rMax[2]) {
      rMax[0] = rMax[1];
      rMax[1] = rMax[2];
      rMax[2] = distance;
    }
    
    // Check min
    if (rMin[0] > rMin[1] && rMin[1] < rMin[2] && rMin[0] >= 0 && rMin[1] >= 0 && rMin[2] >= 0) {
      // mínim relatiu trobat: rMin[1]
      raisedMin = true;
    }
    
    // Check max
    if (rMax[0] < rMax[1] && rMax[1] > rMax[2] && rMax[0] >= 0 && rMax[1] >= 0 && rMax[2] >= 0) {
      // màxim relatiu trobat: rMax[1]
      raisedMax = true;
    }
    
    force.normalize();
    float strength = (G * mass * m.mass) / (distance * distance);
    force.mult(strength);
    return force;
  }
  
  // Funció que comprova si s'ha produit col·lisió entre el satèl·lit i la Terra
  boolean checkCollision(Satellite m) {
    PVector distance = PVector.sub(location,m.location);
    float distanceMag = distance.mag();
    if (distanceMag <= 20+10) {
      return true;
    }
    else {
      return false;
    }
  }

  // Funció que pinta el planeta
  void display() {
    fill(255, 0);
    image(planet, location.x-20, location.y-20, 40, 40);
  }
}