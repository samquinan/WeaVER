abstract class ScalarTargetBase extends Container implements Target {
	PImage layer0;
	Legend legend;
	
	ArrayList<Contour2D> layer1;
	QuadTree_Node<Segment2D> qtree;
	
	TimeControl timer;
	String label;
	
	ScalarTargetBase(float ix, float iy, float dx, float dy) {
		super(ix, iy, dx, dy, 1, 1);
		
		layer0 = null;
		layer1 = null;
		legend = null;
		qtree = null;
		label = "";
	}
	
	void setLabel(String s){
		label = s;
	}
	
	void linkImage(PImage img){
		layer0 = img;
	}
	
	void linkContours(ArrayList<Contour2D> contours){ 
		layer1 = contours;
	}
	
	void linkQuadTree(QuadTree_Node<Segment2D> q){
		qtree = q;
	}
	
	void linkLegend(Legend l){ 
		legend = l;
	}
	
	void linkTimeControl(TimeControl t){
		timer = t;
	}
	
  	void display() {
		textSize(8);
		textAlign(LEFT, BOTTOM);
		fill(70);
		text(label,x+2,y-1);
		super.display();
   	}
	
	void remove(Selectable s){
		super.remove(s);
		updateRenderContext();	
	}	
		
}
