Controller controller;// S’encarrega de la lògica i la visualització de la simulació

// A continuació es troben les variables dedicades a les imatges (es carreguen a la funció setup)
PImage planet;
PImage satellite;
PImage explosion;

int[][] colors;// Diferents colors per a mostrar les àrees

// Funció que inicialitza el controlador, les imatges, els colors i defineix la mida de la finestra
void setup() {
  // --------------------------------------
  // CANVIA LA OPCIÓ AQUÍ
  // --------------------------------------
  controller = new Controller('A');

  // Carreguem les imatges
  planet = loadImage("planet.png");
  satellite = loadImage("satellite.png");
  explosion = loadImage("explosion.png");
  
  // Diferents colors per a mostrar les àrees
  colors = new int[10][];
  colors[0] = new int[3];
  colors[1] = new int[3];
  colors[2] = new int[3];
  colors[3] = new int[3];
  colors[4] = new int[3];
  colors[5] = new int[3];
  colors[6] = new int[3];
  colors[7] = new int[3];
  colors[8] = new int[3];
  colors[9] = new int[3];
  colors[0][0] = 204;
  colors[0][1] = 0;
  colors[0][2] = 0;
  colors[1][0] = 0;
  colors[1][1] = 102;
  colors[1][2] = 0;
  colors[2][0] = 102;
  colors[2][1] = 0;
  colors[2][2] = 204;
  colors[3][0] = 0;
  colors[3][1] = 0;
  colors[3][2] = 204;
  colors[4][0] = 153;
  colors[4][1] = 102;
  colors[4][2] = 51;
  colors[5][0] = 0;
  colors[5][1] = 51;
  colors[5][2] = 102;
  colors[6][0] = 128;
  colors[6][1] = 0;
  colors[6][2] = 0;
  colors[7][0] = 204;
  colors[7][1] = 51;
  colors[7][2] = 0;
  colors[8][0] = 51;
  colors[8][1] = 102;
  colors[8][2] = 153;
  colors[9][0] = 102;
  colors[9][1] = 0;
  colors[9][2] = 51;

  size(640,360);
}

// Demana al controlador que actualitzi i pinti la simulació
void draw() {
  controller.update();
  controller.display();
}

// Funció que es crida quan l'usuari prem alguna tecla
void keyPressed() {
  if (keyCode == ENTER) {
    controller.saveArea();
  }
}
