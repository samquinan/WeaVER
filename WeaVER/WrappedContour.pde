class WrappedContour2D {
 private Contour2D contour;
 
 WrappedContour2D(){
	 contour = null;
 }
  
 WrappedContour2D(Contour2D c){
	 contour = c;
 }
 
 void replaceContour(Contour2D c){
	 contour = c;
 }
  
 String getID(){
	 return (contour == null) ? "" : contour.getID();
 }
  
 int getMemberCount(){
	 return (contour == null) ? -1 : contour.getMemberCount();
 }
 
 void addAllSegmentsToQuadTree(QuadTree_Node<Segment2D> qtree){
 	 if (contour != null) contour.addAllSegmentsToQuadTree(qtree);
 }
 
 void genPShape(){
	 if (contour != null) contour.genPShape();
 }
 
 void drawContour(){
	 if (contour != null) contour.drawContour();
 }
 
}
