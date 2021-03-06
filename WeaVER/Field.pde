class Field{
  // field data
  FloatList data;
  int dimx, dimy;
  // support attributes
  float minVal, maxVal;
  //projection info -- for unprojected points, just spacing and buffer 
  float spacing, buffer;
  PVector viewZero;
  float viewHeight, viewWidth;
  
  boolean dataAvailable;
  
  Field(String file, int dx, int dy, PVector offset, float maxh, float maxw){ // expects 1 value per line (!) no commas, no lat / long
	
	dimx = dx;
    dimy = dy;
    viewZero = offset;
    
    spacing = min(maxh/dy, maxw/dx);
    viewHeight = dy*spacing;
    viewWidth = dx*spacing;
    
    data = new FloatList();
    
    // read data from file
    String[] lines;
	dataAvailable = true;
	
	try{
		lines = loadStrings(file);
		
	    boolean first = true;  
	    for(String line: lines)
	    {
	      float val = float(line.trim());
	      data.append(val);
	      //track max and min
	      if (first){
	        maxVal = val;
	        minVal = val;
	        first = false;
	      }
	      else{
	        maxVal = max(maxVal, val);
	        minVal = min(minVal, val);
	      }
	    }
	}
	catch(Exception e){
		dataAvailable = false;
        maxVal = 0;
        minVal = 0;
	}
    if (dataAvailable && (data.size() != dimx * dimy)){
		println("ERROR creating Field: number of entries in file does not match provided dimensions");
	}
	 
  }
  
  Field(FloatList d, float vmax, float vmin, int dx, int dy, PVector offset, float maxh, float maxw){ 
	  
	dimx = dx;
    dimy = dy;
    viewZero = offset;
    
    spacing = min(maxh/dy, maxw/dx);
    viewHeight = dy*spacing;
    viewWidth = dx*spacing;
    
    data = d;
	maxVal = vmax;
	minVal = vmin;
		
	dataAvailable = true;
	
    if (dataAvailable & (data.size() != dimx * dimy)){
		println("ERROR creating Field: side of provided FloatList does not match provided dimensions");
	}
	
  }
  
  Field(){
  	dimx = 0;
    dimy = 0;
	viewZero = new PVector(0,0);
	spacing = 0;
    viewHeight = 0;
    viewWidth = 0;
	data = new FloatList();
	maxVal = 0;
	minVal = 0;
	
	dataAvailable = false;
}
    
  boolean dataIsAvailable(){
	  return dataAvailable;
  }
  
  float getMin(){
    return minVal;
  }
  
  float getMax(){
    return maxVal;
  }
  
  void drawViewport(){
    rect(viewZero.x, viewZero.y, viewWidth, viewHeight); 
  }
  
  void drawGrid(int pointRadius){
    
    float incrY = spacing; // regular spacing of points assuming regular grid
    float incrX = spacing; //      -- [TODO] not appropriate for lat/long
    
    for (int j=0; j < dimy; j++){ //simulte 2D array
      for (int i=0; i < dimx; i++) {
        PVector val00Pos = new PVector (round(viewZero.x+(i+0.5)*incrX), round(viewZero.y+viewHeight-((j+0.5)*incrY)));
        ellipse(val00Pos.x, val00Pos.y, pointRadius, pointRadius);
      }
    }
  }
  
  void genIsocontour(float iso, Contour2D contour){ 
	
	if (!dataAvailable) return;
	
    float incrY = spacing; // regular spacing of points assuming regular grid
    float incrX = spacing; //      -- [TODO] not appropriate for lat/long -- maybe grid small enough that linear sufficient? 
      
    for (int j=0; j < dimy; j++){ //simulte 2D array
      for (int i=0; i < dimx; i++) {
        
        /* MARCHING SQUARES
        *
        *   runs on grid cells
        *   assume "cell" in grid defined s.t.
        *   current point is bottom left corner (0,0)
        *
        *          1,0 ---- 1,1
        *           |        |
        *           |        |
        *          0,0 ---- 0,1
        *
        *   a good summary of the algorithm details can be found at:
        *         http://en.wikipedia.org/wiki/Marching_squares
        *
        */
        
        if ((i == (dimx-1)) || (j == (dimy-1))) continue; //ignore far edges, no such cell defined
        
        // get current cell
        int idx = (j*dimx)+i;
        float val00 = data.get(idx);             
        float val01 = data.get(idx+1);
        float val10 = data.get(idx+dimx);
        float val11 = data.get(idx+dimx+1);
        
        // again, assuming regular grid --  [TODO] not true reflection of lat/long
		PVector val00Pos = new PVector (round(((i+0.5)*incrX)+viewZero.x), round(viewZero.y+viewHeight-((j+0.5)*incrY))); 
		PVector val01Pos = new PVector (round(((i+1.5)*incrX)+viewZero.x), round(viewZero.y+viewHeight-((j+0.5)*incrY)));
		PVector val10Pos = new PVector (round(((i+0.5)*incrX)+viewZero.x), round(viewZero.y+viewHeight-((j+1.5)*incrY)));
		PVector val11Pos = new PVector (round(((i+1.5)*incrX)+viewZero.x), round(viewZero.y+viewHeight-((j+1.5)*incrY)));
        
        // runs 4 binary checks - create 'case' number from resulting binary string
        int b = (int(val10 >= iso) << 3) + (int(val11 >= iso) << 2) + (int(val01 >= iso) << 1) + (int(val00 >= iso));
        
        // draw contour edges based on case
        /* note: fill requires definition of inside/outside,  *
         *       which we are ignoring for isocontouring      */
        float p1, p2;
		Segment2D s = null;
		Segment2D s2 = null;
        switch (b) {
          case 1:
          case 14:
            p1 = map(iso, val00, val10, val00Pos.y, val10Pos.y);
            p2 = map(iso, val00, val01, val00Pos.x, val01Pos.x);
			s = new Segment2D(new PVector(val00Pos.x, p1), new PVector(p2, val00Pos.y));
            break;
          case 2:
          case 13:
            p1 = map(iso, val01, val11, val01Pos.y, val11Pos.y);
            p2 = map(iso, val00, val01, val00Pos.x, val01Pos.x);
			s = new Segment2D(new PVector(val01Pos.x, p1), new PVector(p2, val01Pos.y));
            break;
          case 3:
          case 12:
            p1 = map(iso, val00, val10, val00Pos.y, val10Pos.y);
            p2 = map(iso, val01, val11, val01Pos.y, val11Pos.y);
			s = new Segment2D(new PVector(val00Pos.x, p1), new PVector(val01Pos.x, p2));
            break;
          case 4:
          case 11:
            p1 = map(iso, val10, val11, val10Pos.x, val11Pos.x);
            p2 = map(iso, val01, val11, val01Pos.y, val11Pos.y);
			s = new Segment2D(new PVector(p1, val11Pos.y), new PVector(val11Pos.x, p2));
            break;
          case 6:
          case 9:
            p1 = map(iso, val10, val11, val10Pos.x, val11Pos.x);
            p2 = map(iso, val00, val01, val00Pos.x, val01Pos.x);
			s = new Segment2D(new PVector(p1, val10Pos.y), new PVector(p2, val00Pos.y));
            break;
          case 7:
          case 8:
            p1 = map(iso, val00, val10, val00Pos.y, val10Pos.y);
            p2 = map(iso, val10, val11, val10Pos.x, val11Pos.x);
			s = new Segment2D(new PVector(val00Pos.x, p1), new PVector(p2, val10Pos.y));
            break;
          case 5:
            /* ambiguous / saddle case
             *   resolve according to "central" value, calculated as average of 4 corners
             */                        
            if (((val00 + val01 + val10 + val11)/4.0) >= iso) {
              p1 = map(iso, val00, val10, val00Pos.y, val10Pos.y);
              p2 = map(iso, val10, val11, val10Pos.x, val11Pos.x);
  			  s = new Segment2D(new PVector(val00Pos.x, p1), new PVector(p2, val10Pos.y));
			  
              p1 = map(iso, val01, val11, val01Pos.y, val11Pos.y);
              p2 = map(iso, val00, val01, val00Pos.x, val01Pos.x);
  			  s2 = new Segment2D(new PVector(val01Pos.x, p1), new PVector(p2, val01Pos.y));
            }
            else {
              p1 = map(iso, val00, val10, val00Pos.y, val10Pos.y);
              p2 = map(iso, val00, val01, val00Pos.x, val01Pos.x);
  			  s = new Segment2D(new PVector(val00Pos.x, p1), new PVector(p2, val00Pos.y));
			  
              p1 = map(iso, val10, val11, val10Pos.x, val11Pos.x);
              p2 = map(iso, val01, val11, val01Pos.y, val11Pos.y);
  			  s2 = new Segment2D(new PVector(p1, val11Pos.y), new PVector(val11Pos.x, p2));
            }
            break;
          case 10:
            /* ambiguous / saddle case
             *   resolve according to "central" value, calculated as average of 4 corners
             */
            if (((val00 + val01 + val10 + val11)/4.0) >= iso) {
              p1 = map(iso, val00, val10, val00Pos.y, val10Pos.y);
              p2 = map(iso, val00, val01, val00Pos.x, val01Pos.x);
  			  s = new Segment2D(new PVector(val00Pos.x, p1), new PVector(p2, val00Pos.y));
			  
              p1 = map(iso, val10, val11, val10Pos.x, val11Pos.x);
              p2 = map(iso, val01, val11, val01Pos.y, val11Pos.y);
  			  s2 = new Segment2D(new PVector(p1, val11Pos.y), new PVector(val11Pos.x, p2));
            }
            else {
              p1 = map(iso, val00, val10, val00Pos.y, val10Pos.y);
              p2 = map(iso, val10, val11, val10Pos.x, val11Pos.x);
  			  s = new Segment2D(new PVector(val00Pos.x, p1), new PVector(p2, val10Pos.y));
              
              p1 = map(iso, val01, val11, val01Pos.y, val11Pos.y);
              p2 = map(iso, val00, val01, val00Pos.x, val01Pos.x);
  			  s2 = new Segment2D(new PVector(val01Pos.x, p1), new PVector(p2, val01Pos.y));
            }
            break;
          case 0:    // no edges
          case 15:   
          default:
            break;
        }
		
        if (s != null) contour.addSegment(s);
		if (s2 != null) contour.addSegment(s2);
            
      }
    }
	//hot swap
	contour.update();
  }
  
  void genFillNearestNeighbor(PImage img, ColorMapf cmap, boolean interpolate){
	  
	  if (!dataAvailable) return;
	  
	  int samplesx = dimx;
	  int samplesy = dimy;
	  
	  if (int(samplesx*spacing) != img.width || int(samplesy*spacing) != img.height){
		  println("Error in genFill: PImage dims do not match field");
		  return;
	  }
	  
	  img.loadPixels();
	  for (int j = 0; j < samplesy; j++){
		  for (int i = 0; i < samplesx; i++){
			  //nearest neighbor
			  float val = data.get(getIndex(i,j,samplesx));//grab data value
			  color c = cmap.getColor(val, interpolate);

			  int idx;
			  for (int n = 0; n < spacing; n++){
				idx = getIndex(int(i*spacing), int(((samplesy-1)-j)*spacing)+n, int(samplesx*spacing));
			  	for (int m = 0; m < spacing; m++){
					img.pixels[idx] = c;
					idx++;
				}
			  }
		  }
	  }

	  img.updatePixels();
  }
  
  //HACK! TODO make so does proper alpha belending rather than binary overwrite on non-zero alpha
  void genFillNearestNeighbor(PImage img, ColorMapf cmap, boolean interpolate, boolean overwriteClear){
	  
	  if (!dataAvailable) return;
	  
	  int samplesx = dimx;
	  int samplesy = dimy;
	  
	  if (int(samplesx*spacing) != img.width || int(samplesy*spacing) != img.height){
		  println("Error in genFill: PImage dims do not match field");
		  return;
	  }
	  
	  img.loadPixels();
	  for (int j = 0; j < samplesy; j++){
		  for (int i = 0; i < samplesx; i++){
			  //nearest neighbor
			  float val = data.get(getIndex(i,j,samplesx));//grab data value
			  color c = cmap.getColor(val, interpolate);
			  
			  if (overwriteClear || (((c >> 24) & 0xFF) > 0)){
				  int idx;
				  for (int n = 0; n < spacing; n++){
					idx = getIndex(int(i*spacing), int(((samplesy-1)-j)*spacing)+n, int(samplesx*spacing));
				  	for (int m = 0; m < spacing; m++){
						img.pixels[idx] = c;
						idx++;
					}
				  }
			  }
			  
		  }
	  }

	  img.updatePixels();
  }
      
  void genFillBilinear(PImage img, ColorMapf cmap, boolean interpolate){
	  
	  if (!dataAvailable) return;
	  
	  int samplesx = dimx;
	  int samplesy = dimy;
	  
	  if (int(samplesx*spacing) != img.width || int(samplesy*spacing) != img.height){
		  println("Error in genFill: PImage dims do not match field");
		  return;
	  }
	  
	  img.loadPixels();
	  for (int y = 0; y < img.height; y++){
	  	  for (int x = 0; x < img.width; x++){
	  		  //grab 4 nearest data values for interpolation
	  		  int i0, j0, i1, j1;
	  		  float ax, ay;
  		  
	  		  float tmp = ((2.0*x+1.0)/(2*spacing)) - 0.5;//(x-(0.5*spacing))/spacing;//
	  		  i0 = floor(tmp);
	  		  i1 = ceil(tmp);
	  		  ax = tmp - i0;
  		  		  
	  		  tmp = ((2.0*((samplesy*spacing-1)-y)+1.0)/(2*spacing)) - 0.5;//note: 0,0 is bottom left //(((samplesy*spacing-1)-y)-(0.5*spacing))/spacing;//
	  		  j0 = floor(tmp);
	  		  j1 = ceil(tmp);
	  		  ay = tmp - j0;
		    		  
	  		  float v00, v01, v10, v11;
	  		  v00 = data.get(getIndex(constrain(i0,0,(samplesx-1)),constrain(j0,0,(samplesy-1)),samplesx));
	  		  v01 = data.get(getIndex(constrain(i0,0,(samplesx-1)),constrain(j1,0,(samplesy-1)),samplesx));
	  		  v10 = data.get(getIndex(constrain(i1,0,(samplesx-1)),constrain(j0,0,(samplesy-1)),samplesx));
	  		  v11 = data.get(getIndex(constrain(i1,0,(samplesx-1)),constrain(j1,0,(samplesy-1)),samplesx));
  		  
	  		  //bilinear interpolation
	  		  float v0x, v1x;
	  		  v0x = map(ax,0.0,1.0,v00,v10);
	  		  v1x = map(ax,0.0,1.0,v01,v11);
  		  
	  		  float v = map(ay,0.0,1.0,v0x,v1x);
			  color c = cmap.getColor(v, interpolate);
		    		  
	  		  img.pixels[getIndex(x,y,img.width)] = c; 
	  	  }
	  }
	  
	  
	  img.updatePixels();
  }
  
  //HACK! TODO make so does proper alpha belending rather than binary overwrite on non-zero alpha
  void genFillBilinear(PImage img, ColorMapf cmap, boolean interpolate, boolean overwriteClear){
	  
	  if (!dataAvailable) return;
	  
	  int samplesx = dimx;
	  int samplesy = dimy;
	  
	  if (int(samplesx*spacing) != img.width || int(samplesy*spacing) != img.height){
		  println("Error in genFill: PImage dims do not match field");
		  return;
	  }
	  
	  img.loadPixels();
	  for (int y = 0; y < img.height; y++){
	  	  for (int x = 0; x < img.width; x++){
	  		  //grab 4 nearest data values for interpolation
	  		  int i0, j0, i1, j1;
	  		  float ax, ay;
  		  
	  		  float tmp = ((2.0*x+1.0)/(2*spacing)) - 0.5;//(x-(0.5*spacing))/spacing;//
	  		  i0 = floor(tmp);
	  		  i1 = ceil(tmp);
	  		  ax = tmp - i0;
  		  		  
	  		  tmp = ((2.0*((samplesy*spacing-1)-y)+1.0)/(2*spacing)) - 0.5;//(((samplesy*spacing-1)-y)-(0.5*spacing))/spacing;//note: 0,0 is bottom left
	  		  j0 = floor(tmp);
	  		  j1 = ceil(tmp);
	  		  ay = tmp - j0;
		    		  
	  		  float v00, v01, v10, v11;
	  		  v00 = data.get(getIndex(constrain(i0,0,(samplesx-1)),constrain(j0,0,(samplesy-1)),samplesx));
	  		  v01 = data.get(getIndex(constrain(i0,0,(samplesx-1)),constrain(j1,0,(samplesy-1)),samplesx));
	  		  v10 = data.get(getIndex(constrain(i1,0,(samplesx-1)),constrain(j0,0,(samplesy-1)),samplesx));
	  		  v11 = data.get(getIndex(constrain(i1,0,(samplesx-1)),constrain(j1,0,(samplesy-1)),samplesx));
  		  
	  		  //bilinear interpolation
	  		  float v0x, v1x;
	  		  v0x = map(ax,0.0,1.0,v00,v10);
	  		  v1x = map(ax,0.0,1.0,v01,v11);
  		  
	  		  float v = map(ay,0.0,1.0,v0x,v1x);
			  color c = cmap.getColor(v, interpolate);
			  
			  if (overwriteClear || (((c >> 24) & 0xFF) > 0)) img.pixels[getIndex(x,y,img.width)] = c; 
	  	  }
	  }
	  img.updatePixels();
  }
  
  //TODO may want to generalize to other operations
  void genMaskBilinear(boolean[] union, boolean[] intersection, int w, int h, float isovalue){	  
	  if (!dataAvailable) return;
	  
	  int n = w*h;
	  if ((int(dimx*spacing) != w) || (int(dimy*spacing) != h) || (union.length != n) || (intersection.length != n)){
		  println("Error in genMask: input array dims do not match field");
		  println("\t" + w + "\t"+ h);
		  println("\t" + dimx*spacing + "\t"+ dimy*spacing);
		  println("\t" + n);
		  println("\t" + union.length + "\t"+ intersection.length);
		  return;
	  }
	  
	  int idx;
	  for (int y = 0; y < h; y++){
	  	  for (int x = 0; x < w; x++){
			  
			  idx = getIndex(x,y,w);
			  if ((union[idx] == true) && (intersection[idx] == false)) continue; //new value has no effect
			  
	  		  //grab 4 nearest data values for interpolation
	  		  int i, i0, j0, i1, j1;
	  		  float ax, ay;
  		  
	  		  float tmp = (x+0.5)/spacing - 0.5;//((2.0*x+1.0)/(2*spacing)) - 0.5;
	  		  i = floor(tmp);
			  i0 = constrain(i,0,(dimx-1));
	  		  i1 = constrain(i+1,0,(dimx-1));
	  		  ax = tmp - i0;
  		  		  
	  		  tmp = (h-y-0.5)/spacing - 0.5;//note: 0,0 is bottom left
	  		  i = floor(tmp);
			  j0 = constrain(i,0,(dimy-1));
	  		  j1 = constrain(i+1,0,(dimy-1));
	  		  ay = tmp - j0;
		    		  
	  		  float v00, v01, v10, v11;
			  i = getIndex(i0,j0,dimx);
	  		  v00 = data.get(i);
	  		  v10 = data.get(i+1);
			  i = getIndex(i0,j1,dimx);
	  		  v01 = data.get(i);
	  		  v11 = data.get(i+1);
			  
	  		  //bilinear interpolation
	  		  float v = map(ay,0.0,1.0,map(ax,0.0,1.0,v00,v10),map(ax,0.0,1.0,v01,v11));			  
			  boolean pass = (v > isovalue);
			  
			  if (pass) union[idx] = pass;
			  else intersection[idx] = pass; 			  
	  	  }
	  }
	  	  
  }
  
  void genMaskBilinear(BitSet union, BitSet intersection, int w, int h, float isovalue){	  
	  if (!dataAvailable) return;
	  
	  int n = w*h;
	  if ((int(dimx*spacing) != w) || (int(dimy*spacing) != h)){
		  println("Error in genMask: dimensions wrong");
		  println("\t" + w + "\t"+ h);
		  println("\t" + dimx*spacing + "\t"+ dimy*spacing);
		  return;
	  }
	  
	  for (int y = 0; y < h; y++){
	  	  for (int x = 0; x < w; x++){
			  
			  int idx = getIndex(x,y,w);
			  if ((union.get(idx)) && (!intersection.get(idx))) continue; //new value has no effect
			  
	  		  //grab 4 nearest data values for interpolation
	  		  int i0, j0, i1, j1;
	  		  float ax, ay;
  		  
	  		  float tmp = ((2.0*x+1.0)/(2*spacing)) - 0.5;//(x-(0.5*spacing))/spacing;//
	  		  i0 = floor(tmp);
	  		  i1 = ceil(tmp);
	  		  ax = tmp - i0;
  		  		  
	  		  tmp = ((2.0*((dimy*spacing-1)-y)+1.0)/(2*spacing)) - 0.5;//(((dimy*spacing-1)-y)-(0.5*spacing))/spacing;//note: 0,0 is bottom left
	  		  j0 = floor(tmp);
	  		  j1 = ceil(tmp);
	  		  ay = tmp - j0;
		    		  
	  		  float v00, v01, v10, v11;
	  		  v00 = data.get(getIndex(constrain(i0,0,(dimx-1)),constrain(j0,0,(dimy-1)),dimx));
	  		  v01 = data.get(getIndex(constrain(i0,0,(dimx-1)),constrain(j1,0,(dimy-1)),dimx));
	  		  v10 = data.get(getIndex(constrain(i1,0,(dimx-1)),constrain(j0,0,(dimy-1)),dimx));
	  		  v11 = data.get(getIndex(constrain(i1,0,(dimx-1)),constrain(j1,0,(dimy-1)),dimx));
  		  
	  		  //bilinear interpolation
	  		  float v0x, v1x;
	  		  v0x = map(ax,0.0,1.0,v00,v10);
	  		  v1x = map(ax,0.0,1.0,v01,v11);
  		  
	  		  float v = map(ay,0.0,1.0,v0x,v1x);
			  boolean pass = (v > isovalue);
			  
			  if (pass) union.set(idx,pass);
			  else intersection.set(idx,pass); 
			  
	  	  }
	  }
	  	  
  }
  
  void genMaskBilinear(BitSet mask, int w, int h, float isovalue){
	  int n = w*h;
	  boolean[] bmask = new boolean[n];
	  if ((int(dimx*spacing) != w) || (int(dimy*spacing) != h)){
		  println("Error in genMask: dimensions wrong");
		  println("\t" + w + "\t"+ h);
		  println("\t" + dimx*spacing + "\t"+ dimy*spacing);
		  return;
	  }
	  
	  int idx;
	  for (int y = 0; y < h; y++){
	  	  for (int x = 0; x < w; x++){
			  idx = getIndex(x,y,w);
			    
	  		  //grab 4 nearest data values for interpolation
	  		  int i, i0, j0, i1, j1;
	  		  float ax, ay;
  		  
	  		  float tmp = (x+0.5)/spacing - 0.5;//((2.0*x+1.0)/(2*spacing)) - 0.5;
	  		  i = floor(tmp);
			  i0 = constrain(i,0,(dimx-1));
	  		  i1 = constrain(i+1,0,(dimx-1));
	  		  ax = tmp - i0;
  		  		  
	  		  tmp = (h-y-0.5)/spacing - 0.5;//note: 0,0 is bottom left
	  		  i = floor(tmp);
			  j0 = constrain(i,0,(dimy-1));
	  		  j1 = constrain(i+1,0,(dimy-1));
	  		  ay = tmp - j0;
		    		  
	  		  float v00, v01, v10, v11;
			  i = getIndex(i0,j0,dimx);
	  		  v00 = data.get(i);
	  		  v10 = data.get(i+1);
			  i = getIndex(i0,j1,dimx);
	  		  v01 = data.get(i);
	  		  v11 = data.get(i+1);
  		  
	  		  //bilinear interpolation  		  
	  		  float v = map(ay,0.0,1.0,map(ax,0.0,1.0,v00,v10),map(ax,0.0,1.0,v01,v11));
			  bmask[idx]=(v > isovalue);
	  	  }
	  }
	  
	  for (int i=0; i < n; i++){
		mask.set(i,bmask[i]);
	  }
	  
  }  
  
	void test_multiplyProb(Field f){ // NOTE: is cannibalistic
		if (!dataAvailable || (dimx != f.dimx) || (dimy != f.dimy) || (data.size() != (f.data).size())){
			println("TEST_MultiplyProb FAILED: fields not compatible -- dimensions off or data missing");
			return;
		}

		for (int i = 0; i < data.size(); i++){
			float a = data.get(i)/100.0;
			float b = (f.data).get(i)/100.0;
			data.set(i, round((a * b)*100));
		}
	}
  
  private int getIndex(int x, int y, int N)
  {
     return (y*N)+x;
  }
  
  
    
}
