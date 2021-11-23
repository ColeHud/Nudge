import java.util.Arrays;
import java.util.Collections;
import java.util.Random;

String[] phrases; //contains all of the phrases
int totalTrialNum = 2; //the total number of phrases to be tested - set this low for testing. Might be ~10 for the real bakeoff!
int currTrialNum = 0; // the current trial number (indexes into trials array above)
float startTime = 0; // time starts when the first letter is entered
float finishTime = 0; // records the time of when the final trial ends
float lastTime = 0; //the timestamp of when the last trial was completed
float lettersEnteredTotal = 0; //a running total of the number of letters the user has entered (need this for final WPM computation)
float lettersExpectedTotal = 0; //a running total of the number of letters expected (correct phrases)
float errorsTotal = 0; //a running total of the number of errors (when hitting next)
String currentPhrase = ""; //the current target phrase
String currentTyped = ""; //what the user has typed so far
final int DPIofYourDeviceScreen = 538; //you will need to look up the DPI or PPI of your device to make sure you get the right scale. Or play around with this value.
final float sizeOfInputArea = DPIofYourDeviceScreen*1; //aka, 1.0 inches square!

PImage marker;

//Variables for my silly implementation. You can delete this:
char currentLetter = 'a';

//You can modify anything in here. This is just a basic implementation.
void setup()
{
  //noCursor();
  //finger = loadImage("pngeggSmaller.png"); //not using this
  //Collections.shuffle(Arrays.asList(phrases), new Random(100)); //randomize the order of the phrases with seed 100; same order every time, useful for testing
 
  orientation(LANDSCAPE); //can also be PORTRAIT - sets orientation on android device
  size(2880, 1440); //Sets the size of the app. You should modify this to your device's native size. Many phones today are 1080 wide by 1920 tall.
  textFont(createFont("Arial", 50)); //set the font to arial 24. Creating fonts is expensive, so make difference sizes once in setup, not draw
  noStroke(); //my code doesn't use any strokes
  
  marker = loadImage("tracking.png");
}


//You can modify anything in here. This is just a basic implementation.
void draw()
{
  background(255); //clear background
  
   //check to see if the user finished. You can't change the score computation.
  
    fill(0);
    textAlign(CENTER);
    text("Currently Touching: " + currentlyTouch,400,200);
    text("Mouse Start X: " + startTouchX,400,400);
    text("Mouse Start Y: " + startTouchY,400,600);
    
    text("Mouse End X: " + endTouchX,400,800);
    text("Mouse End Y: " + endTouchY,400,1000);
    
      pushMatrix();
      float watchscale = DPIofYourDeviceScreen/430.0; //normalizes the image size
      translate(width/2, height/2 + sizeOfInputArea*.1);
      scale(watchscale);
      imageMode(CENTER);
      image(marker, 0, 0);
      popMatrix();
    
    return;
}


//my terrible implementation you can entirely replace
boolean didMouseClick(float x, float y, float w, float h) //simple function to do hit testing
{
  return (mouseX > x && mouseX<x+w && mouseY>y && mouseY<y+h); //check to see if it is in button bounds
}


boolean currentlyTouch = false;
float startTouchX = 0;
float startTouchY = 0;
float endTouchX = 0;
float endTouchY = 0;
void mousePressed()
{
  startTouchX = mouseX;
  startTouchY = mouseY;
  currentlyTouch = true;
}

//on mouse release, check for swipes
void mouseReleased(){
  currentlyTouch = false;
  endTouchX = mouseX;
  endTouchY = mouseY;
}


//probably shouldn't touch this - should be same for all teams.
void drawFinger()
{
  float fingerscale = DPIofYourDeviceScreen/150f; //normalizes the image size
  pushMatrix();
  translate(mouseX, mouseY);
  scale(fingerscale);
  imageMode(CENTER);
  if (mousePressed)
     fill(0);
  else
     fill(255);
  ellipse(0,0,5,5);

  popMatrix();
  }
  

//=========SHOULD NOT NEED TO TOUCH THIS METHOD AT ALL!==============
int computeLevenshteinDistance(String phrase1, String phrase2) //this computers error between two strings
{
  int[][] distance = new int[phrase1.length() + 1][phrase2.length() + 1];

  for (int i = 0; i <= phrase1.length(); i++)
    distance[i][0] = i;
  for (int j = 1; j <= phrase2.length(); j++)
    distance[0][j] = j;

  for (int i = 1; i <= phrase1.length(); i++)
    for (int j = 1; j <= phrase2.length(); j++)
      distance[i][j] = min(min(distance[i - 1][j] + 1, distance[i][j - 1] + 1), distance[i - 1][j - 1] + ((phrase1.charAt(i - 1) == phrase2.charAt(j - 1)) ? 0 : 1));

  return distance[phrase1.length()][phrase2.length()];
}
