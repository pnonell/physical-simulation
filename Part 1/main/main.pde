import java.util.*;// Per a fer servir la classe LinkedList implementada per Java

// Variables globals
Game game;// L'estat del joc
// A continuació es troben les variables dedicades a les imatges (es carreguen a la funció setup)
PImage background;
PImage snakeHead;
PImage snakeBody;
PImage worm1;
PImage worm2;
PImage worm3;
PImage button;
PImage buttonHover;
PImage buttonActive;

// En la funció setup definim la mida de la pantalla, carreguem les imatges que utilitzarem i inicialitzem l'estat del joc
// Com que aquesta funció només s'executa un cop, les imatges només es carreguen un cop (a l'iniciar el programa)
void setup() {
  surface.setTitle("Snake game");
  size(640, 360);// Definim la mida de la pantalla
  background = loadImage("background.jpg");
  snakeHead = loadImage("snake_head.png");
  snakeBody = loadImage("snake_body.png");
  worm1 = loadImage("worm_green.png");
  worm2 = loadImage("worm_orange.png");
  worm3 = loadImage("worm_yellow.png");
  button = loadImage("button.png");
  buttonHover = loadImage("button_hover.png");
  buttonActive = loadImage("button_active.png");
  game = new Game();// Inicialitzem l'estat del joc
}

// La funció draw s'executa per cada frame
// Si el comptador de temps està actiu (encara no ha arribat a 0), pintem el fons, actualitzem l'estat del joc i demanem al joc que es pinti
// Si el comptador de temps ja NO està actiu (ha arribat a 0), llavors simplement mostra la pantalla final (la que mostra els punts i té el botó de "play again")
void draw() {
  if (game.timer.time != 0) {
    // El contador de temps està actiu (encara no ha arribat a 0)
    image(background, 0, 0, width, height);// Pintem el fons
    game.update();// Actualitzem l'estat del joc
    game.display();// demanem al joc que es pinti
  }
  else {
    // El comptador de temps ja NO està actiu (ha arribat a 0)
    game.finalScreen.update();// Actualitza l'estat de la pantalla final (aquesta crida fa possible l'animació del botó "play again")
    game.finalScreen.display(game.points);// Mostra la pantalla final (la que mostra els punts i té el botó de "play again")
  }
}

// La funció mousePressed és cridada quan l'usuari apreta el mouse
void mousePressed() {
  game.finalScreen.mousePressed();// Demanem a la pantalla final que gestioni el fet de que l'usuari ha apretat el mouse
}

// La funció mouseReleased és cridada quan l'usuari deixa d'apretar el mouse (és quan s'ha de donar una resposta al click)
void mouseReleased() {
  // Preguntem a la pantalla final si cal interpretar aquest mouseReleased com un click en el botó "play again"
  if (game.finalScreen.checkButtonClick()) {
    // Cal interpretar aquest mouseReleased com un click en el botó "play again", per tant cal reiniciar l'estat del joc
    game = new Game();
  }
}