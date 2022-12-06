SimpleUI ui;
DrawnShape canvas;
ArrayList<DrawnShape> shapeList;
DrawnShape selectedGraphic;
int canvasMX, canvasMY;
int drawStartX = -1, drawStartY = -1;
int shapeListSize = 0;
int psteps = 0;
void setup() {
  size(1280, 800);
  ui = new SimpleUI();
  shapeList = new ArrayList<DrawnShape>();
  setupMenu();
  setupShapes();
  setupColours();
  setupFilters();
  ui.addCanvas(200, 118, 850, 600);
}
void setupMenu(){
  String fileMenu[] = {"Load Image","Save Image","Undo Filters"};
  ui.addMenu("         File",500,35,fileMenu);
  String resetMenu[] = {"Drawings","All Items"};
  ui.addMenu("        Reset",650,35,resetMenu);
}
void setupShapes(){
  ui.addSimpleLabel("Shapes",50,120,"       SHAPES");
  ui.addRadioButton("     Select", 65, 143, "drawings").setSelected(true);
  ui.addRadioButton("rectangle", 65, 163, "drawings");
  ui.addRadioButton("ellipse",65, 183, "drawings");
  ui.addRadioButton("line", 65, 203, "drawings");
  ui.addRadioButton("curve", 65, 223, "drawings");
  ui.addSimpleButton("   Delete", 65,246);
}
void setupColours(){
  
  ui.addSimpleLabel("Colours",50,295,"     COLOURS");
  ui.addSlider("stroke red", 27, 325);
  ui.addSlider("stroke green", 27, 355);
  ui.addSlider("stroke blue", 27, 385);
  
  ui.addSlider("fill red", 27, 425);
  ui.addSlider("fill green", 27, 455);
  ui.addSlider("fill blue", 27, 485);

  ui.addToggleButton("show stroke", 65, 525).setSelected(true);
  ui.addToggleButton("show fill", 65, 545).setSelected(true);
  
  ui.addSlider("stroke weight", 50, 570);
}
void StrokeColourBox(){
  float r = 0, g = 0, b = 0;
  r = ui.getSliderValue("stroke red")*255;
  g = ui.getSliderValue("stroke green")*255;
  b = ui.getSliderValue("stroke blue")*255;
  ui.drawStrokeColour(r,g,b);
}
void FillColourBox(){
  float r = 0, g = 0, b = 0;
  r = ui.getSliderValue("fill red")*255;
  g = ui.getSliderValue("fill green")*255;
  b = ui.getSliderValue("fill blue")*255;
  ui.drawFillColour(r,g,b);
}
void setupFilters(){
  ui.addSimpleLabel("Filters",1115,125,"      FILTERS");
  ui.addSimpleButton("Greyscale", 1130, 160);
  ui.addSimpleButton("Negative", 1130,180);
  ui.addSimpleButton("Posterize", 1130,200);
  ui.addSimpleButton("Blur", 1130, 220);
  ui.addSimpleButton("Sharpen", 1130, 240);
  ui.addSimpleButton("Edges", 1130, 260);
  ui.addSimpleButton("Brighten",1130,280);
  ui.addSimpleButton("Darken", 1130,300);
  ui.addSimpleButton("Contrast", 1130,320);
  ui.addSimpleButton("Invert H", 1130, 350);
  ui.addSimpleButton("Invert V", 1130, 370);
  ui.addSlider("Hue", 1115, 415);
  ui.addSlider("Brightness", 1115, 455);
  ui.addSlider("Saturation", 1115, 495);
  ui.addSimpleButton("   Apply", 1130, 535);  
}
void draw() {
  ui.update();
  StrokeColourBox();
  FillColourBox();
  canvas = new DrawnShape(int(ui.canvasRect.left), int(ui.canvasRect.top), int(ui.canvasRect.right - ui.canvasRect.left), int(ui.canvasRect.bottom - ui.canvasRect.top), createGraphics(int(ui.canvasRect.right - ui.canvasRect.left), int(ui.canvasRect.bottom - ui.canvasRect.top)), "canvas");
  canvasMX = mouseX - canvas.x;
  canvasMY = mouseY - canvas.y;
  canvas.newg.beginDraw();
  canvas.newg.background(255);
  for (DrawnShape s : shapeList) {
    canvas.newg.image(s.newg, s.x, s.y);
  }
  if (selectedGraphic != null) {
    canvas.newg.noFill();
    canvas.newg.stroke(255, 0, 0);
    canvas.newg.strokeWeight(2);
    canvas.newg.rect(selectedGraphic.x, selectedGraphic.y, selectedGraphic.w, selectedGraphic.h);
  }
  if (drawStartX != -1 && drawStartX != -1) {
    canvas.newg.noFill();
    canvas.newg.stroke(255, 0, 0);
    canvas.newg.strokeWeight(2);
    canvas.newg.rect(drawStartX, drawStartY, canvasMX - drawStartX, canvasMY - drawStartY);
  }
  canvas.newg.endDraw();
  image(canvas.newg, ui.canvasRect.left, ui.canvasRect.top);
}

void handleUIEvent(UIEventData uied) {
  if (uied.eventIsFromWidget("Load Image")) {
    selectedGraphic = null;
    ui.openFileLoadDialog("Load an Image");
  }
  if (uied.eventIsFromWidget("fileLoadDialog")) {
    PImage loadedImage = loadImage(uied.fileSelection);
    loadedImage.resize(400, 0);
    PGraphics loadedImageG = createGraphics(loadedImage.width, loadedImage.height);
    loadedImageG.beginDraw();
    loadedImageG.image(loadedImage, 0, 0);
    loadedImageG.endDraw();
    shapeList.add(new DrawnShape(0, 0, loadedImage.width, loadedImage.height, loadedImageG, "image"));
  }
  if (uied.eventIsFromWidget("Save Image")) {
    ui.openFileSaveDialog("Save your Work");
  }
  if (uied.eventIsFromWidget("fileSaveDialog")) {
    canvas.newg.save(uied.fileSelection);
  }
  if (uied.eventIsFromWidget("   Delete")) {
    for (int i = 0; i < shapeList.size(); i++) {
      if (shapeList.get(i) == selectedGraphic) {
        shapeList.remove(i);
        selectedGraphic = null;
        break;
      }
    }
  }
  if (uied.eventIsFromWidget("All Items")) {
    shapeList = new ArrayList<DrawnShape>();
    selectedGraphic = null; 
    psteps = 0;
  }
  if (uied.eventIsFromWidget("Greyscale")) {
    if (selectedGraphic != null) {
      selectedGraphic.newg = greyscale(selectedGraphic.newg);
      selectedGraphic.filtg = selectedGraphic.newg;
    }
  }
  if( uied.eventIsFromWidget("Negative")){
    if (selectedGraphic != null) {
      selectedGraphic.newg = negative(selectedGraphic.newg);
      selectedGraphic.filtg = selectedGraphic.newg;
    }
  }
  if( uied.eventIsFromWidget("Posterize")){
    if (selectedGraphic != null) {
      psteps=psteps+5;
      selectedGraphic.newg = posterize(selectedGraphic.newg,psteps);
      selectedGraphic.filtg = selectedGraphic.newg;
    }
  }
  if (uied.eventIsFromWidget("Blur")) {
    if (selectedGraphic != null) {
      selectedGraphic.newg = blur(selectedGraphic.newg);
      selectedGraphic.filtg = selectedGraphic.newg;
    }
  }
  if (uied.eventIsFromWidget("Sharpen")) {
    if (selectedGraphic != null) {
      selectedGraphic.newg = sharpen(selectedGraphic.newg);
      selectedGraphic.filtg = selectedGraphic.newg;
    }
  }
  if (uied.eventIsFromWidget("Edges")) {
    if (selectedGraphic != null) {
      selectedGraphic.newg = edge(selectedGraphic.newg);
      selectedGraphic.filtg = selectedGraphic.newg;
    }
  }
  if( uied.eventIsFromWidget("Brighten")){
    int[] lut =  makeLUT("brighten", 1.1, 0.0);
    PImage lutF = selectedGraphic.newg.get();
    lutF = applyPointProcessing(lut, lutF);
    selectedGraphic.newg = createGraphics(lutF.width, lutF.height);
    selectedGraphic.newg.beginDraw();
    selectedGraphic.newg.image(lutF, 0, 0);
    selectedGraphic.newg.endDraw();
    selectedGraphic.filtg = selectedGraphic.newg;
  }
  
  if( uied.eventIsFromWidget("Darken")){
    int[] lut =  makeLUT("brighten", 0.9, 0.0);
    PImage lutF = selectedGraphic.newg.get();
    lutF = applyPointProcessing(lut, lutF);
    selectedGraphic.newg = createGraphics(lutF.width, lutF.height);
    selectedGraphic.newg.beginDraw();
    selectedGraphic.newg.image(lutF, 0, 0);
    selectedGraphic.newg.endDraw();
    selectedGraphic.filtg = selectedGraphic.newg;
  }
  
 
  if( uied.eventIsFromWidget("Contrast")){
    int[] lut =  makeLUT("sigmoid", 0.0, 0.0);
    PImage lutF = selectedGraphic.newg.get();
    lutF = applyPointProcessing(lut, lutF);
    selectedGraphic.newg = createGraphics(lutF.width, lutF.height);
    selectedGraphic.newg.beginDraw();
    selectedGraphic.newg.image(lutF, 0, 0);
    selectedGraphic.newg.endDraw();
    selectedGraphic.filtg = selectedGraphic.newg;
  }
  if (uied.eventIsFromWidget("   Apply")) {
    if (selectedGraphic != null && selectedGraphic.filtg != null) {
      selectedGraphic.newg = shiftHSB(selectedGraphic.filtg,ui.getSliderValue("Hue") * 255,ui.getSliderValue("Saturation") * 255, ui.getSliderValue("Brightness") * 255);
    }
    if (selectedGraphic != null && selectedGraphic.filtg == null) {
      selectedGraphic.newg = shiftHSB(selectedGraphic.oldg,ui.getSliderValue("Hue") * 255,ui.getSliderValue("Saturation") * 255, ui.getSliderValue("Brightness") * 255);
    }
  }
  if (uied.eventIsFromWidget("Invert H")) {
    if (selectedGraphic != null) {
      selectedGraphic.newg = invhor(selectedGraphic.newg);
    }
  }
  if (uied.eventIsFromWidget("Invert V")) {
    if (selectedGraphic != null) {
      selectedGraphic.newg = invert(selectedGraphic.newg);
    }
  }
  if (uied.eventIsFromWidget("Undo Filters")) {
    if (selectedGraphic != null) {
      selectedGraphic.newg = createGraphics(selectedGraphic.oldg.width, selectedGraphic.oldg.height);
      selectedGraphic.newg.beginDraw();
      selectedGraphic.newg.image(selectedGraphic.oldg, 0, 0);
      selectedGraphic.newg.endDraw();
      selectedGraphic.filtg = null;
      psteps = 0;
    }
  }
  if (uied.eventIsFromWidget("Drawings")) {
    int shapeListSize = shapeList.size();
      for (int i = 0; i < shapeListSize; i++) {
        if (!shapeList.get(i).tag.equals("image")){
          shapeList.remove(i);
          shapeListSize--;
          i=-1;
        }
        else
          continue;
      }
  }
  if (uied.eventIsFromWidget("canvas")) {
    String drawModeSelected = ui.getRadioGroupSelected("drawings");
    if (drawModeSelected.equals("     Select")) {
      boolean foundSelected = false;
      if (uied.mouseEventType.equals("mousePressed")) {
        
        for (DrawnShape s : shapeList) {
          if (s.posIn(canvasMX, canvasMY)) {
            selectedGraphic = s;
            foundSelected = true;
          }
        }
        if (!foundSelected) selectedGraphic = null;
      }
      if (uied.mouseEventType.equals("mouseDragged")) {
        if (selectedGraphic != null) {
          selectedGraphic.x = canvasMX-(selectedGraphic.w/2);
          selectedGraphic.y = canvasMY-(selectedGraphic.h/2);
        }
      }
    } else {
      if (uied.mouseEventType.equals("mousePressed")) {
        drawStartX = canvasMX;
        drawStartY = canvasMY;
      }
      if (uied.mouseEventType.equals("mouseReleased")) {
        int l = min(drawStartX, canvasMX);
        int t = min(drawStartY, canvasMY);
        int r = max(drawStartX, canvasMX);
        int b = max(drawStartY, canvasMY);
        int strokeWeight = int(ui.getSliderValue("stroke weight") * 20);
        PGraphics shape = createGraphics(r - l + strokeWeight, b - t + strokeWeight);
        if (shape.width != 0 && shape.height != 0) {
          shape.beginDraw();
          if (ui.getToggleButtonState("show stroke")) {
            shape.stroke(ui.getSliderValue("stroke red") * 255, ui.getSliderValue("stroke green") * 255, ui.getSliderValue("stroke blue") * 255);
            shape.strokeWeight(strokeWeight);
          } else {
            shape.noStroke();
          }
          if (ui.getToggleButtonState("show fill")) {
            shape.fill(ui.getSliderValue("fill red") * 255, ui.getSliderValue("fill green") * 255, ui.getSliderValue("fill blue") * 255);
          } else {
            shape.noFill();
          }
          if (drawModeSelected.equals("rectangle")) {
            selectedGraphic = null;
            shape.rect(strokeWeight * 0.5, strokeWeight * 0.5, r - l, b - t);
          }
          if (drawModeSelected.equals("ellipse")) {
            selectedGraphic = null;
            shape.ellipse(strokeWeight * 0.5 + (r - l) * 0.5, strokeWeight * 0.5 + (b - t) * 0.5, r - l, b - t);
          }
          if (drawModeSelected.equals("line")) {
            selectedGraphic = null;
            shape.line(strokeWeight * 0.5 + drawStartX - l, strokeWeight * 0.5 + drawStartY - t, strokeWeight * 0.5 + r - l - (r - canvasMX), strokeWeight * 0.5 + b - t - (b - canvasMY));
          }
          if (drawModeSelected.equals("curve")) {
            selectedGraphic = null;
            shape.noFill();
            shape.beginShape();
            shape.curveVertex(strokeWeight * 0.5 + drawStartX - l, strokeWeight * 0.5 + drawStartY - t);
            shape.curveVertex(strokeWeight * 0.5 + drawStartX - l, strokeWeight * 0.5 + drawStartY - t);
            shape.curveVertex(random(0, r - l), random(0, b - t));
            shape.curveVertex(random(0, r - l), random(0, b - t));
            shape.curveVertex(strokeWeight * 0.5 + r - l - (r - canvasMX), strokeWeight * 0.5 + b - t - (b - canvasMY));
            shape.curveVertex(strokeWeight * 0.5 + r - l - (r - canvasMX), strokeWeight * 0.5 + b - t - (b - canvasMY));
            shape.endShape();
          }
          shape.endDraw();
          shapeList.add(new DrawnShape(int(l - strokeWeight * 0.5), int(t - strokeWeight * 0.5), shape.width, shape.height, shape, drawModeSelected));
          drawStartX = -1;
          drawStartY = -1;
        }
      }
    }
  }
}
