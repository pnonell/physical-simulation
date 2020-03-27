class Controller {
  char option;// L'exercici que es vol executar
  Satellite satellite;// El satèl·lit que orbita
  Planet planet;// El planeta en el centre de l'òrbita
  boolean collision;// true si el satèl·lit ha col·lisionat amb la terra, false si no
  boolean computedEccentricity;// true si ja s'ha calculat l'excentricitat i per tant ja es pot mostrar, false si no
  float eccentricity;// Valor de l'excentricitat calculada
  LinkedList<Area> areas;// Llistat de les àrees marcades
  float angleMin[];// Els 3 últims valors de l'angle entre l'últim punt i el primer punt de l'òrbita. Permeten determinar quan s'ha dibuixat l'òrbita sencera
  boolean raisedAngleMin;// true quan s'ha dibuixat l'òrbita sencera, false quan no
  boolean showErrorMessage;// true si cal mostrar missatge d'error, false si no
  int framesShowingErrorMessage;// Quantitat de frames que han passat des de es va mostrar el missatge d'error

  // Constructor del controlador
  Controller(char option) {
    planet = new Planet();
    collision = false;
    this.option = option;
    
    // Inicialització dels 3 últims valors de l'angle entre l'últim punt i el primer punt de l'òrbita. Permeten determinar quan s'ha dibuixat l'òrbita sencera
    angleMin = new float[3];
    angleMin[0] = -1;
    angleMin[1] = -1;
    angleMin[2] = -1;
    raisedAngleMin = false;// Per defecte encara no s'ha trobat el mínim
    
    switch (option) {
      case 'A':
        satellite = new Satellite(200, 100, 0, 0);
        break;
      case 'B':
        satellite = new Satellite(width/2-50,height/2+100, 0.6, 0);
        break;
      case 'C':
        satellite = new Satellite(width/2-50,height/2+100, 0.6, 0);
        areas = new LinkedList<Area>();
        break;
      case 'D':
      int r = round((planet.G * planet.mass)/pow(0.6, 2));
        //int r = round((4* pow(PI, 2))/(a.G * a.mass));
        satellite = new Satellite(width/2, height/2 + r, 0.6, 0);
        break;
    }
    computedEccentricity = false;
    
    showErrorMessage = false;
    framesShowingErrorMessage = 0;
  }
  
  // Funció que actualitza la simulació segons l'exercici que s'està executant
  void update() {  
    switch (option) {
      case 'A':
        updateA();
        break;
      case 'B':
        updateA();
        break;
      case 'C':
        updateA();
        updateC();
        break;
      case 'D':
        updateA();
        break;
    }
  }
  
  // Funció que pinta la simulació segons l'exercici que s'està executant
  void display() {
    background(255);
    switch (option) {
      case 'A':
        displayA();
        break;
      case 'B':
        displayA();
        displayB();
        break;
      case 'C': 
        displayA();
        displayC();
        break;
      case 'D':
        displayA();
        break;
    }
  }

  // Actualitza la simulació amb els elements de l'exercici A. Actualitza la posició del satèl·lit i va deixant puntets
  void updateA() {
    if (collision) return;
    
    // Apply the attraction force from the Planet on the Satellite.
    PVector force = planet.attract(satellite);
    satellite.applyForce(force);
    satellite.update();
    collision = planet.checkCollision(satellite);
    
    if (satellite.addingPoints && satellite.framesSinceLastPoint == 6) {
      
      PVector newPoint = new PVector(satellite.location.x, satellite.location.y);

      if (satellite.tracePoints.size() > 0) {
        PVector firstPoint = satellite.tracePoints.getFirst();
        PVector firstLine = PVector.sub(firstPoint, planet.location);
        firstLine.normalize();
        
        PVector newLine = PVector.sub(newPoint, planet.location);
        newLine.normalize();
        
        float angle = PVector.angleBetween(firstLine, newLine);
        
        if (!raisedAngleMin && angle != angleMin[2]) {
          angleMin[0] = angleMin[1];
          angleMin[1] = angleMin[2];
          angleMin[2] = angle;
        }
        
        // Check min
        if (angleMin[0] > angleMin[1] && angleMin[1] < angleMin[2] && angleMin[0] >= 0 && angleMin[1] >= 0 && angleMin[2] >= 0 && option == 'C') {
          // mínim relatiu trobat: angleMin[1]
          raisedAngleMin = true;
          satellite.addingPoints = false;
        }
                
        if (raisedAngleMin) {
          satellite.tracePoints.removeLast();
        }
      }

      if (satellite.addingPoints) {
        // Add point
        satellite.tracePoints.addLast(newPoint);
        satellite.framesSinceLastPoint = 0;
      }
    }
    else {
      satellite.framesSinceLastPoint++;
    }
  }
  
  // Pinta la simulació amb els elements de l'exercici A: el planeta i el satèl·lit (el mostra explotat si ha col·lisionat)
  void displayA() {
    planet.display();
    satellite.display(collision);
  }
  
  // Pinta la simulació amb els elements de l'exercici B: mostra els valors numèrics de r min i max i el valor de l'excentricitat
  void displayB() {
    fill(0);
    textSize(16);
    text((planet.raisedMin) ? "r_min: " + planet.rMin[1] : "Trobant mínim... r: " + planet.rMin[1], 40, 40); 
    text((planet.raisedMax) ? "r_max: " + planet.rMax[1] : "Trobant màxim... r: " + planet.rMax[1], 40, 70);
    if (planet.raisedMin && planet.raisedMax) {
      if (!computedEccentricity) {
        float min = planet.rMin[1];
        float max = planet.rMax[1];
        float c = (min+max)/2-min;
        float a = (min+max)/2;
        eccentricity = c/a;
      }
      text("e = " + eccentricity, 40, 100);
    }
  }
  
  // Actualitza la simulació amb els elements de l'exercici C, que són les àrees
  void updateC() {
    for (int i = 0; i < areas.size(); i++) {
      areas.get(i).update();
    }
  }
  
  // Pinta la simulació amb els elements de l'exercici C, que són les àrees
  void displayC() {
    textSize(12);
    fill(0);
    text("Àrees per Trapezi", 385, 30);
    text("Àrees per Simpson", 505, 30);
    for (int i = 0; i < areas.size(); i++) {
      int colorId = i;
      while (colorId >= 10) {
        colorId -= 10;
      }
      areas.get(i).display(colors[colorId], i*20);
    }
    
    if (showErrorMessage) {
      fill(255, 0, 0);
      text("No es pot marcar una àrea a sobre d'una altra.", 30, 30);
      text("Si us plau, torna-ho a provar.", 30, 50);
      framesShowingErrorMessage++;
      if (framesShowingErrorMessage > 500) {
        showErrorMessage = false;
        framesShowingErrorMessage = 0;
      }
    }
  }
  
  // Guarda l'àrea marcada per l'usuari quan aquest prem la tecla intro
  void saveArea() {
     if (option != 'C') {
       return;
     }
    
     if (this.satellite.addingPoints) {
       // Comprovar que el punt no estigui ocupat per alguna àrea
       boolean free = true;
       int desiredPoint = controller.satellite.tracePoints.size()-1;
       for (int i = 0; i < controller.areas.size(); i++) {
         if (desiredPoint <= controller.areas.get(i).lastIndex) {
           controller.showErrorMessage = true;
           controller.framesShowingErrorMessage = 0;
           free = false;
           break;
         }
       }
       if (free) {
         Area area = new Area(controller.satellite.tracePoints, controller.planet.location, desiredPoint, this.satellite);
         controller.areas.addLast(area);
       }
     }
     else {
       // Trobar el punt més proper
       int index = 0;
       PVector dif = PVector.sub(this.satellite.location, controller.satellite.tracePoints.get(index));
       float minDistance = dif.mag();
       for (int i = 1; i < controller.satellite.tracePoints.size(); i++) {
         PVector dif2 = PVector.sub(this.satellite.location, controller.satellite.tracePoints.get(i));
         float mag = dif2.mag();
         if (mag < minDistance) {
           index = i;
           minDistance = mag;
         }
       }
       // Comprovar que el punt no estigui ocupat per alguna àrea
       boolean free = true;
       int desiredPoint = index;
       for (int i = 0; i < controller.areas.size(); i++) {
         if (controller.areas.get(i).firstIndex < controller.areas.get(i).lastIndex) {
           // És una àrea normal
           if (desiredPoint >= controller.areas.get(i).firstIndex && desiredPoint <= controller.areas.get(i).lastIndex) {
             controller.showErrorMessage = true;
             controller.framesShowingErrorMessage = 0;
             free = false;
             break;
           }
         }
         if (controller.areas.get(i).firstIndex > controller.areas.get(i).lastIndex) {
           // És una àrea "partida" perquè s'ha fet en el tall de l'òrbita
           if (desiredPoint >= controller.areas.get(i).firstIndex || desiredPoint <= controller.areas.get(i).lastIndex) {
             controller.showErrorMessage = true;
             controller.framesShowingErrorMessage = 0;
             free = false;
             break;
           }
         }
       }
       if (free) {
         Area area = new Area(controller.satellite.tracePoints, controller.planet.location, index, this.satellite);
         controller.areas.addLast(area);
       }
     }
  }
}