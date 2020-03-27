class Controller {
  int option;
  Ball ball;
  
  // Constructor del controlador
  Controller(int option) {
    this.option = option;
    ball = new Ball(option);
    frameRate(20);//baixem els frames per observar millor el moviment
  }
  
  // Funció que pinta el fons
  void displayBackground() {
    background(255);
    image(background, 0, 0, width, height);
    // Text
    textSize(16);
    fill(255);
    switch (option) {
      case 1:
        text("Exercici 1", 400, 170); 
        text("Xoc amb objectes rígids", 400, 190); 
        break;
      case 2:
        text("Exercici 2", 400, 170); 
        text("Xoc amb objectes que es deformen elàsticament", 400, 190); 
        text("Simulació analítica", 400, 210); 
        break;
      case 3:
        text("Exercici 3", 400, 170); 
        text("Xoc amb objectes que es deformen elàsticament", 400, 190); 
        text("Simulació numèrica", 400, 210);
         break;
    }
  }

  void update(){
    PVector gravity = new PVector(0, 0.1);
    if (!ball.dragging && !ball.ground) {
      ball.applyForce(gravity);
    }    
    ball.update();
    ball.checkEdges();
  }
  
  void display(){
    ball.display();
  }
}