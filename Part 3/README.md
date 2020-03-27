# Part 3: Bouncing ball

To run the simulation, open the file main.pde and run it on Processing.

The simulation represents the movement of a ball falling and bouncing on the ground in different situations. The user can grab the ball clicking it with the mouse and let it go anywhere.
There are 3 different options, which can be switched by changing the number on line 12 of the code.

- Option 1:

    The ball is rigid so there is no loss of energy when bouncing and the ball returns to the same place of falling.
    
- Option 2:

    The ball is not rigid and it is deformed by lost mechanical energy. Here is used an analitic simulation to represent the deformation of the ball and the loss of energy.
    
- Option 3:

    The ball is not rigid again. Here is used a numeric simulation using the Hooke's law where the ball deformity acts like a spring.
