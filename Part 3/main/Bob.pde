class Bob { 
  PVector location;
  PVector velocity;
  PVector acceleration;
  float mass = 24;
  
  // damping per simular la fricció 
  float damping = 0.98;
  
  Ball ball;// punter a la pilota

  // Constructor
  Bob(float x, float y, Ball ball) {
    location = new PVector(x,y);
    velocity = new PVector();
    acceleration = new PVector();
    this.ball = ball;
  } 

  void update() { 
    velocity.add(acceleration);
    velocity.mult(damping);
    location.add(velocity);
    acceleration.mult(0);
  }

  // Llei de Newton: F = M * A
  void applyForce(PVector force) {
    PVector f = force.get();
    f.div(mass);
    acceleration.add(f);
  }

  // pintem el bob
  void display() { 
    stroke(0);
    strokeWeight(2);
    fill(175);
    ellipse(location.x, location.y - 2*ball.r, 10, 10);
  } 
}