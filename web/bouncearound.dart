import 'dart:html';

var ball = new ballObject(querySelector("#ball"));

void main() {
  window.animationFrame.then(animLoop);
}

class ballObject
{
  int left = 0;
  int top = 0;
  int size = 140;
  
  List<String> dir = ["right","down"];
  DivElement ballElement;
    
  ballObject(domElement){
    ballElement = domElement;
    ballElement.style
     ..width=size.toString()+'px'
     ..height=size.toString()+'px';
  }
  
  //////////Move the ball//////////////  
  void updateBall(){
    ballElement.style
      ..top  = '${top}px'
      ..left = '${left}px';
  }
  
  void moveHorizontal(amt){
    left += amt;
  }
  void moveVertical(amt){
    top += amt;
  }
  void setDir(){
    if(ball.getLeft() > (window.innerWidth-size))
      dir[0]="left";
    else if(ball.getLeft()<0)
      dir[0]="right";
    
    if(ball.getTop() > (window.innerHeight-size))
        dir[1]="up";
      else if(ball.getTop()<0)
        dir[1]="down";
  }
  void moveBall(){
    setDir();
    if(dir[0]=="right")
      moveHorizontal(5);
    else
      moveHorizontal(-5);
    
    if(dir[1]=="down")
      moveVertical(5);
    else
      moveVertical(-5);
    
    updateBall();
  }
  int getLeft(){
    return left;
  }
  int getTop(){
    return top;
  }
  
  
  
  /////////Change Color////////////
  
  
  
}


class ColorManagement
{
  
  ColorManagement(){
    
  }
  
  void genGradientList(){
    
  }
  
}


void animLoop(num delta){
  
  ball.moveBall();
  
  //print(ball.ballElement.style.left);
  window.animationFrame.then(animLoop);
}

