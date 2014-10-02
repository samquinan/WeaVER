class StatSelect extends Selectable implements EncodesScalar{
	String var, hgt, statop;
	ScalarEncoding statfield;
	
	/*deprecated*/
	StatSelect(float ix, float iy, float iw, float ih, color rgb, ScalarEncoding f){
		super(ix, iy, iw, ih, rgb);
		statfield = f;
		var = "";
		hgt = "";
		statop = "";
	}
	
	StatSelect(float ix, float iy, float iw, float ih, ScalarEncoding f){
		super(ix, iy, iw, ih);
		statfield = f;
		var = "";
		hgt = "";
		statop = "";
	}
	
	/*deprecated*/
	StatSelect(float ix, float iy, float iw, float ih, color rgb, ScalarEncoding f, String v, String h, String op){
		super(ix, iy, iw, ih, rgb);
		statfield = f;
		var = v;
		hgt = h;
		statop = op;
	}
	
	StatSelect(float ix, float iy, float iw, float ih, ScalarEncoding f, String v, String h, String op){
		super(ix, iy, iw, ih);
		statfield = f;
		var = v;
		hgt = h;
		statop = op;
	}
	
	/*deprecated*/
	StatSelect(float iw, float ih, color rgb, ScalarEncoding f){
		super(0, 0, iw, ih, rgb);
		statfield = f;
		var = "";
		hgt = "";
		statop = "";
	}
	
	StatSelect(float iw, float ih, ScalarEncoding f){
		super(0, 0, iw, ih);
		statfield = f;
		var = "";
		hgt = "";
		statop = "";
	}
	
	/*deprecated*/
	StatSelect(float iw, float ih, color rgb, ScalarEncoding f, String v, String h, String op){
		super(0, 0, iw, ih, rgb);
		statfield = f;
		var = v;
		hgt = h;
		statop = op;
	}
	
	StatSelect(float iw, float ih, ScalarEncoding f, String v, String h, String op){
		super(0, 0, iw, ih);
		statfield = f;
		var = v;
		hgt = h;
		statop = op;
	}
	
	
	String getID(){
		return hgt + " " + var;
	}
	
	boolean dataIsAvailable(int idx){
		return statfield.dataIsAvailable(idx);
	} 
	
	boolean dataIsAvailable(){
		return statfield.dataIsAvailable(0);
	}
			
  	void display() {
		if (this.isVisible()) {
			super.display();
			textSize(11);
			textAlign(LEFT, CENTER);
			fill(0);
			//text(var,x+15,y+h/2-2);
			text(var,x+6,y+h/2-2);
		
			textSize(9);
			fill(0);
			textAlign(RIGHT, TOP);
			text(statop, x+w-3, y);
		
			textAlign(RIGHT, BOTTOM);
			text(hgt, x+w-3, y+h-2);
		}
	}
	
	StatSelect instantiate(){
		StatSelect s = new StatSelect(x,y,w,h,statfield, var, hgt, statop);
		s.isClone = true;
		return s;
	}
	
	ColorMapf getColorMap(){
		return statfield.getColorMap();
	}
	
	void genContours(ArrayList<Contour2D> contours){
		statfield.genContours(contours);
	}
	
	void genContours(ArrayList<Contour2D> contours, int time){
		statfield.genContours(contours, time);
	}
	
	void genFill(PImage img){
		statfield.genFill(img);
	}
	
	void genFill(PImage img, int time){
		statfield.genFill(img, time);
	}
	
	
}