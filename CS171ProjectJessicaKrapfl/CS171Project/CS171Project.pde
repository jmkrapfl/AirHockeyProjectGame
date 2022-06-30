/*
Jessica Krapfl
CS171
Project
Air hockey
last edit: 15/12/20
*/
//******things for the timer********//
import javax.swing.JOptionPane;//to get user input for the time
//learned how to do the JOptionPane this from Lab 5 part b where the user was routinely
//asked to enter a float
import com.dhchoi.CountdownTimer;
import com.dhchoi.CountdownTimerService;
//came across this library when going throught processings site to find a library that
//would help me with time keeping i learned how to make a timer from the examples given

final long SECOND_IN_MILLIS = 1000;
final long HOUR_IN_MILLIS = 36000000;

CountdownTimer timer;
int timeToElapse;
String timeText = "";
int timeTextSeconds = 0, timeTextMinutes = 0; // the seconds and minutes to be displayed

//*********boolean array for key detection*********//
boolean[] moveHammer = new boolean[8];//the origional way i was moving the hammers only 
//allowed one button to be pressed. this was very hard to figure out how i could allow 
//more keys to be pressed and i came across another processing forum that was discussing
//key jamming and the idea of using a boolean array instead of what i was origionally using

//*****other gobal variables*******//
int screen = 0;
//if screen =0: start screen/
//if screen =1: options screen/
//if screen =2: game screen(first to 10)/
//if screen =3: game screen(winner after x min)
//if screen =4: end screen

boolean puckHit = false;

char space = ' ';
char option1 = '1';
char option2 = '2';
char option3 = '3';
char option4 = '4';

int p1_x = 312, p1_y = 375,p1DirectionX = 5, p1DirectionY = 5;//
int p2_x = 903,p2_y = 375, p2DirectionX = 5, p2DirectionY = 5;
int puckX = 625, puckY = 375, puckDirectionX = 5, puckDirectionY = 5;//starting pos of the puck and the direction it will be going
int p1Score = 0;
int p2Score = 0;

int radiusOfPuck = 37;
int radiusOfHam = 75;

void setup()
{
  size(1250,750);// create window
  
    timer = CountdownTimerService.getNewCountdownTimer(this).configure(SECOND_IN_MILLIS, HOUR_IN_MILLIS);
    updateTimeText();
}

//*************DRAW**********//
void draw()
{
  //i got the idea for doing the screens like this from a processing forum and i really wanted to implement
  //this idea into my own code because it keeps the draw function very tidey and if something is wrong with 
  //a certian screen i dont have to go through the whole draw function to figure out where the error is

    if(screen ==0)
    {
      startScreen();
      //reset scores
      p1Score =0;
      p2Score = 0;
      if(key == space)//once space is pressed screen is 1
      {
        screen = 1;
      }
    }
    else if(screen ==1)//option screen
    {
      optionScreen();
      if(key == option1)
      {
        screen = 2;
      }
      else if(key == option2)
      {
        String s = JOptionPane.showInputDialog("Enter a time (300 is 5 min):", JOptionPane.QUESTION_MESSAGE);
        try 
        {
          timeToElapse = parseInt(s);
        }   
        catch(NumberFormatException e) 
        {
           println("you did not enter a number!");
        }
           screen = 3;
        }
    }
    else if(screen ==2)//first to 10 game
    {
      gameScreen();
      puck();
      p1Hammer();
      p2Hammer();
      fill(0,0,0);
      //text(mouseY,595,25);
    }
    else if(screen ==3)//most points in x minutes
    {
      gameScreen();
      puck();
      p1Hammer();
      p2Hammer();
      fill(0,0,0);
      text(timeText, 595, 25);
      timer.start();
    }
    else if (screen == 4)//end game screen
    {
      endGame();
      if(key == option3)
      {
        screen = 0;
      }
      else if(key == option4)
      {
        exit();
      }
    }
  }

//****************SCREENS***************//
//*****screen 0******//
void startScreen()
{
  background(255,255,255);//make the background white
    
    textSize(64);//title text
    fill(233,87,72);
    text("Air Hockey",468,247);
    
    textSize(30);//p1 instructions
    fill(233,87,72);
    text("P1 use WASD keys",156,562);
    
    textSize(30);//P2 instructions
    fill(64,145,245);
    text("P2 use IJKL keys",781,562);
    
    textSize(30);
    fill(0,0,0);
    text("Press space to continue",464, 700);
}

//*******screen 1******//
void optionScreen()
{
    background(255,255,255);
    
    textSize(64);//title how do you want to play
    fill(233,87,72);
    text("How do you want to play?",242,187);
    
    textSize(30);//first to 10
    fill(0,0,0);
    text("Press   1   to play first to 10",418,297);
    
    textSize(30);//or
    fill(0,0,0);
    text("or",625,425);
    
    textSize(30);//most points in x amount of time
    fill(0,0,0);
    text("Press   2   to play most points in x minutes",313,597);
}

//*****screen 2*******//
void gameScreen()
{
  background(255,255,255);
    
  //************set up the arena**************//
  strokeWeight(5);//arena bounds
  fill(255,255,255);
  rect(25,30,1200,700);
    
  strokeWeight(5);//dividing line
  line(625,30,625,727);
    
  //*******************P1 Stuff***********//
  strokeWeight(1);//p1 goal box
  fill(233,87,72);
  rect(1220,213,1250,305);
  
  textSize(24);//P1 score text
  fill(233,87,72);
  text("P1 SCORE: "+p1Score,25,25);
  
  //********************p2 stuff***************//
  strokeWeight(1);//p2 goal box
  fill(64,145,245);
  rect(0,213,30,305);
  
  textSize(24);//p2 score text
  fill(64,145,245);
  text("P2 SCORE: "+p2Score,903,25);
  
  //************Score************//
  if (puckX >(width-65) && 248 < puckY && puckY < 480)//p1 scores
   {
     p1Score =p1Score +1;
     puckHit = false;//reset puck in the field
     
     //reset where the hammers are
     p1_x = 312;
     p1_y = 375;
     
     p2_x = 903;
     p2_y = 375;
     
     if(p1Score == 10 && screen ==2)//when playing first to 10 once 10 is reached go to the end screen
     {
       screen = 4;
     }
   }
  if(puckX < 55 && 248 < puckY && puckY < 480)//p2 scores
   {
     p2Score = p2Score + 1; 
     puckHit = false;//reset puck in the field
     
     //reset where the hammers are
     p1_x = 312;
     p1_y = 375;
     
     p2_x = 903;
     p2_y = 375;
     
     if(p2Score == 10 && screen == 2)//when playing first to 10 once 10 is reached go to the end screen
     {
       screen = 4;
     }
   }
}

//********Screen 4*********//
void endGame()
{
  background(255,255,255);
  //***winner text***
  if(p1Score > p2Score)//if p1 wwins
  {
    textSize(64);//title text
    fill(233,87,72);
    text("P1 Wins!",468,247);
  }
  else if(p2Score > p1Score)//if p2 wins
  {
    textSize(64);
    fill(64,145,245);
    text("P2 Wins!",500,247);
  }
  
  textSize(30);
  fill(0,0,0);
  text("Press 3 to play again",480,400);
  
  textSize(30);
  fill(0,0,0);
  text("or",625,500);
  
  textSize(30);
  fill(0,0,0);
  text("Press 4 to end",525,600);
}

//**************FUNCTIONS****************/
//************puck*********//
void puck()
{
  strokeWeight(1);//puck
  fill(0,0,0);
  ellipse(puckX,puckY,75,75);
  //ellipse(mouseX,mouseY,75,75);
  
  //***********Moving the puck**********//
  //boundries
  if(puckHit == true)
  {
    puckX = puckX + puckDirectionX;
    if(puckX<55)  puckDirectionX = -puckDirectionX;//reverse if hit boundry
    if(puckX>(width-65)) puckDirectionX = -puckDirectionX;//reverse if hit boundry
  
    puckY = puckY +puckDirectionY;
    if(puckY<60)  puckDirectionY = -puckDirectionY;//reverse if hit boundry
    if(puckY>(height -65))  puckDirectionY = -puckDirectionY;//reverse if hit boundry
  }
  else if(puckHit == false)
  {
    puckX = 625; 
    puckY = 375;
  }
  
  //*******bounceing off hammers****//
  //bounce off p1 hammer
  if(dist(puckX,puckY,p1_x,p1_y) <(radiusOfPuck + radiusOfHam))
  {
    puckHit = true;
    if(puckX < p1_x)
    {
      puckDirectionX = -abs(puckDirectionX);
    }
    if(puckX > p1_x)
    {
      puckDirectionX = abs(puckDirectionX);
    }
    if(puckY < p1_y)
    {
      puckDirectionY = -abs(puckDirectionY);
    }
    if(puckY < p1_y)
    {
      puckDirectionY = abs(puckDirectionY);
    }
  }
  //bounce off p2 hammer
  if(dist(puckX,puckY,p2_x,p2_y) <(radiusOfPuck + radiusOfHam))
  {
    puckHit = true;
    if(puckX < p2_x)
    {
      puckDirectionX = -abs(puckDirectionX);
    }
    if(puckX > p2_x)
    {
      puckDirectionX = abs(puckDirectionX);
    }
    if(puckY < p2_y)
    {
      puckDirectionY = -abs(puckDirectionY);
    }
    if(puckY < p2_y)
    {
      puckDirectionY = abs(puckDirectionY);
    }
  }
}
//********p1 hammer*******//
void p1Hammer()
{
  strokeWeight(1);//p1 hammer
  fill(233,87,72);
  ellipse(p1_x,p1_y,150,150);
  
  //*****************Moving p1 hammer***************//
   //*****direct direction******//
    if(moveHammer[0] == true && p1_y > 105)
    {
      p1_y= p1_y - p1DirectionY;
    }
    if(moveHammer[1] == true && p1_x > 100)
    {
      p1_x = p1_x - p1DirectionX;
    }
    if(moveHammer[2] == true && p1_y < 650)
    {
      p1_y = p1_y +p1DirectionY;
    }
    if(moveHammer[3] == true && p1_x < 550)
    {
      p1_x = p1_x + p1DirectionX;
    }
    
    /*the original way this was done:
    if(keyPressed == 'w' && p1_y > 105)
    {
      p1_y= p1_y - p1DirectionY;
    }
    if(keyPressed == 'a' && p1_x > 100)
    {
      p1_x = p1_x - p1DirectionX;
    }
    if(keyPressed == 's' && p1_y < 650)
    {
      p1_y = p1_y +p1DirectionY;
    }
    if(keyPressed == 'd' && p1_x < 550)
    {
      p1_x = p1_x + p1DirectionX;
    }
    */
}
//*********p2 Hammer*********//
void p2Hammer()
{
  strokeWeight(1);//p2 hammer
  fill(64,145,245);
  ellipse(p2_x,p2_y,150,150);
 
 //***************Moving p2 Hammer************//
  
    if(moveHammer[4] == true && p2_y>105)
    {
      p2_y= p2_y - p2DirectionY;
    }
    if(moveHammer[5] == true && p2_x > 700)
    {
      p2_x = p2_x - p2DirectionX;
    }
    if(moveHammer[6] == true && p2_y <650)
    {
      p2_y = p2_y +p2DirectionY;
    }
    if(moveHammer[7] == true && p2_x < 1150)
    {
      p2_x = p2_x + p2DirectionX;
    }
}

//***************Timer functions***********//
void updateTimeText() {
  timeTextSeconds = timeToElapse % 60;
  timeTextMinutes = timeToElapse / 60;
  timeText = nf(timeTextMinutes, 2) + ':' + nf(timeTextSeconds, 2);
}

void onTickEvent(CountdownTimer t, long timeLeftUntilFinish) 
{
  --timeToElapse;
  updateTimeText();
  
  if(timeToElapse ==0)
  {
    screen = 4;
  }
}

//************bool array swtich function to set the correct keys*********//

void setMovement(int k, boolean b) 
{
  switch (k) 
  {
    case 'w': moveHammer[0] = b;break;
    case 'a': moveHammer[1] = b;break;
    case 's': moveHammer[2] = b;break;
    case 'd': moveHammer[3] = b;break;
    case 'i': moveHammer[4] = b;break;
    case 'j': moveHammer[5] = b;break;
    case 'k': moveHammer[6] = b;break;
    case 'l': moveHammer[7] = b;break;
  }
}
//******if key pressed key = true when key released = false
void keyPressed() {
  setMovement(key, true);
}

void keyReleased() {
  setMovement(key, false);
}
