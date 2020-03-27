class Ball {

  int option;

  PVector location;
  PVector velocity;
  PVector acceleration;
  
  float mass;
  int r;// Radi
  
  Bob bob;
  Spring spring;
  
  boolean ground;// És true durant tota la estona que la bola està al terra
  boolean groundStart;// És true només 1 cop (1 frame) quan la bola toca el terra
  
  float oldVelocity;
  
  // Interacció ratolí amb la pilota
  PVector dragOffset;
  boolean dragging = false;
  
  int frame; //total frames
  float A; //amplitud
  float k = 0.1;
  int y;//distància de deformació de la pilota
  float w;

  // Per a saber quan y (opció 2) o d (opció 3) passa pel valor mínim
  float dMin[];// Els 3 últims valors de y (opció 2) o d (opció 3). Permeten determinar quan s'ha trobat un mínim relatiu
  boolean raisedMin;// true si s'ha trobat un mínim relatiu, false quan no
  
  // Per a saber quan y (opció 2) o d (opció 3) passa per 0
  float dZero[];// Els 2 últims valors de y (opció 2) o d (opció 3). Permeten determinar quan s'ha passat per 0
  boolean raisedZero;// true si s'ha passat per 0, false quan no
  
  
  Ball(int option) {
    this.option = option;
    mass = 1;
    r = 40;
    location = new PVector(width/2, 60);
    velocity = new PVector(0,0);
    acceleration = new PVector(0,0);
    dragOffset = new PVector();
    
    ground = false;
    
    dMin = new float[3];
    dMin[0] = -99999;
    dMin[1] = -99999;
    dMin[2] = -99999;
    raisedMin = false;// Per defecte encara no s'ha trobat el mínim
    dZero = new float[2];
    dZero[0] = -99999;
    dZero[1] = -99999;
    raisedZero = false;// Per defecte encara no s'ha passat pel 0

    switch (option) {
      case 1:
        break;
      case 2:
        frame = 0;
        y = 0;
        //només pel control
        w = 0;
        groundStart = false;
        break;
      case 3:
        spring = new Spring(0, r, -1*r, this);
        bob = new Bob(0, r, this);
        bob.velocity = new PVector(0, 0);
        groundStart = false;
        break;
    }
  }

  void applyForce(PVector force) {
    PVector f = PVector.div(force,mass);
    acceleration.add(f);
  }

  void update() {
    frame++;
    if (!dragging) {
      velocity.add(acceleration);
      location.add(velocity);
      translate(location.x, location.y);
      acceleration.mult(0);
      
      if (option == 3) {
        bob.update();
        spring.connect(bob);
        //calculem la velocitat inicial del bob
        if (this.groundStart) {
          bob.velocity.y = sqrt(0.2) * oldVelocity; 
        }
        //comprovem quan estigui al terra si compleix les condicions per començar el rebot
        if (this.ground) {
          if (this.raisedMin && this.raisedZero) {
            this.ground = false;
            this.raisedMin = false;
            this.raisedZero = false;
            velocity.y = -1 * sqrt(0.8) * oldVelocity;
          }
        }
      }
      if(option == 2){
        //actualitzem els mínims relatius si encara no ha arribat a un
        if (!raisedMin && y != dMin[2]) {
        dMin[0] = dMin[1];
        dMin[1] = dMin[2];
        dMin[2] = y;
        }
        if (!raisedZero && y != dZero[1]) {
          dZero[0] = dZero[1];
          dZero[1] = y;
        }
         // Check min
        if (ground & dMin[0] < dMin[1] && dMin[1] > dMin[2] && dMin[0] != -99999 && dMin[1] != -99999 && dMin[2] != -99999) {
          // mínim relatiu trobat: dMin[1]
          raisedMin = true;
        }
        
        // Check zero
        if (ground & dZero[0] * dZero[1] > 0 && dZero[0] != -99999 && dZero[1] != -99999 && raisedMin) {
          // pas per 0 trobat
          raisedZero = true;
        }
        //si ha tocat el terra, calculem l'amplitud i freqüència de l'oscil.lació de la pilota
        if (this.groundStart) {
          A = sqrt(0.2 * (mass/k) * pow(oldVelocity, 2));
          w = (sqrt(0.2) * oldVelocity)/A;
          frame = 0;
        }
        //si està al terra, mirem si compleix les condicions per començar el rebot ascendent
        if (this.ground) {
          if (raisedMin && raisedZero) {
            this.ground = false;
            raisedMin = false;
            raisedZero = false;
            velocity.y = -1 * sqrt(0.8) * oldVelocity;
          }
        } else {
          //si està a l'aire, apliquem un damping a l'amplitud per fer més realista la deformació
          if (A < 2){
            A = 0;
          } else {
            A *= 0.98;
          }
        }
        //calcul de la deformació
        y = round(A * sin(w * frame));
      }
    }
    
    // funció per arrastrar la pilota
    drag(mouseX,mouseY);
  }

  void display() {
    stroke(0);
    fill(175);
    //si estem arrastrant la pilota la pintem diferent
    if (dragging) {
      fill(50);
      ellipse(location.x, location.y, r*2, r*2);
    }
    else {      
      switch (option) {
        case 1:
          image(ball, -r, -r, r*2, r*2);
          break;
        case 2:
          image(ball, -r, -r + y, r*2, r*2 - y);
          break;
        case 3:
          image(ball, -r, -r-spring.d, r*2, r*2+spring.d);
          break;
      }
    }
    //mostrem la molla si estem a l'opció tres
    if (option == 3 && !dragging) { 
      spring.display();
      bob.display();
      spring.displayLine(bob);
    }
  }

  // limitem la pilota als limits de la pantalla i en cas de fer-ho, canviem les variables en funció de l'opció que estem
  void checkEdges() {
    if (location.x > width-r) {
      location.x = width-r;
      velocity.x *= -1;
    } else if (location.x < 0+r) {
      velocity.x *= -1;
      location.x = 0+r;
    }

    if (location.y > height-r) {
      switch (option) {
        case 1:
          velocity.y *= -1;
          break;
        case 2:
        case 3:
          this.oldVelocity = velocity.y;
          velocity.y = 0;
          ground = true;
          groundStart = true;
          break;
      }
      location.y = height-r;
    }
    else {
      if (option == 3 || option == 2) groundStart = false;
    }
  }
  
  // Els següents metodes són per la interacció del ratolí amb la pilota

  // comprova si hem clicat l'objecte
  void clicked(int mx, int my) {
    float d = dist(mx,my,location.x,location.y);
    if (d < r && !ground) {
      dragging = true;
      dragOffset.x = location.x-mx;
      dragOffset.y = location.y-my;
    }
  }

  void stopDragging() {
    dragging = false;
  }

  void drag(int mx, int my) {
    if (dragging) {
      location.x = mx + dragOffset.x;
      location.y = my + dragOffset.y;
      velocity = new PVector(0, 0);
      frame = 0;
    }
  }
}