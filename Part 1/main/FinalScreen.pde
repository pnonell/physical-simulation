// La classe FinalScreen s'encarrega de la lògica i visualització de la pantalla final, que mostra els punts aconseguits durant la partida i el botó per tornar a jugar
class FinalScreen {
  int buttonX, buttonY;// Posició del botó
  int buttonSizeX;// L'amplada del botó "play again"
  int buttonSizeY;// L'alçada del botó "play again"
  boolean buttonOver;// Indica si el mouse està a sobre del botó
  boolean mousePressed;// Indica si el mouse està apretat
  
  // Constructor de la classe FinalScreen
  FinalScreen() {
    buttonSizeX = 222;// L'amplada del botó "play again"
    buttonSizeY = 51;// L'alçada del botó "play again"
    buttonOver = false;// Per defecte el mouse no està a sobre del botó
    mousePressed = false;// Per defecte el mouse no està apretat
    buttonX = width/2-buttonSizeX/2;// Botó centrat horitzontalment
    buttonY = height/2-buttonSizeY/2+25;// Botó centrat verticalment però desplaçat 25 píxels avall per mostrar els punts
  }
  
  // La funció update registra si el mouse està sobre el botó "play again"
  void update() {
    if (overButton(buttonX, buttonY, buttonSizeX, buttonSizeY)) {
      buttonOver = true;
    }
    else {
      buttonOver = false;
    }
  }
  
  // La funció display mostra la pantalla final, amb el botó per tornar a jugar i els punts aconseguits durant la partida
  void display(int points) {
    fill(0, 5);// Color semitransparent, fa l'efecte fosc
    rect(0, 0, width, height);// Pintem el rectangle que ocupa tota la pantalla, amb el color anterior
    
    if (mousePressed) {
      // Pintar botó en versió d'estar apretat ("active")
      image(buttonActive, buttonX, buttonY, buttonSizeX, buttonSizeY);
    }    
    else if (buttonOver) {
      // Pintar botó en versió d'estar per sobre ("hover")
      image(buttonHover, buttonX, buttonY, buttonSizeX, buttonSizeY);
    } 
    else {
      // Pintar botó en versió neutra (ni apretat ni per sobre)
      image(button, buttonX, buttonY, buttonSizeX, buttonSizeY);
    }
    
    // A continuació pintem el text dels punts
    fill(255);// Color del text
    textAlign(CENTER);// Text centrat
    if (points == 1) {
      // Text: 1 point
      text(points + " point", width/2, height/2-25); 
    }
    else {
      // Text: X points
      text(points + " points", width/2, height/2-25);
    }
    textAlign(LEFT);// Per crides futures, text a l'esquerra per defecte
  }
  
  // La funció mousePressed gestiona el fet de que l'usuari hagi apretat el mouse (ho guarda en el booleà mousePressed)
  void mousePressed() {
    if (buttonOver) {
      mousePressed = true;
    }
  }
  
  // La funció checkButtonClick comprova si cal interpretar un esdeveniment de mouseReleased com un click en el botó "play again"
  // Retorna true si cal interpretar un esdeveniment de mouseReleased com un click en el botó "play again", false si no
  boolean checkButtonClick() {
    if (mousePressed) {
      mousePressed = false;
      if (buttonOver) {
        return true;
      }
    }
    return false;
  }
  
  // La funció overButton comprova si les coordenades del mouse estan dins de les coordenades que ocupa el botó
  boolean overButton(int x, int y, int width, int height)  {
    if (mouseX >= x && mouseX <= x+width && 
        mouseY >= y && mouseY <= y+height) {
      return true;
    }
    else {
      return false;
    }
  }
}