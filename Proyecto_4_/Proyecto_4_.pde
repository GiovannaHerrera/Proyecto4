import gab.opencv.*;
import processing.video.*;
import java.awt.Rectangle;

Pantalla ppal;
Capture cam;
OpenCV opencv;
ArrayList<Contour> contours;

color green = color(137,172,118);
color blue = color(63,36,143);
int numPixels;

PImage src;
int maxColors = 4;
int[] hues;
int[] colors;
int rangeWidth = 10;


PImage[] outputs;

int colorToChange = -1;

void setup() {
  size(1280, 720, P2D);

  String[] cameras = Capture.list();

  if (cameras == null) {
    cam = new Capture(this, 640, 480);
  } 
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available");
    printArray(cameras);

    cam = new Capture(this, cameras[0]);

    //pantallas
    ppal= new Pantalla();


    //cv
    cam = new Capture(this, 1280, 720);
    opencv = new OpenCV(this, cam.width, cam.height);
    contours = new ArrayList<Contour>();

    colors = new int[maxColors];
    hues = new int[maxColors];

    outputs = new PImage[maxColors];
    
    strokeWeight(5);
    numPixels = cam.width * cam.height;
    noCursor();
    smooth();

    cam.start();
      
  }
}

void draw() {
  background(0);
  ppal.display();
}
