// La classe Game s'encarrega de la lògica i visualització del joc
class Game {
   Timer timer;// El comptador del temps restant
   int points;// Els punts aconseguits durant la partida
   LinkedList<Snake> snake;// El conjunt de boles que formen la serp
   Worm worm;// El cuc (actiu en cada moment)
   FinalScreen finalScreen;// L'estat de la pantalla final (mostra els punts aconseguits durant la partida i el botó per tornar a jugar)
   
   // Constructor de la classe Game
   Game() {
     timer = new Timer();// El comptador del temps restant
     points = 0;// Els punts aconseguits durant la partida. Són 0 al iniciar
     snake = new LinkedList<Snake>();// El conjunt de boles que formen la serp
     snake.add(new Snake(null));// Afegeix el cap de la serp. Li passem null com a location per a que la posi al centre de la pantalla
     worm = new Worm();// El cuc
     finalScreen = new FinalScreen();// La pantalla final (mostra els punts aconseguits durant la partida i el botó per tornar a jugar)
   }
   
   // La funció update actualitza les posicions dels elements del joc (les boles de la serp i el cuc) i també actualitza el comptador del temps restant
   void update() {
     
     // En primer lloc actualitzem les posicions de les boles de la serp
      for (int i = 0; i < snake.size(); i++) {
        if (i == 0) {
          // És el cap de la serp, per tant fem que segueixi a la posició del mouse
          PVector target = new PVector(mouseX, mouseY);
          snake.get(i).update(target);
        } 
        else {
          // És una bola del cos de la serp, per tant fem que segueixi a la bola que té davant
          PVector target = snake.get(i-1).location;
          snake.get(i).update(target);      
        }
      }
      
      // A continuació actualizem la posició del cuc
      worm.update();
      worm.checkEdges();
      
      // Comprovem si el cap de la serp està tocant el cuc
      float distance = PVector.sub(worm.location, snake.getFirst().location).mag();
      if (distance < 28) {// 28 és el radi del cuc (20) + el radi del cap de la serp (8)
        eatWorm();
      }
      
      // Finalment actualitzem el contador del temps
      timer.update();
    }
   
   // La funció display pinta els elements del joc
   void display() {
    
    // Mostrem el text amb puntuacions i temps
    textSize(32);
    if (points == 1) {
      // Text: 1 point
      text(points + " point", 15, 40); 
    }
    else {
      // Text: X points
      text(points + " points", 15, 40); 
    }
    fill(0, 102, 153);
    text("Time: " + timer.time + " s", 15, 75);// Text: Time: X s
    fill(0, 102, 153, 51);
    stroke(0);
    fill(175);
    
    // A continuació pintem les boles de la serp
    // Iterem per la llista serp i en pintem cada bola
    for (int i = 0; i < snake.size(); i++) {
      snake.get(i).display();
    }
    
    // Pintem el cuc
    worm.display();
   }
   
   // La funció eatworm es crida quan el cap de la serp arriba a un cuc
   void eatWorm() {
     // Augmentem la puntuació
     points++;
     // A continuació afegim una nova bola a la serp
     // Fem que la nova bola s'afegeixi a continuació de la última
     // El vector snake.getLast().velocity.normalize(null).mult(-16) que es suma és degut a que ens interessa que la nova bola afegida quedi 
     // situada en la cua de la serp i això ho podem fer utilitzant la direcció del vector oposat de la velocitat de l'última bola i multiplicar 
     // el vector unitari per 16 perquè és 2R, on R és el radi de les boles de la serp, que és 8
     PVector last = PVector.add(snake.getLast().location, snake.getLast().velocity.normalize(null).mult(-16)); 
     snake.add(new Snake(last));
     // Finalment creem un nou cuc
     worm = new Worm();
   }
}