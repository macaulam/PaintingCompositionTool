/* autogenerated by Processing revision 1290 on 2023-01-26 */
import processing.core.*;
import processing.data.*;
import processing.event.*;
import processing.opengl.*;

import java.util.HashMap;
import java.util.ArrayList;
import java.io.File;
import java.io.BufferedReader;
import java.io.PrintWriter;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.IOException;

public class sketch_230126a extends PApplet {

// By Matthew Macaulay thanks to Roni Kaufman for the initial code that this was based on.

int thickness = 0; // thickness of the lines between the cubes

int[][] colors = {{215, 85, 56}, {240, 0, 0}, {0, 0, 92}, {36, 15, 88}, {220, 60, 100}}; // colors used, including black and white
int nbColors = colors.length; // number of colors
float[] probColors = new float[5]; // probabilities of applying each color to a rectangle, the sum of its elements must be equal to 1.0
float[] startingProbColors = {0.01f, 0.81f, 0.06f, 0.06f, 0.06f}; // starting probabilities
float[] probReducingColors = {0.8f, 0.1f, 0.5f, 0.5f, 0.5f}; // gives how the probabilities for each color evolve every time we use them (the closest to 1, the more we'll reduce)

float probFactor = 0.5f; // factor to multiply the probability of division with when we call the function mondrianRecursion recursively


public void setup() {
  /* size commented out by preprocessor */;
  arrayCopy(startingProbColors, probColors);
  noLoop();
}


public void draw() {
  background(0);
  mondrianRecursion(width-thickness, height-thickness, thickness/1, thickness/2, 1.0f, (random(2)<1));
} 


public void keyPressed() {
  if (key == ' ') { // generate new image
    arrayCopy(probColors, startingProbColors);
    redraw();
  } else if (key == 's') { // save image
    String timestamp = getTimestamp();
    save("mondrian_" + timestamp + ".jpg");
  }
}


/* Draws a generated Mondrian-style picture recursively
   w the width, h the height, (x,y) the top-left corner
   prob the probability to divide this rectangle into 2 new rectangles
   vertical = true if we must divide vertically, false if horizontally */

public void mondrianRecursion(int w, int h, int x, int y, float prob, boolean vertical) {
  if (random(1) < prob) { // we must divide again
    if (vertical) {
      int wDivision = (int)(random(w*0.3f, w*0.7f));
      mondrianRecursion(wDivision, h, x, y, prob*probFactor, false);
      mondrianRecursion(w-wDivision, h, x+wDivision, y, prob*probFactor, false);
    } else {
      int hDivision = (int)(random(h*0.3f, h*0.7f));
      mondrianRecursion(w, hDivision, x, y, prob*probFactor, true);
      mondrianRecursion(w, h-hDivision, x, y+hDivision, prob*probFactor, true);
    }
  } else { // we must draw a rectangle in the zone
    int idx = chooseColor();
    newProbColors(idx);
    fill(colors[idx][0], colors[idx][1], colors[idx][2]);
    rect(x+thickness/2, y+thickness/2, w-thickness, h-thickness);
  }
}


/* Choose a color randomly using the probability distribution of probColors */

public int chooseColor() {
  float r = random(1), sum = 0;
  int i = 0;
  while (sum <= r) {
    sum += probColors[i++];
  }  
  return i-1;
}


/* Changes probColors during the execution in order not to have too much of a certain color
   Reduces the probability of the last used color and redistributes it uniformly to all the others */

public void newProbColors(int i) {
  float x = probColors[i] * probReducingColors[i];
  for (int k = 0; k < nbColors; k++) {
    if (i == k) {
      probColors[k]=probColors[k] - x; // decrease this probability
    } else {
      probColors[k]=probColors[k] + x/(nbColors-1); // increase all the other ones
    }
  }
}


/* Returns a timestamp of the form [year][month][day][hour][minute][second] 
   its length is always 14 */

public String getTimestamp() {
  String yea = String.valueOf(year());
  String mon = String.valueOf(month());
  if (mon.length() == 1) {
    mon = "0" + mon;
  }
  String day = String.valueOf(day());
  if (day.length() == 1) {
    day = "0" + day;
  }
  String hou = String.valueOf(hour());
  if (hou.length() == 1) {
    hou = "0" + hou;
  }
  String min = String.valueOf(minute());
  if (min.length() == 1) {
    min = "0" + min;
  }
  String sec = String.valueOf(second());
  if (sec.length() == 1) {
    sec = "0" + sec;
  }
  
  String s = yea + mon + day + hou + min + sec;
  return s;
}


  public void settings() { size(1200, 800); }

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "sketch_230126a" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}