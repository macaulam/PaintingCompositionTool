// PCT By Matthew Macaulay

int thickness = 0; 

int[][] colors = {{60, 20, 100}, {84, 250, 167}, {197, 241, 8}, {24, 244, 204}, {0, 50, 0}, {255, 0, 0}, {255, 255, 0}, {0, 0, 255}, {255, 0, 255}, {100, 100, 100}, {255, 150, 0}, {150, 0, 255}, {255, 255, 255}, {0, 0, 0}, {200, 200, 200}, {255, 100, 0}, {100, 0, 255}, {150, 150, 150}, {255, 200, 0}, {200, 0, 255}, {255, 0, 0}, {255, 0, 255}, {0, 0, 255}, {0,255,255}, {255, 255, 0}, {0, 255, 0}, {255, 0, 255}, {255,255,255}, {0, 0, 0}, {200, 200, 200}, {255, 100, 0}, {100, 0, 255}, {150, 150, 150}, {255, 200, 0}, {200, 0, 255}};
int nbColors = colors.length; 
float[] probColors = new float[40]; 
float[] startingProbColors = {0.06, 0.06, 0.06, 0.06, 0.06, 0.06, 0.6, 0.06, 0.06, 0.06, 0.06, 0.6, 0.06, 0.06, 0.06, 0.06, 0.6, 0.06, 0.06, 0.06, 0.06, 0.6, 0.06, 0.06, 0.6, 0.06, 0.06, 0.6, 0.06, 0.06, 0.6, 0.06, 0.06, 0.6, 0.06, 0.06, 0.6, 0.06, 0.06, 0.06};
float[] probReducingColors = {0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1};

float probFactor = 0.5;

void setup() {
  size(1200, 800);
  arrayCopy(startingProbColors, probColors);
  noLoop();
}


void draw() {
  background(0);
  recursion(width-thickness, height-thickness, thickness/1, thickness/2, 1.0, (random(2)<1));
} 


void keyPressed() {
  if (key == ' ') { // generate new image
    arrayCopy(probColors, startingProbColors);
    redraw();
  } else if (key == 's') { // save image
    String timestamp = getTimestamp();
    save("mondrian_" + timestamp + ".jpg");
  }
}


/* Draws a generated grid recursively
   w the width, h the height, (x,y) the top-left corner
   prob the probability to divide this rectangle into 2 new rectangles
   vertical = true if we must divide vertically, false if horizontally */

void recursion(int w, int h, int x, int y, float prob, boolean vertical) {
  if (random(1) < prob) { // we must divide again
    if (vertical) {
      int wDivision = (int)(random(w*0.3, w*0.7));
      recursion(wDivision, h, x, y, prob*probFactor, false);
      recursion(w-wDivision, h, x+wDivision, y, prob*probFactor, false);
    } else {
      int hDivision = (int)(random(h*0.3, h*0.7));
      recursion(w, hDivision, x, y, prob*probFactor, true);
      recursion(w, h-hDivision, x, y+hDivision, prob*probFactor, true);
    }
  } else { // we must draw a rectangle in the zone
    int idx = chooseColor();
    newProbColors(idx);
    fill(colors[idx][0], colors[idx][1], colors[idx][2]);
    rect(x+thickness/2, y+thickness/2, w-thickness, h-thickness);
  }
}


/* Choose a color randomly using the probability distribution of probColors */

int chooseColor() {
  float r = random(1), sum = 0;
  int i = 0;
  while (sum <= r) {
    sum += probColors[i++];
  }  
  return i-1;
}


/* Changes probColors during the execution in order not to have too much of a certain color
   Reduces the probability of the last used color and redistributes it uniformly to all the others */

void newProbColors(int i) {
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

String getTimestamp() {
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
