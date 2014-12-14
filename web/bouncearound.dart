import 'dart:html';

var ball = new ballObject(querySelector("#ball"));
var colorManagement = new ColorManagement();

void main() {
  window.animationFrame.then(animLoop);
}

class ballObject
{
  int left = 0;
  int top = 0;
  int size = 140;
  
  static int colorIdx = 0;
  static List<List> colorGradient = colorManagement.genGradientList();
  List<int> color = colorGradient[colorIdx];
  
  List<String> dir = ["right","down"];
  DivElement ballElement;
    
  ballObject(domElement){
    ballElement = domElement;
    ballElement.style
      ..width=size.toString()+'px'
      ..height=size.toString()+'px'
      ..background='radial-gradient(circle at 100px 100px, rgb('+
                  color[0].toString()+
                  ','+color[1].toString()+
                  ','+color[2].toString()+
                  '), #000)';
    
  }
  
  //////////Move the ball//////////////  
  void updateBall(){
    nextColor();
    ballElement.style
      ..top  = '${top}px'
      ..left = '${left}px'
      ..background='radial-gradient(circle at 100px 100px, rgb('+
                  color[0].toString()+
                  ','+color[1].toString()+
                  ','+color[2].toString()+
                  '), #000)';
  }
  void nextColor(){
     colorIdx = (colorIdx+1)%colorGradient.length;
     color = colorGradient[colorIdx];
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
  
  List<List> genGradientList(){
    // create gradient of int colors from red to magenta and loop back
    // start at FF0000 or 25,0,0
    // End at FF00FF or 255,0,255
    List<List> intColors= new List();
    // first segment 255,0,0->255,255,0
    for(int i=0;i<256;i++){
      List<int> nextColor = new List(3);
      nextColor[0] = 255;
      nextColor[1] = i;
      nextColor[2] = 0;
      intColors.add(nextColor);
    }
    // second segment 255,255,0->0,255,0
    for(int i=0;i<256;i++){
      List<int> nextColor = new List(3);
      nextColor[0] = 255-i;
      nextColor[1] = 255;
      nextColor[2] = 0;
      intColors.add(nextColor);
    }
    // third segment 0,255,0->0,255,255
    for(int i=0;i<256;i++){
      List<int> nextColor = new List(3);
      nextColor[0] = 0;
      nextColor[1] = 255;
      nextColor[2] = i;
      intColors.add(nextColor);
    }
    // fourth segment 0,255,255->0,0,255
    for(int i=0;i<256;i++){
      List<int> nextColor = new List(3);
      nextColor[0] = 0;
      nextColor[1] = 255-i;
      nextColor[2] = 255;
      intColors.add(nextColor);
    }
    // fourth segment 0,0,255->255,0,255
    for(int i=0;i<256;i++){
      List<int> nextColor = new List(3);
      nextColor[0] = i;
      nextColor[1] = 0;
      nextColor[2] = 255;
      intColors.add(nextColor);
    }
    // now return to start
    // fifth segment 255,0,255->255,0,0
    for(int i=0;i<256-1;i++){
      List<int> nextColor = new List(3);
      nextColor[0] = 255;
      nextColor[1] = 0;
      nextColor[2] = 255-i;
      intColors.add(nextColor);
    }
    return intColors;
  }
  
}


void animLoop(num delta){
  
  ball.moveBall();
  
  //print(ball.ballElement.style.left);
  window.animationFrame.then(animLoop);
}

