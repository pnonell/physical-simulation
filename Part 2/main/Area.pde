class Area {
  LinkedList<PVector> allPoints;// Punter cap a la llista de tots els punts de l'òrbita
  
  PVector center;// El centre de l'òrbita (la posició del planeta)
  
  PVector first;// La posició del primer punt de l'orbita que defineix l'àrea
  int firstIndex;// L'índex del primer punt de l'orbita que defineix l'àrea
  
  PVector middle;// La posició del punt mitjà de l'orbita que defineix l'àrea
  int middleIndex;// L'índex del punt mitjà de l'orbita que defineix l'àrea
  
  PVector last;// La posició de l'últim punt de l'orbita que defineix l'àrea
  int lastIndex;// L'índex de l'últim punt de l'orbita que defineix l'àrea
  
  float trapezoidalArea;// L'àrea calculada per Trapezi
  
  float simpsonArea;// L'àrea calculada per Simpson
  
  Satellite satellite;// Punter cap al satèl·lit de la simulació
  
  // Constructor de l'àrea
  Area(LinkedList<PVector> allPoints, PVector center, int firstIndex, Satellite satellite) {
    this.allPoints = allPoints;
    this.center = center;
    this.first = this.allPoints.get(firstIndex);
    
    this.firstIndex = firstIndex;
    this.first = this.allPoints.get(firstIndex);
    
    this.satellite = satellite;
    
    trapezoidalArea = 0;
  
    simpsonArea = 0;
  }
  
  // Funció que calcula la posició i els índexs dels punts final i mitjà de l'àrea
  void computePoints() {
    // Punt final de l'àrea
    int lastIndex = firstIndex + 4;
    if (lastIndex >= this.allPoints.size()) {
      lastIndex = lastIndex - this.allPoints.size();
      if (satellite.addingPoints) {
        this.last = this.allPoints.getLast();
        this.lastIndex = this.allPoints.size() - 1;
      }
      else {
        this.last = this.allPoints.get(lastIndex);
        this.lastIndex = lastIndex;
      }
    }
    else {
      this.last = this.allPoints.get(lastIndex);
      this.lastIndex = lastIndex;
    }
    // Punt mitjà de l'àrea
    int middleIndex = firstIndex + 2;
    if (middleIndex >= this.allPoints.size()) {
      middleIndex = middleIndex - this.allPoints.size();
      if (satellite.addingPoints) {
        this.middle = this.allPoints.getLast();
        this.middleIndex = this.allPoints.size() - 1;
      }
      else {
        this.middle = this.allPoints.get(middleIndex);
        this.middleIndex = middleIndex;
      }
    }
    else {
      this.middle = this.allPoints.get(middleIndex);
      this.middleIndex = middleIndex;
    }
  }
  
  // Funció que calcula l'àrea per Trapezi
  void computeTrapezoidalArea() {
    PVector firstVector = PVector.sub(this.first, this.center);
    PVector lastVector = PVector.sub(this.last, this.center);
    float f1 = firstVector.mag();
    float f2 = lastVector.mag();
    firstVector.normalize();
    lastVector.normalize();
    float angleBetween = PVector.angleBetween(firstVector, lastVector);

    trapezoidalArea = (angleBetween * (( (f1*f1) + (f2*f2) )/2) ) * 0.5;
  }
  
  // Funció que calcula l'àrea per Simpson
  void computeSimpsonArea() {
    PVector firstVector = PVector.sub(this.first, this.center);
    PVector middleVector = PVector.sub(this.middle, this.center);
    PVector lastVector = PVector.sub(this.last, this.center);
    float f1 = firstVector.mag();
    float fMiddle = middleVector.mag();
    float f2 = lastVector.mag();
    firstVector.normalize();
    lastVector.normalize();
    float angleBetween = PVector.angleBetween(firstVector, lastVector);
    
    simpsonArea = ((f1*f1) + (4*(fMiddle*fMiddle)) + (f2*f2)) * angleBetween * (1.0/6.0) * 0.5;
  }
  
  // Funció que demana calcular la posició i els índexs dels punts final i mitjà de l'àrea i demana calcular les àrees per Trapezi i per Simpson
  void update() {
    computePoints();
    computeTrapezoidalArea();
    computeSimpsonArea();
  }
  
  // Funció que pinta l'àrea amb el color rebut i el text amb el càlcul de l'àrea en la posició vertical rebuda
  void display(int[] strokeColor, int displayY) {
    stroke(strokeColor[0], strokeColor[1], strokeColor[2]);
    
    int limit = allPoints.size() - firstIndex;
    if (limit > 5) {
      limit = 5;
    }
    for (int i = 0; i < limit; i++) {
      line(center.x, center.y, allPoints.get(firstIndex + i).x, allPoints.get(firstIndex + i).y);
    }
    if (limit < 5 && !satellite.addingPoints) {
      int remaining = 5 - limit;
      for (int i = 0; i < remaining; i++) {
        line(center.x, center.y, allPoints.get(i).x, allPoints.get(i).y);
      }
    }
    stroke(0);
    
    textSize(12);
    fill(strokeColor[0], strokeColor[1], strokeColor[2]);
    text(trapezoidalArea, 380, 50 + displayY);
    text(simpsonArea, 500, 50 + displayY);
  }
}