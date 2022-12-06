
PGraphics invert(PGraphics g) {
  PGraphics n = createGraphics(g.width, g.height);
  colorMode(HSB);
  n.beginDraw();
  for (int x = 0; x < g.width; x++) {
    for (int y = 0; y < g.height; y++) {
      color c = g.get(x, y);
      n.set(x, g.height - y, c);
    }
  }
  n.endDraw();
  colorMode(RGB);
  return n;
}
PGraphics invhor(PGraphics g) {
  PGraphics n = createGraphics(g.width, g.height);
  colorMode(HSB);
  n.beginDraw();
  for (int x = 0; x < g.width; x++) {
    for (int y = 0; y < g.height; y++) {
      color c = g.get(x, y);
      n.set(g.width - x, y, c);
    }
  }
  n.endDraw();
  colorMode(RGB);
  return n;
}
PGraphics shiftHSB(PGraphics g, float Hshift, float Sshift, float Bshift) {
  PGraphics n = createGraphics(g.width, g.height);
  colorMode(HSB);
  n.beginDraw();
  for (int x = 0; x < g.width; x++) {
    for (int y = 0; y < g.height; y++) {
      color c = g.get(x, y);
      color newC = color((hue(c)+Hshift), (saturation(c)+Sshift), (brightness(c) + Bshift));
      n.set(x, y, newC);
    }
  }
  n.endDraw();
  colorMode(RGB);
  return n;
}

PGraphics greyscale(PGraphics g) {
  PGraphics n = createGraphics(g.width, g.height);
  n.beginDraw();
  for (int x = 0; x < g.width; x++) {
    for (int y = 0; y < g.height; y++) {
      color c = g.get(x, y);
      color newC = color(0.299 * red(c) + 0.587 * green(c) + 0.114 * blue(c));
      n.set(x, y, newC);
    }
  }
  n.endDraw();
  return n;
}
PGraphics negative(PGraphics g) {
  PGraphics n = createGraphics(g.width, g.height);
  n.beginDraw();
  for (int x = 0; x < g.width; x++) {
    for (int y = 0; y < g.height; y++) {
      color c = g.get(x, y);
      float inputRed = red(c)/255.0;
      float inputGreen = green(c)/255.0;
      float inputBlue = blue(c)/255.0;
      float outputRed = (1-inputRed) *255;
      float outputGreen = (1-inputGreen) *255;
      float outputBlue = (1-inputBlue) *255;
      n.set(x,y, color(outputRed,outputGreen,outputBlue));
    }
  }
  n.endDraw();
  return n;
}
PGraphics posterize(PGraphics g,int numSteps) {
  PGraphics n = createGraphics(g.width, g.height);
  n.beginDraw();
  for (int x = 0; x < g.width; x++) {
    for (int y = 0; y < g.height; y++) {
      color c = g.get(x, y);
      float inputRed = red(c)/255.0;
      float inputGreen = green(c)/255.0;
      float inputBlue = blue(c)/255.0;
      float outputRed = step(inputRed,numSteps) *255;
      float outputGreen = step(inputGreen,numSteps) *255;
      float outputBlue = step(inputBlue,numSteps) *255;
      n.set(x,y, color(outputRed,outputGreen,outputBlue));
    }
  }
  n.endDraw();
  return n;
}
float step(float v, int numSteps){
  float thisStep = (int) (v*numSteps);
  return thisStep/numSteps;
  
}
PGraphics sharpen(PGraphics g) {
  PGraphics n = createGraphics(g.width, g.height);
  float[][] sharpen_matrix = {  { 0, -1, 0 },
                              {-1, 5, -1 },
                              { 0, -1, 0 } };  
  n.beginDraw();
  for(int y = 0; y < g.height; y++){
    for(int x = 0; x < g.width; x++){
      color c = convolution(x, y, sharpen_matrix, 3, g);
      n.set(x,y,c);
    }
  }
  n.endDraw();
  return n;
}
PGraphics edge(PGraphics g) {
  PGraphics n = createGraphics(g.width, g.height);
  float[][] edge_matrix = { { 0,  -2,  0 },
                          { -2,  8, -2 },
                          { 0,  -2,  0 } }; 
  n.beginDraw();
  for(int y = 0; y < g.height; y++){
    for(int x = 0; x < g.width; x++){
      color c = convolution(x, y, edge_matrix, 3, g);
      n.set(x,y,c);
    }
  }
  n.endDraw();
  return n;
}
PGraphics blur(PGraphics g) {
  PGraphics n = createGraphics(g.width, g.height);
  float[][] blur_matrix = {  {0.1,  0.1,  0.1 },
                           {0.1,  0.2,  0.1 },
                           {0.1,  0.1,  0.1 } };   
  n.beginDraw();
  for(int y = 0; y < g.height; y++){
    for(int x = 0; x < g.width; x++){
      color c = convolution(x, y, blur_matrix, 3, g);
      n.set(x,y,c);
    }
  }
  n.endDraw();
  return n;
}

color convolution(int Xcen, int Ycen, float[][] matrix, int matrixsize, PImage sourceImage)
{
  float rtotal = 0.0;
  float gtotal = 0.0;
  float btotal = 0.0;
  int offset = matrixsize / 2;
  // this is where we sample every pixel around the centre pixel
  // according to the sample-matrix size
  for (int i = 0; i < matrixsize; i++){
    for (int j= 0; j < matrixsize; j++){
      
      //
      // work out which pixel are we testing
      int xloc = Xcen+i-offset;
      int yloc = Ycen+j-offset;
      
      // Make sure we haven't walked off our image
      if( xloc < 0 || xloc >= sourceImage.width) continue;
      if( yloc < 0 || yloc >= sourceImage.height) continue;
      
      
      // Calculate the convolution
      color col = sourceImage.get(xloc,yloc);
      rtotal += (red(col) * matrix[i][j]);
      gtotal += (green(col) * matrix[i][j]);
      btotal += (blue(col) * matrix[i][j]);
    }
  }
  // Make sure RGB is within range
  rtotal = constrain(rtotal, 0, 255);
  gtotal = constrain(gtotal, 0, 255);
  btotal = constrain(btotal, 0, 255);
  // Return the resulting color
  return color(rtotal, gtotal, btotal);
}
int[] makeLUT(String functionName, float param1, float param2){
  int[] lut = new int[256];
  for(int n = 0; n < 256; n++) {
    
    float p = n/255.0f;  // p ranges between 0...1
    float val = getValueFromFunction( p, functionName,  param1,  param2);
    lut[n] = (int)(val*255);
  }
  return lut;
}

float getValueFromFunction(float inputVal, String functionName, float param1, float param2){
  if(functionName.equals("brighten")){
    return simpleScale(inputVal, param1);
  }
  
  if(functionName.equals("step")){
    return step(inputVal, (int)param1);
  }
  
  if(functionName.equals("negative")){
    return invert(inputVal);
  }
  
   if(functionName.equals("sigmoid")){
    return sigmoidCurve(inputVal);
  }
  
  // should only get here is the functionName is undefined
  return 0;
}


PImage applyPointProcessing(int[] LUT,  PImage inputImage){
  PImage outputImage = createImage(inputImage.width,inputImage.height,RGB);
  
  
  
 
  for (int y = 0; y < inputImage.height; y++) {
    for (int x = 0; x < inputImage.width; x++) {
    
    color c = inputImage.get(x,y);
    
    int r = (int)red(c);
    int g = (int)green(c);
    int b = (int)blue(c);
    
    int lutR = LUT[r];
    int lutG = LUT[g];
    int lutB = LUT[b];
    
    
    outputImage.set(x,y, color(lutR,lutG,lutB));
    
    }
  }
  
  return outputImage;
}
float simpleScale(float v, float scl){
  
  float scaledV =  v*scl;
  return constrain(scaledV,0,1);
  
}

// interpolates the input value between the low and hi values
float ramp(float v, float low, float hi){
  
  float rampedV = lerp(low, hi, v);
  return constrain(rampedV,0,1);
}

// negates the input value
float invert(float v){
  
  return 1-v;
}


// raises the input value by a power
float gammaCurve(float v, float gamma){
  
  return pow(v,gamma);
  
}

// creates a "flipped" gamma curve
float inverseGammaCurve(float v, float gamma){
  
  return 1.0 - pow(1.0-v,gamma);
  
}

// creates a nice S-shaped curve, useful for contrast functions
float sigmoidCurve(float v){
  // contrast: generate a sigmoid function
  
  float f =  (1.0 / (1 + exp(-12 * (v  - 0.5))));
  
 
  return f;
}
