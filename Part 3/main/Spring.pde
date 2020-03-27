class Spring {
  PVector anchor;

  float len;
  float k = 0.1;
  float d;
  
  Ball ball;// Punter a la pilota
 
  Spring(float x, float y, int l, Ball ball) {
    anchor = new PVector(x,y);
    len = l;
    this.ball = ball;
  }

  // Llei de Hooke
  void connect(Bob b) {

    PVector force = PVector.sub(b.location,anchor);
    this.d = -force.y;
    float d = force.mag();
    float stretch = d - len;

    force.normalize(); 
    force.mult(-1 * k * stretch); 
    
    b.applyForce(force);
    
    // guardem la d per fer les comprovacions
    if(ball.option == 3){
      if (!ball.raisedMin && d != ball.dMin[2]) {
        ball.dMin[0] = ball.dMin[1];
        ball.dMin[1] = ball.dMin[2];
        ball.dMin[2] = this.d;
      }
      if (!ball.raisedZero && d != ball.dZero[1]) {
        ball.dZero[0] = ball.dZero[1];
        ball.dZero[1] = this.d;
      }
    }
    
    
    // comprovem el mínim relatiu
    if (ball.ground & ball.dMin[0] > ball.dMin[1] && ball.dMin[1] < ball.dMin[2] && ball.dMin[0] != -99999 && ball.dMin[1] != -99999 && ball.dMin[2] != -99999) {
      // mínim relatiu trobat: dMin[1]
      ball.raisedMin = true;
    }
    
    // Check zero
    if (ball.ground & ball.dZero[0] * ball.dZero[1] < 0 && ball.dZero[0] != -99999 && ball.dZero[1] != -99999 && ball.raisedMin) {
      // pas per 0 trobat
      ball.raisedZero = true;
    }
  }

  void display() {
    fill(100);
    rectMode(CENTER);
    rect(anchor.x, anchor.y, 10,10);
  }

  //pintem la linia entre el anchor i el bob
  void displayLine(Bob b) {
    stroke(255);
    line(b.location.x, b.location.y - 2*ball.r, anchor.x, anchor.y);
  }
}