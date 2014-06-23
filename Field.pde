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
  
  Field(String file, int dx, int dy, PVector offset, float maxh, float maxw){ // expects 1 value per line (!) no commas, no lat / long
	
	dimx = dx;
    dimy = dy;
    //spacing = s;
    //buffer = buf;
    viewZero = offset;
    
    spacing = min(maxh/dy, maxw/dx);
    viewHeight = dy*spacing;
    viewWidth = dx*spacing;
    
    data = new FloatList();
    
    // read data from file
    String[] lines = loadStrings(file);
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
  
  Field(FloatList d, float vmax, float vmin, int dx, int dy, PVector offset, float s){ 
	  
	dimx = dx;
    dimy = dy;
    viewZero = offset;
    
    spacing = s;
    viewHeight = dy*spacing;
    viewWidth = dx*spacing;
    
    data = d;
	maxVal = vmax;
	minVal = vmin;
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
  
//   void drawIsocontour(float iso){
//     float incrY = spacing; // regular spacing of points assuming regular grid
//     float incrX = spacing; //      -- [TODO] not appropriate for lat/long
//       
//     for (int j=0; j < dimy; j++){ //simulte 2D array
//       for (int i=0; i < dimx; i++) {
//         
//         /* MARCHING SQUARES
//         *
//         *   runs on grid cells
//         *   assume "cell" in grid defined s.t.
//         *   current point is bottom left corner (0,0)
//         *
//         *          1,0 ---- 1,1
//         *           |        |
//         *           |        |
//         *          0,0 ---- 0,1
//         *
//         *   a good summary of the algorithm details can be found at:
//         *         http://en.wikipedia.org/wiki/Marching_squares
//         *
//         */
//         
//         if ((i == (dimx-1)) || (j == (dimy-1))) continue; //ignore far edges, no such cell defined
//         
//         // get current cell
//         int idx = (j*dimx)+i;
//         float val00 = data.get(idx);             
//         float val01 = data.get(idx+1);
//         float val10 = data.get(idx+dimx);
//         float val11 = data.get(idx+dimx+1);
//         
//         // again, assuming regular grid --  [TODO] not appropriate for lat/long
//         // PVector val00Pos = new PVector (((i+0.0)*incrX)+viewZero.x, viewZero.y+viewHeight-((j+0.0)*incrY)); 
//         // PVector val01Pos = new PVector (((i+1.0)*incrX)+viewZero.x, viewZero.y+viewHeight-((j+0.0)*incrY));
//         // PVector val10Pos = new PVector (((i+0.0)*incrX)+viewZero.x, viewZero.y+viewHeight-((j+1.0)*incrY));
//         // PVector val11Pos = new PVector (((i+1.0)*incrX)+viewZero.x, viewZero.y+viewHeight-((j+1.0)*incrY));
// 		PVector val00Pos = new PVector (round(((i+0.0)*incrX)+viewZero.x), round(viewZero.y+viewHeight-((j+0.0)*incrY))); 
// 		PVector val01Pos = new PVector (round(((i+1.0)*incrX)+viewZero.x), round(viewZero.y+viewHeight-((j+0.0)*incrY)));
// 		PVector val10Pos = new PVector (round(((i+0.0)*incrX)+viewZero.x), round(viewZero.y+viewHeight-((j+1.0)*incrY)));
// 		PVector val11Pos = new PVector (round(((i+1.0)*incrX)+viewZero.x), round(viewZero.y+viewHeight-((j+1.0)*incrY)));
//         
//         // runs 4 binary checks - create 'case' number from resulting binary string
//         int b = (int(val10 >= iso) << 3) + (int(val11 >= iso) << 2) + (int(val01 >= iso) << 1) + (int(val00 >= iso));
//         
//         // draw contour edges based on case
//         /* note: fill requires definition of inside/outside,  *
//          *       which we are ignoring for isocontouring      */
//         float p1, p2;
//         switch (b) {
//           case 1:
//           case 14:
//             p1 = map(iso, val00, val10, val10Pos.y, val00Pos.y);
//             p2 = map(iso, val00, val01, val00Pos.x, val01Pos.x);
//             line(val00Pos.x, p1, p2, val00Pos.y);
//             break;
//           case 2:
//           case 13:
//             p1 = map(iso, val01, val11, val11Pos.y, val01Pos.y);
//             p2 = map(iso, val00, val01, val00Pos.x, val01Pos.x);
//             line(val01Pos.x, p1, p2, val01Pos.y);
//             break;
//           case 3:
//           case 12:
//             p1 = map(iso, val00, val10, val10Pos.y, val00Pos.y);
//             p2 = map(iso, val01, val11, val11Pos.y, val01Pos.y);
//             line(val00Pos.x, p1, val01Pos.x, p2);
//             break;
//           case 4:
//           case 11:
//             p1 = map(iso, val10, val11, val10Pos.x, val11Pos.x);
//             p2 = map(iso, val01, val11, val11Pos.y, val01Pos.y);
//             line(p1, val11Pos.y, val11Pos.x, p2);
//             break;
//           case 6:
//           case 9:
//             p1 = map(iso, val10, val11, val10Pos.x, val11Pos.x);
//             p2 = map(iso, val00, val01, val00Pos.x, val01Pos.x);
//             line(p1, val10Pos.y, p2, val00Pos.y);
//             break;
//           case 7:
//           case 8:
//             p1 = map(iso, val00, val10, val10Pos.y, val00Pos.y);
//             p2 = map(iso, val10, val11, val10Pos.x, val11Pos.x);
//             line(val00Pos.x, p1, p2, val10Pos.y);
//             break;
//           case 5:
//             /* ambiguous / saddle case
//              *   resolve according to "central" value, calculated as average of 4 corners
//              */                        
//             if (((val00 + val01 + val10 + val11)/4.0) >= iso) {
//               p1 = map(iso, val00, val10, val10Pos.y, val00Pos.y);
//               p2 = map(iso, val10, val11, val10Pos.x, val11Pos.x);
//               line(val00Pos.x, p1, p2, val10Pos.y);
//               
//               p1 = map(iso, val01, val11, val11Pos.y, val01Pos.y);
//               p2 = map(iso, val00, val01, val00Pos.x, val01Pos.x);
//               line(val01Pos.x, p1, p2, val01Pos.y);
//             }
//             else {
//               p1 = map(iso, val00, val10, val10Pos.y, val00Pos.y);
//               p2 = map(iso, val00, val01, val00Pos.x, val01Pos.x);
//               line(val00Pos.x, p1, p2, val00Pos.y);
//               
//               p1 = map(iso, val10, val11, val10Pos.x, val11Pos.x);
//               p2 = map(iso, val01, val11, val11Pos.y, val01Pos.y);
//               line(p1, val11Pos.y, val11Pos.x, p2);
//             }
//             break;
//           case 10:
//             /* ambiguous / saddle case
//              *   resolve according to "central" value, calculated as average of 4 corners
//              */
//             if (((val00 + val01 + val10 + val11)/4.0) >= iso) {
//               p1 = map(iso, val00, val10, val10Pos.y, val00Pos.y);
//               p2 = map(iso, val00, val01, val00Pos.x, val01Pos.x);
//               line(val00Pos.x, p1, p2, val00Pos.y);
//               
//               p1 = map(iso, val10, val11, val10Pos.x, val11Pos.x);
//               p2 = map(iso, val01, val11, val11Pos.y, val01Pos.y);
//               line(p1, val11Pos.y, val11Pos.x, p2);
//             }
//             else {
//               p1 = map(iso, val00, val10, val10Pos.y, val00Pos.y);
//               p2 = map(iso, val10, val11, val10Pos.x, val11Pos.x);
//               line(val00Pos.x, p1, p2, val10Pos.y);
//               
//               p1 = map(iso, val01, val11, val11Pos.y, val01Pos.y);
//               p2 = map(iso, val00, val01, val00Pos.x, val01Pos.x);
//               line(val01Pos.x, p1, p2, val01Pos.y);
//             }
//             break;
//           case 0:    // no edges
//           case 15:   
//           default:
//             break;
//         }
//                     
//       }
//     }
//   }
//   
//   void drawFilledContour(float iso, boolean fillBelow){ // here height should be window height -- undefined behavior if window height not defined as expected in relation to spacing / buffer
//     float incrY = spacing; // regular spacing of points assuming regular grid
//     float incrX = spacing; //      -- [TODO] not appropriate for lat/long
//       
//     for (int j=0; j < dimy; j++){ //simulte 2D array
//       for (int i=0; i < dimx; i++) {
//         
//         /* MARCHING SQUARES
//         *
//         *   runs on grid cells
//         *   assume "cell" in grid defined s.t.
//         *   current point is bottom left corner (0,0)
//         *
//         *          1,0 ---- 1,1
//         *           |        |
//         *           |        |
//         *          0,0 ---- 0,1
//         *
//         *   a good summary of the algorithm details can be found at:
//         *         http://en.wikipedia.org/wiki/Marching_squares
//         *
//         */
//         
//         if ((i == (dimx-1)) || (j == (dimy-1))) continue; //ignore far edges, no such cell defined
//         
//         // get current cell
//         int idx = (j*dimx)+i;
//         float val00 = data.get(idx);             
//         float val01 = data.get(idx+1);
//         float val10 = data.get(idx+dimx);
//         float val11 = data.get(idx+dimx+1);
//         
//         // again, assuming regular grid --  [TODO] not appropriate for lat/long
//         // PVector val00Pos = new PVector (((i+0.5)*incrX)+viewZero.x, viewZero.y+viewHeight-((j+0.5)*incrY)); 
// //         PVector val01Pos = new PVector (((i+1.5)*incrX)+viewZero.x, viewZero.y+viewHeight-((j+0.5)*incrY));
// //         PVector val10Pos = new PVector (((i+0.5)*incrX)+viewZero.x, viewZero.y+viewHeight-((j+1.5)*incrY));
// //         PVector val11Pos = new PVector (((i+1.5)*incrX)+viewZero.x, viewZero.y+viewHeight-((j+1.5)*incrY));
// 		
//         PVector val00Pos = new PVector (round(((i+0.0)*incrX)+viewZero.x), round(viewZero.y+viewHeight-((j+0.0)*incrY))); 
//         PVector val01Pos = new PVector (round(((i+1.0)*incrX)+viewZero.x), round(viewZero.y+viewHeight-((j+0.0)*incrY)));
//         PVector val10Pos = new PVector (round(((i+0.0)*incrX)+viewZero.x), round(viewZero.y+viewHeight-((j+1.0)*incrY)));
//         PVector val11Pos = new PVector (round(((i+1.0)*incrX)+viewZero.x), round(viewZero.y+viewHeight-((j+1.0)*incrY)));
//         
//         // runs 4 binary checks - create 'case' number from resulting binary string 
//         int b = (int(val10 >= iso) << 3) + (int(val11 >= iso) << 2) + (int(val01 >= iso) << 1) + (int(val00 >= iso));
//         
// 		//TODO code smarter version: include fillBelow in case #, and combine cases properly
// 		//TODO CONSIDER -- playing fast/loose with equivalences like val00Pos.x = val10Pos.x might not hold when transfer to lat long
// 		
//         // draw fill based on case
//         /* note: fill requires definition of inside/outside,  *
//          *       which we are ignoring for isocontouring      */
//         float p1, p2, p3, p4;
//         switch (b) {
//           case 1:
// 	        p1 = map(iso, val00, val10, val10Pos.y, val00Pos.y);
// 	        p2 = map(iso, val00, val01, val00Pos.x, val01Pos.x);
// 	        //line(val00Pos.x, p1, p2, val00Pos.y);
// 			if (fillBelow){
// 			  quad(val10Pos.x, val10Pos.y, val01Pos.x, val01Pos.y, p2, val00Pos.y, val00Pos.x, p1);
// 			  triangle(val10Pos.x, val10Pos.y, val01Pos.x, val01Pos.y, val11Pos.x, val11Pos.y);
// 			}
// 			else{
// 			  triangle(p2, val00Pos.y, val00Pos.x, p1, val00Pos.x, val00Pos.y);
// 			}
// 	        break;
//           case 14:
//             p1 = map(iso, val00, val10, val10Pos.y, val00Pos.y);
//             p2 = map(iso, val00, val01, val00Pos.x, val01Pos.x);
//             //line(val00Pos.x, p1, p2, val00Pos.y);
// 			if (fillBelow){
// 			  triangle(p2, val00Pos.y, val00Pos.x, p1, val00Pos.x, val00Pos.y);
// 			}
// 			else{
//   			  quad(val10Pos.x, val10Pos.y, val01Pos.x, val01Pos.y, p2, val00Pos.y, val00Pos.x, p1);
//   			  triangle(val10Pos.x, val10Pos.y, val01Pos.x, val01Pos.y, val11Pos.x, val11Pos.y);
// 			}
//             break;
//           case 2:
// 	        p1 = map(iso, val01, val11, val11Pos.y, val01Pos.y);
// 	        p2 = map(iso, val00, val01, val00Pos.x, val01Pos.x);
// 	        //line(val01Pos.x, p1, p2, val01Pos.y);
// 			if(fillBelow){
// 			  quad(val11Pos.x, val11Pos.y, val01Pos.x, p1, p2, val01Pos.y, val00Pos.x, val00Pos.y);
// 			  triangle(val10Pos.x, val10Pos.y, val11Pos.x, val11Pos.y, val00Pos.x, val00Pos.y);
// 			}
// 			else{
// 				triangle(val01Pos.x, p1, p2, val01Pos.y, val01Pos.x, val01Pos.y);
// 			}
// 	        break;
//           case 13:
//             p1 = map(iso, val01, val11, val11Pos.y, val01Pos.y);
//             p2 = map(iso, val00, val01, val00Pos.x, val01Pos.x);
//             //line(val01Pos.x, p1, p2, val01Pos.y);
// 			if(fillBelow){
// 			  triangle(val01Pos.x, p1, p2, val01Pos.y, val01Pos.x, val01Pos.y);
// 			}
// 			else{
//   			  quad(val11Pos.x, val11Pos.y, val01Pos.x, p1, p2, val01Pos.y, val00Pos.x, val00Pos.y);
//   			  triangle(val10Pos.x, val10Pos.y, val11Pos.x, val11Pos.y, val00Pos.x, val00Pos.y);
// 			}
// 	        break;
//           case 3:
//             p1 = map(iso, val00, val10, val10Pos.y, val00Pos.y);
//             p2 = map(iso, val01, val11, val11Pos.y, val01Pos.y);
//             //line(val00Pos.x, p1, val01Pos.x, p2);
// 			if(fillBelow){
// 			  quad(val00Pos.x, p1, val01Pos.x, p2, val11Pos.x, val11Pos.y, val10Pos.x, val10Pos.y);
// 			}
// 			else{
// 			  quad(val00Pos.x, p1, val01Pos.x, p2, val01Pos.x, val01Pos.y, val00Pos.x, val00Pos.y);
// 			}
//           break;
//           case 12:
//             p1 = map(iso, val00, val10, val10Pos.y, val00Pos.y);
//             p2 = map(iso, val01, val11, val11Pos.y, val01Pos.y);
//             //line(val00Pos.x, p1, val01Pos.x, p2);
// 			if(fillBelow){
//   			  quad(val00Pos.x, p1, val01Pos.x, p2, val01Pos.x, val01Pos.y, val00Pos.x, val00Pos.y);
// 			}
// 			else{
// 			  quad(val00Pos.x, p1, val01Pos.x, p2, val11Pos.x, val11Pos.y, val10Pos.x, val10Pos.y);
// 			}
//             break;
//           case 4:
//             p1 = map(iso, val10, val11, val10Pos.x, val11Pos.x);
//             p2 = map(iso, val01, val11, val11Pos.y, val01Pos.y);
//             //line(p1, val11Pos.y, val11Pos.x, p2);
// 			if(fillBelow){
// 			  quad(val10Pos.x, val10Pos.y, p1, val11Pos.y, val11Pos.x, p2, val01Pos.x, val01Pos.y);
// 			  triangle(val00Pos.x, val00Pos.y, val10Pos.x, val10Pos.y, val01Pos.x, val01Pos.y);
// 			}
// 			else{
// 			  triangle(p1, val11Pos.y, val11Pos.x, p2, val11Pos.x, val11Pos.y);
// 			}
//             break;
//           case 11:
//             p1 = map(iso, val10, val11, val10Pos.x, val11Pos.x);
//             p2 = map(iso, val01, val11, val11Pos.y, val01Pos.y);
//             //line(p1, val11Pos.y, val11Pos.x, p2);
// 			if(fillBelow){
// 			  triangle(p1, val11Pos.y, val11Pos.x, p2, val11Pos.x, val11Pos.y);
// 			}
// 			else{
//   			  quad(val10Pos.x, val10Pos.y, p1, val11Pos.y, val11Pos.x, p2, val01Pos.x, val01Pos.y);
//   			  triangle(val00Pos.x, val00Pos.y, val10Pos.x, val10Pos.y, val01Pos.x, val01Pos.y);
// 			}
//             break;
//           case 6:
//             p1 = map(iso, val10, val11, val10Pos.x, val11Pos.x);
//             p2 = map(iso, val00, val01, val00Pos.x, val01Pos.x);
//             //line(p1, val10Pos.y, p2, val00Pos.y);
// 		    if (fillBelow){
// 			  quad(p1, val10Pos.y, val10Pos.x, val10Pos.y, val00Pos.x, val00Pos.y, p2, val00Pos.y);
// 		    }
// 		    else{
// 			  quad(p1, val10Pos.y, val11Pos.x, val11Pos.y, val01Pos.x, val01Pos.y, p2, val00Pos.y);
// 		    }
//           break;
//           case 9:
//             p1 = map(iso, val10, val11, val10Pos.x, val11Pos.x);
//             p2 = map(iso, val00, val01, val00Pos.x, val01Pos.x);
//             //line(p1, val10Pos.y, p2, val00Pos.y);
// 			if (fillBelow){
// 			  quad(p1, val10Pos.y, val11Pos.x, val11Pos.y, val01Pos.x, val01Pos.y, p2, val00Pos.y);
// 			}
// 			else{
// 			  quad(p1, val10Pos.y, val10Pos.x, val10Pos.y, val00Pos.x, val00Pos.y, p2, val00Pos.y);
// 			}
//             break;
//           case 7:
//             p1 = map(iso, val00, val10, val10Pos.y, val00Pos.y);
//             p2 = map(iso, val10, val11, val10Pos.x, val11Pos.x);
//             //line(val00Pos.x, p1, p2, val10Pos.y);
// 		    if (fillBelow){
// 			  triangle(val10Pos.x, p1, p2, val10Pos.y, val10Pos.x, val10Pos.y);
// 		    }
// 		    else{
// 			  quad(val11Pos.x, val11Pos.y, val00Pos.x, val00Pos.y, val00Pos.x, p1, p2, val10Pos.y);
// 			  triangle(val11Pos.x, val11Pos.y, val00Pos.x, val00Pos.y, val01Pos.x, val01Pos.y);
// 		    }
//           break;
//           case 8:
//             p1 = map(iso, val00, val10, val10Pos.y, val00Pos.y);
//             p2 = map(iso, val10, val11, val10Pos.x, val11Pos.x);
//             //line(val00Pos.x, p1, p2, val10Pos.y);
// 			if (fillBelow){
// 			  quad(val11Pos.x, val11Pos.y, val00Pos.x, val00Pos.y, val00Pos.x, p1, p2, val10Pos.y);
//   			  triangle(val11Pos.x, val11Pos.y, val00Pos.x, val00Pos.y, val01Pos.x, val01Pos.y);
// 			}
// 			else{
//   			  triangle(val10Pos.x, p1, p2, val10Pos.y, val10Pos.x, val10Pos.y);
// 			}
//             break;
//           case 5:
//             /* ambiguous / saddle case
//              *   resolve according to "central" value, calculated as average of 4 corners
//              */                        
//             if (((val00 + val01 + val10 + val11)/4.0) >= iso) {
//               p1 = map(iso, val00, val10, val10Pos.y, val00Pos.y);
//               p2 = map(iso, val10, val11, val10Pos.x, val11Pos.x);
//               p3 = map(iso, val01, val11, val11Pos.y, val01Pos.y);
//               p4 = map(iso, val00, val01, val00Pos.x, val01Pos.x);
//               //line(val01Pos.x, p3, p4, val01Pos.y);
//               //line(val00Pos.x, p1, p2, val10Pos.y);
// 			  if (fillBelow){
//   			  	triangle(val01Pos.x, p3, p4, val01Pos.y, val01Pos.x, val01Pos.y);
//   				triangle(val10Pos.x, p1, p2, val10Pos.y, val10Pos.x, val10Pos.y);
// 			  }
// 			  else{
//   				triangle(p2, val10Pos.y, val11Pos.x, p3, val11Pos.x, val11Pos.y);
//   				quad(p2, val11Pos.y, val11Pos.x, p3, p4, val00Pos.y, val00Pos.x, p1);
//   				triangle(p4, val00Pos.y, val00Pos.x, p1, val00Pos.x, val00Pos.y);
// 			  }
//             }
//             else {
//               p1 = map(iso, val00, val10, val10Pos.y, val00Pos.y);
//               p2 = map(iso, val00, val01, val00Pos.x, val01Pos.x);
//               p3 = map(iso, val10, val11, val10Pos.x, val11Pos.x);
//               p4 = map(iso, val01, val11, val11Pos.y, val01Pos.y);
//               //line(p3, val11Pos.y, val11Pos.x, p4);
// 			  //line(val00Pos.x, p1, p2, val00Pos.y);
// 			  if (fillBelow){
//   				triangle(val10Pos.x, p1, p3, val10Pos.y, val10Pos.x, val10Pos.y);
//   				quad(val10Pos.x, p1, p3, val11Pos.y, val11Pos.x, p4, p2, val01Pos.y);
//   				triangle(val01Pos.x, p4, p2, val01Pos.y, val01Pos.x, val01Pos.y);
// 			  }
// 			  else{
//   				triangle(val00Pos.x, p1, p2, val00Pos.y, val00Pos.x, val00Pos.y);
//   				triangle(p3, val11Pos.y, val11Pos.x, p4, val11Pos.x, val11Pos.y);
// 			  }
//             }
//             break;
//           case 10:
//             /* ambiguous / saddle case
//              *   resolve according to "central" value, calculated as average of 4 corners
//              */
//             if (((val00 + val01 + val10 + val11)/4.0) >= iso) {
//               p1 = map(iso, val00, val10, val10Pos.y, val00Pos.y);
//               p2 = map(iso, val00, val01, val00Pos.x, val01Pos.x);
//               p3 = map(iso, val10, val11, val10Pos.x, val11Pos.x);
//               p4 = map(iso, val01, val11, val11Pos.y, val01Pos.y);
// 			  //line(val00Pos.x, p1, p2, val00Pos.y);
//               //line(p3, val11Pos.y, val11Pos.x, p4);
// 			  if (fillBelow){
// 				triangle(val00Pos.x, p1, p2, val00Pos.y, val00Pos.x, val00Pos.y);
// 				triangle(p3, val11Pos.y, val11Pos.x, p4, val11Pos.x, val11Pos.y);
// 			  }
// 			  else{
// 				triangle(val10Pos.x, p1, p3, val10Pos.y, val10Pos.x, val10Pos.y);
// 				quad(val10Pos.x, p1, p3, val11Pos.y, val11Pos.x, p4, p2, val01Pos.y);
// 				triangle(val01Pos.x, p4, p2, val01Pos.y, val01Pos.x, val01Pos.y);
// 			  }
//             }
//             else {
//               p1 = map(iso, val00, val10, val10Pos.y, val00Pos.y);
//               p2 = map(iso, val10, val11, val10Pos.x, val11Pos.x);
//               p3 = map(iso, val01, val11, val11Pos.y, val01Pos.y);
//               p4 = map(iso, val00, val01, val00Pos.x, val01Pos.x);
//               //line(val01Pos.x, p3, p4, val01Pos.y);
// 			  //line(val00Pos.x, p1, p2, val10Pos.y);
// 			  if (fillBelow){
// 				triangle(p2, val10Pos.y, val11Pos.x, p3, val11Pos.x, val11Pos.y);
// 				quad(p2, val11Pos.y, val11Pos.x, p3, p4, val00Pos.y, val00Pos.x, p1);
// 				triangle(p4, val00Pos.y, val00Pos.x, p1, val00Pos.x, val00Pos.y);
// 			  }
// 			  else{
// 			  	triangle(val01Pos.x, p3, p4, val01Pos.y, val01Pos.x, val01Pos.y);
// 				triangle(val10Pos.x, p1, p2, val10Pos.y, val10Pos.x, val10Pos.y);
// 			  }
//             }
//             break;
//           case 0: // all below
// 		    if (fillBelow) quad(val10Pos.x, val10Pos.y, val11Pos.x, val11Pos.y, val01Pos.x, val01Pos.y, val00Pos.x, val00Pos.y);
// 		    break;
//           case 15: // all above
// 		  	if (!fillBelow) quad(val10Pos.x, val10Pos.y, val11Pos.x, val11Pos.y, val01Pos.x, val01Pos.y, val00Pos.x, val00Pos.y);
// 		    break;
//           default:
//             break;
//         }
//                     
//       }
//     }
//   }
//   
  void genIsocontour(float iso, Contour2D contour){ 
	
    float incrY = spacing; // regular spacing of points assuming regular grid
    float incrX = spacing; //      -- [TODO] not appropriate for lat/long
      
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
        
        // again, assuming regular grid --  [TODO] not appropriate for lat/long
        // PVector val00Pos = new PVector (((i+0.0)*incrX)+viewZero.x, viewZero.y+viewHeight-((j+0.0)*incrY)); 
        // PVector val01Pos = new PVector (((i+1.0)*incrX)+viewZero.x, viewZero.y+viewHeight-((j+0.0)*incrY));
        // PVector val10Pos = new PVector (((i+0.0)*incrX)+viewZero.x, viewZero.y+viewHeight-((j+1.0)*incrY));
        // PVector val11Pos = new PVector (((i+1.0)*incrX)+viewZero.x, viewZero.y+viewHeight-((j+1.0)*incrY));
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
		Segment2D s;
        switch (b) {
          case 1:
          case 14:
            p1 = map(iso, val00, val10, val00Pos.y, val10Pos.y);
            p2 = map(iso, val00, val01, val00Pos.x, val01Pos.x);
			s = new Segment2D(new PVector(val00Pos.x, p1), new PVector(p2, val00Pos.y));
			contour.addSegment(s);
            break;
          case 2:
          case 13:
            p1 = map(iso, val01, val11, val01Pos.y, val11Pos.y);
            p2 = map(iso, val00, val01, val00Pos.x, val01Pos.x);
			s = new Segment2D(new PVector(val01Pos.x, p1), new PVector(p2, val01Pos.y));
			contour.addSegment(s);
            break;
          case 3:
          case 12:
            p1 = map(iso, val00, val10, val00Pos.y, val10Pos.y);
            p2 = map(iso, val01, val11, val01Pos.y, val11Pos.y);
			s = new Segment2D(new PVector(val00Pos.x, p1), new PVector(val01Pos.x, p2));
			contour.addSegment(s);
            break;
          case 4:
          case 11:
            p1 = map(iso, val10, val11, val10Pos.x, val11Pos.x);
            p2 = map(iso, val01, val11, val01Pos.y, val11Pos.y);
			s = new Segment2D(new PVector(p1, val11Pos.y), new PVector(val11Pos.x, p2));
			contour.addSegment(s);
            break;
          case 6:
          case 9:
            p1 = map(iso, val10, val11, val10Pos.x, val11Pos.x);
            p2 = map(iso, val00, val01, val00Pos.x, val01Pos.x);
			s = new Segment2D(new PVector(p1, val10Pos.y), new PVector(p2, val00Pos.y));
			contour.addSegment(s);
            break;
          case 7:
          case 8:
            p1 = map(iso, val00, val10, val00Pos.y, val10Pos.y);
            p2 = map(iso, val10, val11, val10Pos.x, val11Pos.x);
			s = new Segment2D(new PVector(val00Pos.x, p1), new PVector(p2, val10Pos.y));
			contour.addSegment(s);
            break;
          case 5:
            /* ambiguous / saddle case
             *   resolve according to "central" value, calculated as average of 4 corners
             */                        
            if (((val00 + val01 + val10 + val11)/4.0) >= iso) {
              p1 = map(iso, val00, val10, val00Pos.y, val10Pos.y);
              p2 = map(iso, val10, val11, val10Pos.x, val11Pos.x);
  			  s = new Segment2D(new PVector(val00Pos.x, p1), new PVector(p2, val10Pos.y));
  			  contour.addSegment(s);
			  
              p1 = map(iso, val01, val11, val01Pos.y, val11Pos.y);
              p2 = map(iso, val00, val01, val00Pos.x, val01Pos.x);
  			  s = new Segment2D(new PVector(val01Pos.x, p1), new PVector(p2, val01Pos.y));
  			  contour.addSegment(s);
            }
            else {
              p1 = map(iso, val00, val10, val00Pos.y, val10Pos.y);
              p2 = map(iso, val00, val01, val00Pos.x, val01Pos.x);
  			  s = new Segment2D(new PVector(val00Pos.x, p1), new PVector(p2, val00Pos.y));
  			  contour.addSegment(s);
			  
              p1 = map(iso, val10, val11, val10Pos.x, val11Pos.x);
              p2 = map(iso, val01, val11, val01Pos.y, val11Pos.y);
  			  s = new Segment2D(new PVector(p1, val11Pos.y), new PVector(val11Pos.x, p2));
  			  contour.addSegment(s);
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
  			  contour.addSegment(s);
			  
              p1 = map(iso, val10, val11, val10Pos.x, val11Pos.x);
              p2 = map(iso, val01, val11, val01Pos.y, val11Pos.y);
  			  s = new Segment2D(new PVector(p1, val11Pos.y), new PVector(val11Pos.x, p2));
  			  contour.addSegment(s);
            }
            else {
              p1 = map(iso, val00, val10, val00Pos.y, val10Pos.y);
              p2 = map(iso, val10, val11, val10Pos.x, val11Pos.x);
  			  s = new Segment2D(new PVector(val00Pos.x, p1), new PVector(p2, val10Pos.y));
  			  contour.addSegment(s);
              
              p1 = map(iso, val01, val11, val01Pos.y, val11Pos.y);
              p2 = map(iso, val00, val01, val00Pos.x, val01Pos.x);
  			  s = new Segment2D(new PVector(val01Pos.x, p1), new PVector(p2, val01Pos.y));
  			  contour.addSegment(s);
            }
            break;
          case 0:    // no edges
          case 15:   
          default:
            break;
        }
                    
      }
    }
	//hotswap
	contour.update();
  }
  
  void genFillNearestNeighbor(PImage img, ColorMapf cmap, boolean interpolate){
	  
	  int samplesx = dimx;
	  int samplesy = dimy;
	  
	  if (int(samplesx*spacing) != img.width || int(samplesy*spacing) != img.height){
		  println("Error in genFill: PImage dims do not match field");
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
  
  void genFillBilinear(PImage img, ColorMapf cmap, boolean interpolate){
	  
	  int samplesx = dimx;
	  int samplesy = dimy;
	  
	  if (int(samplesx*spacing) != img.width || int(samplesy*spacing) != img.height){
		  println("Error in genFill: PImage dims do not match field");
	  }
	  
	  img.loadPixels();
	  for (int y = 0; y < img.height; y++){
	  	  for (int x = 0; x < img.width; x++){
	  		  //grab 4 nearest data values for interpolation
	  		  int i0, j0, i1, j1;
	  		  float ax, ay;
  		  
	  		  float tmp = ((2.0*x+1.0)/(2*spacing)) - 0.5;
	  		  i0 = floor(tmp);
	  		  i1 = ceil(tmp);
	  		  ax = tmp - i0;
  		  		  
	  		  tmp = ((2.0*((samplesy*spacing-1)-y)+1.0)/(2*spacing)) - 0.5;//note: 0,0 is bottom left
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
  
  private int getIndex(int x, int y, int N)
  {
     int idx = (y*N)+x;
     return idx;
  }
  
}
