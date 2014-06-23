class Contour2D {
 private final Object lock = new Object();
 volatile boolean cached;
 PShape contour;
 // private int initCap;
 private ArrayList<Segment2D> members;
 private ArrayList<Segment2D> build;
 String id;
 
 Contour2D(){
   members = new ArrayList<Segment2D>();
   build = new ArrayList<Segment2D>();
   contour = null;
   cached = false;
   id = "";
 }
 
 Contour2D(int initCapacity){
   members = new ArrayList<Segment2D>();
   build = new ArrayList<Segment2D>(initCapacity);
   // initCap = initCapacity;
   id="";
 }
 
 void setID(String s){
	 id = s;
 }
 
 String getID(){
	 return id;
 }
 
 void addSegment(Segment2D s){
   build.add(s);
   s.setSrcContour(this);
 }
 
 void update(){
	 synchronized (lock){
		 ArrayList<Segment2D> tmp = members;
		 members = build;
		 build = tmp;
		 cached = false;
	 }
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
   // members.clear();
   synchronized (lock){
   	   build = new ArrayList<Segment2D>(members.size()); //less memory efficient but solves threadsafe issues
	   // cached = false;
	   // contour = null;
   }
 }
 
 void genPShape(){
 	synchronized (lock){
		PShape c = createShape();
		c.beginShape(LINES);
		c.strokeWeight(1);
		c.stroke(0);
		for (Segment2D s : members){
			s.makeVetexCalls(c);
		}
		c.endShape(LINES);
		c.disableStyle();
		contour = c;
		cached = true;
	}
 }
 
 void drawContour(){
	synchronized (lock){
		if (!cached){
			beginShape(LINES);
			for (Segment2D s : members){
				s.makeVetexCalls();
			}
			endShape();
		}
		else {
			shape(contour);
		}
	}
 }
 
}
