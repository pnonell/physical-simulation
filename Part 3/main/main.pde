Controller controller;// S’encarrega de la lògica i la visualització de la simulació

// A continuació es troben les variables dedicades a les imatges (es carreguen a la funció setup)
PImage ball;
PImage background;

// Funció que inicialitza el controlador i les imatges i defineix la mida de la finestra
void setup() {
  // --------------------------------------
  // CANVIA LA OPCIÓ AQUÍ (1, 2 o 3)
  // --------------------------------------
  controller = new Controller(1);
  
  // Carreguem les imatges
  ball = loadImage("ball.png");
  background = loadImage("background.png");
  
  // Mida de la finestra
  size(1100, 600);
}

// Demana al controlador que actualitzi i pinti la simulació
void draw() {
  controller.displayBackground();
  controller.update();
  controller.display();
}

// Interacció del ratolí amb la pilota

void mousePressed()  {
  controller.ball.clicked(mouseX,mouseY);
}

void mouseReleased()  {
  controller.ball.stopDragging(); 
}