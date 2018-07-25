application.[your OS] is the pre-compiled version that requires no version of Processing
to be installed, only Java 8+

3D enviroment made using Processing 3.0+

uses trigonometry to change velocity in X and Y directions depending on the angle, effectively creating 
the effect that the player is moving in the direction it is looking:

velocity X = speed*sin([angle in radians])
velocity Y = speed*cos([angle in radians])

the player rotation and camera rotation are separate, creating a 3rd person point of view
