class Pantalla {
  int n;
  PImage imagen;
  PImage im;
  int p=10;
  int cellSize = 15;
  int col, fila;


  Pantalla() {
    imagen=loadImage("filter.png");
    im=loadImage("final.png");

    if (cam.available() == true) {
      cam.read();
      image(cam, 0, 0, width, height);
    }
  }

  void inicio() {
   
    background(0);
    image(imagen, 200, 0);
    fill(127,181,181);
    textSize(70);
    text("FILTER ME!", 100, 300);
    textSize(28);
    text("Pulsa Up para comenzar, z para tomar un screenshot o Esc para salir", 100, 600);
  }


  void filtro1() {
    col = width / cellSize;
    fila = height / cellSize;
    cam.loadPixels();

    background(random(255), random(255), random(255));

  
    for (int i = 0; i < col; i++) {
   
      for (int j = 0; j < fila; j++) {

        int x = i * cellSize;
        int y = j * cellSize;
        int loc = (cam.width - x - 1) + y*cam.width; // Reversing x to mirror the image

        color c = cam.pixels[loc];
        float sz = (brightness(c) / 255.0) * cellSize;
        fill(255);
        noStroke();
        rect(x + cellSize/2, y + cellSize/2, sz, sz);
      }
    }
    fill(0);
    textSize(28);
    text("Presiona RIGHT o LEFT para continuar o ENTER para terminar", 100, 700);
  }

  void filtro2() {
    background(0);
    cam.loadPixels();
    for (int i=0; i<cam.width; i+=p) {
      for (int j=0; j<cam.height; j+=p) {
        color c= cam.get(i, j);
        stroke(c);
        strokeWeight(0.5);
        noFill();
        ellipse(i, j, random(-50, 50), random(-50, 50));
      }
    }
    fill(255);
    textSize(28);
    text("Presiona RIGHT o DOWN o para continuar o ENTER para terminar", 100, 700);
  }

  int threshold = 127; 
  float pixelBrightness; 

  void filtro3() {
    cam.loadPixels();
    if (cam.available()) {
      cam.read();
    }

    loadPixels();
    for (int i = 0; i < numPixels; i++) {
      pixelBrightness = brightness(cam.pixels[i]);
      if (pixelBrightness > threshold) { ///si el pixel es mas brillante
        pixels[i] = blue;//azul
      } else { 
        pixels[i] = green; //sino verde
      }
    }

    updatePixels();
    int testValue = get(mouseX, mouseY);
    float testBrightness = brightness(testValue);
    if (testBrightness > threshold) { 
      fill(green);
    } else { 
      fill(blue);
    }
    fill(0);
    textSize(28);
    text("Presiona LEFT o DOWN o para continuar o ENTER para terminar", 100, 700);
  }

  void filtro4() {
    background(150);

    if (cam.available()) {
      cam.read();
    }

    opencv.loadImage(cam);

    // color information
    opencv.useColor();
    src = opencv.getSnapshot();

    opencv.useColor(HSB);

    detectColors();

    // Show images
    image(src, 0, 0);
    for (int i=0; i<outputs.length; i++) {
      if (outputs[i] != null) {
        image(outputs[i], width-src.width/4, i*src.height/4, src.width/4, src.height/4);

        noStroke();
        fill(colors[i]);
        rect(src.width, i*src.height/4, 30, src.height/4);
      }
    }

    textSize(20);
    stroke(0);
    fill(0);

    if (colorToChange > -1) {
      text("Da click para cambiar el color" + colorToChange, 10, 25);
    } else {
      text("Presiona q,w,e,r para seleccionar un color", 10, 25);
    }

    displayContoursBoundingBoxes();
  }

  void detectColors() {

    for (int i=0; i<hues.length; i++) {

      if (hues[i] <= 0) continue;

      opencv.loadImage(src);
      opencv.useColor(HSB);

      // <4> Copy the Hue channel of our image into 
      //     the gray channel, which we process.
      opencv.setGray(opencv.getH().clone());

      int hueToDetect = hues[i];
      //println("index " + i + " - hue to detect: " + hueToDetect);

      opencv.inRange(hueToDetect-rangeWidth/2, hueToDetect+rangeWidth/2);

      //opencv.dilate();
      opencv.erode();


      // <6> Save the processed image for reference.
      outputs[i] = opencv.getSnapshot();
    }


    if (outputs[0] != null) {

      opencv.loadImage(outputs[0]);
      contours = opencv.findContours(true, true);
    }
  }

  void displayContoursBoundingBoxes() {

    for (int i=0; i<contours.size(); i++) {

      Contour contour = contours.get(i);
      Rectangle r = contour.getBoundingBox();

      if (r.width < 20 || r.height < 20)
        continue;

      stroke(255, 0, 0);
      fill(255, 0, 0, 150);
      strokeWeight(2);
      rect(r.x, r.y, r.width, r.height);
    }
    fill(255);
    textSize(28);
    text("Presiona ENTER para continuar o presiona UP, DOWN, LEFT o RIGHT para ver cualquier filtro", 20, 700);
  }

  void fin() {
    background(0);
    image(im, 0, 0);
    fill(255);
    textSize(40);
    text("¡Gracias por participar en esta experiencia!", 250, 200);
    textSize(28);
    text("Pulsa x para regresar a inicio o ESC para salir", 350, 500);
  }

  void salir() {
  }


  void display() {
    switch(this.n) {
    case 0:
      inicio();
      break;
    case 1:
      filtro1();
      break;
    case 2:
      filtro2();
      break;
    case 3:
      filtro3();
      break;
    case 4:
      filtro4();
      break;
    case 5:
      fin();
      break;
    }
  }
  void teclado() {
    if (keyCode== UP) {
      n=1;
    }

    if (keyCode== LEFT) {
      n=2;
    }
    if (keyCode== RIGHT) {
      n=3;
      cam.loadPixels();
    }
    if (keyCode==DOWN) {
      n=4;
    }
    if (keyCode==ENTER) {
      n=5;
    }

    if (key=='x') {
      n=0;
    }

    if (key=='z') {
      saveFrame("screenshot.png");
    }

    if (key == 'q') {
      colorToChange = 1;
    } else if (key == 'w') {
      colorToChange = 2;
    } else if (key == 'e') {
      colorToChange = 3;
    } else if (key == 'r') {
      colorToChange = 4;
    }
  }
}//cierre de pantalla


void keyReleased() { //objeto
  colorToChange = -1;
}

void mousePressed() { //objeto 

  if (colorToChange > -1) {

    color c = get(mouseX, mouseY);
    println("r: " + red(c) + " g: " + green(c) + " b: " + blue(c));

    int hue = int(map(hue(c), 0, 255, 0, 180));

    colors[colorToChange-1] = c;
    hues[colorToChange-1] = hue;

    println("color index " + (colorToChange-1) + ", value: " + hue);
  }
}

void keyPressed() { 
  ppal.teclado();

  cam.loadPixels();
}
