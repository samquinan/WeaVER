abstract class ScalarTargetBase extends TargetBase {
	PImage layer0;
	Legend legend;
	
	ArrayList<Contour2D> layer1;
	QuadTree_Node<Segment2D> qtree;
	
	TimeControl timer;
	String label;
	boolean hover;
	
	String err_out;
	
	ScalarTargetBase(float ix, float iy, float dx, float dy) {
		super(ix, iy, dx, dy, 1, 1);
		
		layer0 = null;
		layer1 = null;
		legend = null;
		qtree = null;
		timer = null;
		label = "";
		hover = false;
		
		err_out = ""; 
	}
	
	ScalarTargetBase(float ix, float iy, float dx, float dy, int c, int r) {
		super(ix, iy, dx, dy, c, r);
		
		layer0 = null;
		layer1 = null;
		legend = null;
		qtree = null;
		timer = null;
		label = "";
		hover = false;
		
		err_out = "";
	}
	
	void setLabel(String s){
		label = s;
	}
	
	String getErrorMessage(){
		return err_out;
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
	
	boolean interact(int mx, int my) {
		hover = (mx > x && mx < x + w && my > y && my < y + h);
		return super.interact(mx,my);
	}
	
	boolean remove(Selectable s){
		boolean b = super.remove(s);
		if (b) updateRenderContext();	
		return b;
	}
	
	boolean isHovering(){
		return hover && (interacting != null);	
	}
		
}
