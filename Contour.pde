class Contour2D {
 private ArrayList<Segment2D> members;
 String id;
 
 Contour2D(){
   members = new ArrayList<Segment2D>();
   id = "";
 }
 
 Contour2D(int initCapacity){
   members = new ArrayList<Segment2D>(initCapacity);
   id="";
 }
 
 void setID(String s){
	 id = s;
 }
 
 String getID(){
	 return id;
 }
 
 void addSegment(Segment2D s){
   members.add(s);
   s.setSrcContour(this);
 }
 
 int getMemberCount(){
	 return members.size();
 }
 
 void addAllSegmentsToQuadTree(QuadTree_Node<Segment2D> qtree){
 	 for (Segment2D s : members){
 		 qtree.add(s);
 	 }
 }
 
 void clearAll(){
   members.clear();
 }
 
 void drawContour(){
   // for (Segment2D s : members){
//      s.drawSegment();
//    }
	beginShape(LINES);
	for (Segment2D s : members){
		s.makeVetexCalls();
	}
	endShape();
 }
 
}
