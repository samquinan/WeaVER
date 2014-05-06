class Slider {
  
  float line_x1, line_x2, line_y, v1, v2, s;
  float Rx, Ry;
  float offsetX, offsetY; // Mouseclick offset
  boolean dragging = false;
  boolean rollover = false;
  boolean active;
  int sigDigits;
  String label;
  boolean showSliderValue = true;
  
  
  Slider(float end1, float end2, float yval, float value1, float value2){
    line_x1 = end1;
    line_x2 = end2;
    line_y = yval;
    v1 = value1;
    v2 = value2;
    s = value1;
    //defaults
    Rx = 8;
    Ry = 10;
    offsetX = 0;
    offsetY = 0;
    sigDigits = 0;
	label = "";
	
	active = true;
  }
  
  // additional intitalization controls
  void setKnobSize(float rx, float ry){
    Rx = rx;
    Ry = ry;
  }
  
  void setMouseOffset(float offX, float offY){
    offsetX = offX;
    offsetY = offY; 
  }
  
  void setSigDigits(int i){
    sigDigits = i;
  }
  
  void setLabel(String s){
	  label = s;
  }
  
  PVector getRange(){
	  return new PVector(v1, v2);
  }
  
  void displaySliderValue(boolean b){
	  showSliderValue = b;
  }
  
  boolean isActive(){
  	  return active;
  }
  
  void setActive(boolean b){
  	  active = b;
  }
  
  // get methods
  float getValue(){
    return s;
  }
  
  // update methods
  void setVal(float v){
    s = round(min(max(v, min(v1,v2)), max(v1,v2))*pow(10, sigDigits))/pow(10, sigDigits);
  }
  
  void updateVal(float new_x){
    float bounded_x = min(max(new_x, min(line_x1, line_x2)), max(line_x1, line_x2));
    s = round(map(bounded_x, line_x1, line_x2, v1, v2)*pow(10, sigDigits))/pow(10, sigDigits);
  }
  
  // display
  void display(){
    stroke(50);
    strokeWeight(1);
    line(line_x1, line_y, line_x2, line_y);
    if (rollover || dragging){
	  if (showSliderValue){
	      // display S value as overlay
	      fill(50);
	      textSize(10);
	      textAlign(CENTER);
	      text(str(s), map(s, v1, v2, line_x1, line_x2), line_y-Ry);
	  }
      //highlight color for slider knob
      if (dragging) fill(50);
      else fill(121, 169, 209);
    }
    else{
      fill(150);
    }
    ellipse(map(s, v1, v2, line_x1, line_x2), line_y, Rx, Ry);
    textSize(12);
	fill(0, 0, 0, 255);
    textAlign(CENTER);
    text(label, (line_x1+line_x2)/2, line_y+20);
  } 
  
  // mouse interaction methods
  boolean interact(float mx, float my){
	if (!active) return active;   
    if(dragging) updateVal(mouseX);
    else rollover = ((sq(mx - map(s, v1, v2, line_x1, line_x2))/sq(Rx+offsetX)) + ((sq(my - line_y))/sq(Ry+offsetY))) <= 1;
	return (dragging || rollover);
  }
  
  boolean clicked(float mx, float my){
	if (!active) return active;
    dragging = ((sq(mx - map(s, v1, v2, line_x1, line_x2))/sq(Rx+offsetX)) + ((sq(my - line_y))/sq(Ry+offsetY))) <= 1;
	return dragging;
  }
    
  boolean released(){
	boolean tmp = dragging;
    dragging = false;
	return tmp;
  }
  
  boolean isDragging(){
	return dragging;
  }
}
