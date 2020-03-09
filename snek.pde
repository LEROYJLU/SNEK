size(600, 600);
textAlign(CENTER, CENTER);
//vars
var body=[];
for(int i=0;i<100;i++){
  body=append(body, [300, 400-i]);
}
var dir=[0, -1];
var food=[];
for(int i=0;i<5;i++){
  food=append(food, [random(15, 585), random(15, 585), random(10, 20)]);
}
var spec=-1;
bool pressed=false;
bool end=false;
int score=0;
bool speed=false;
int speedCount=-1;
int deaths=0;
int velo=1;
bool pause=false;
bool keyP=true;
bool stop=false;
//functions
var rotate=function(x, y, a){
  if(x==0){
    x+=0.0001;
  }
  var t=atan(y/x);
  var r=sqrt(x*x+y*y);
  t+=a;
  if(x<=0){
    return [-r*cos(t), -r*sin(t)];
  }
  return [r*cos(t), r*sin(t)];
}
var add=function(i){
  for(int j=0;j<i;j++){
    body=concat([-100, -100], body);
    body[0]=body[1];
  }
}
var rem=function(i){
  if(food.length<=1){
    food=[];
  }else{
    food=concat(subset(food, 0, i), subset(food, i+1, food.length-(i+1)));
  }
  if(i==spec){
    spec=-1;
  }else if(i<spec){
    spec--;
  }
}
//loop
draw=function(){
  background(0, 150, 30);
  //score
  textSize(20);
  fill(0, 0, 0, 100);
  textSize(50);
  if(key=='*'||end){
    stop=true;
  }
  if(!end&&key!='*'){
    if(pause){
      text("Paused", 300, 300);
    }else{
      text("L: "+body.length+" | D: "+deaths+" | V: "+round(velo*100), 300, 300);
    }
  }
  //body
  fill(150, 255, 0, 10);
  if(speed){
    fill(255, 100, 150, 50);
    if(speedCount<=120){
      if(floor(speedCount/10)%2==0){
        fill(255, 50, 10, 100);
      }else{
        fill(200, 255, 50, 100);
      }
    }
  }
  noStroke();
  for(int i=0;i<body.length;i++){
    body[i][0]=round(body[i][0]*100)/100;
    body[i][1]=round(body[i][1]*100)/100;
    if(speed){
      if(body[i][0]<=0){
        body[i][0]+=600;
      }
      if(body[i][1]<=0){
        body[i][1]+=600;
      }
      if(body[i][0]>=600){
        body[i][0]-=600;
      }
      if(body[i][1]>=600){
        body[i][1]-=600;
      }
    }else if(i==body.length-1&&(body[i][0]<=10||body[i][0]>=590||body[i][1]<=10||body[i][1]>=590)){
      end=true;
    }
    if(i<30){ 
      ellipse(body[i][0], body[i][1], i/2+5, i/2+5);
    }else{
      ellipse(body[i][0], body[i][1], 20, 20);
    }
    if(i==body.length-1){
      fill(0);
      ellipse(body[i][0], body[i][1], 5, 5);
    }
    if(i<body.length-22){
      var tail=20;
      if(i<30){
        tail=i/2+6;
      }
      if(sqrt(pow(body[body.length-1][0]-body[i][0], 2)+pow(body[body.length-1][1]-body[i][1], 2))<tail&&!speed){
        end=true;
      }
    }
  }
  //move
  if(!pause){
    body=subset(append(body, [body[body.length-1][0]+dir[0]*velo, body[body.length-1][1]+dir[1]*velo]), 1);
    if(speed){
      body=subset(append(body, [body[body.length-1][0]+dir[0]*velo, body[body.length-1][1]+dir[1]*velo]), 1);
    }
  }
  //key input
  if(!keyPressed){
    key='';
    keyCode=null;
    keyP=true;
  }
  if(!pause){
    if(key=='z'||key=='Z'||keyCode==37){
      dir=rotate(dir[0], dir[1], -0.06);
    }
    if(key=='x'||key=='X'||keyCode==39){
      dir=rotate(dir[0], dir[1], 0.06);
    }
  }
  if((key=='p'||key=='P')&&keyP){
    keyP=false;
    if(pause){
      pause=false;
    }else{
      pause=true;
    }
    
  }
  //grow
  
  
  //gen
  if(random(0, 80)<1&&!pause){
    food=append(food, [random(15, 585), random(15, 585), random(10, 20)]);
    if(random(0, 10)<1&&spec==-1&&food.length>0){
      spec=food.length-1;
    }
  }
  //food
  
  noStroke();
  for(int i=0;i<food.length;i++){
    if(random(0, 60)<1&&!pause){
      food[i][2]--;
      if(food[i][2]<=0){
        rem(i);
      }
    }
    if(i==spec){
      fill(255, 0, 200);
    }else{
      fill(255, 150, 0);
    }
    ellipse(food[i][0], food[i][1], food[i][2], food[i][2]);
    
    if(sqrt(pow(body[body.length-1][0]-food[i][0], 2)+pow(body[body.length-1][1]-food[i][1], 2))<10+food[i][2]/2){
      if(i==spec){
        score+=round(food[i][2]);
        if(!speed){
          speed=true;
        }else{
          speedCount+=500;
        }
        
      }
      add(round(food[i][2]/3));
      score+=round(food[i][2]);
      rem(i);
    }
    
  }
  //speed
  if(speed&&!pause){
    if(speedCount==-1){
      speedCount=500;
    }
    speedCount--;
    if(speedCount==0){
      speed=false;
    }
  }
  if(!pause){
    velo+=0.0001;
  }
  //stop
  if(stop){
    speed=true;
    speedCount=120;
    end=false;
    stop=false;
    deaths++;
    if(body.length>101){
      body=subset(body, floor(body.length/2),   body.length-1);
    }else{
      textSize(150);
      fill(0);
      text("Game Over ", 70, -80, 500, 500);
      textSize(70);
      text("Score: "+score, 300, 430);
      text("Deaths: "+deaths, 300, 530);
      end();
    }
  }
  //debug
  fill(0);
  textSize(30);
  //text(velo, 200, 200);
  
}
