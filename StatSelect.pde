class StatSelect extends Selectable implements EncodesScalar{
	String var, hgt, statop;
	ScalarEncoding statfield;
	
	StatSelect(float ix, float iy, float iw, float ih, color rgb, ScalarEncoding f){
		super(ix, iy, iw, ih, rgb);
		statfield = f;
		var = "";
		hgt = "";
		statop = "";
	}
	
	StatSelect(float ix, float iy, float iw, float ih, color rgb, ScalarEncoding f, String v, String h, String op){
		super(ix, iy, iw, ih, rgb);
		statfield = f;
		var = v;
		hgt = h;
		statop = op;
	}
	
	StatSelect(float iw, float ih, color rgb, ScalarEncoding f){
		super(0, 0, iw, ih, rgb);
		statfield = f;
		var = "";
		hgt = "";
		statop = "";
	}
	
	StatSelect(float iw, float ih, color rgb, ScalarEncoding f, String v, String h, String op){
		super(0, 0, iw, ih, rgb);
		statfield = f;
		var = v;
		hgt = h;
		statop = op;
	}
	
  	void display() {
		if (this.isVisible()) {
			super.display();
			textSize(11);
			textAlign(LEFT, CENTER);
			fill(0);
			text(var,x+15,y+h/2-2);
		
			textSize(9);
			fill(0);
			textAlign(RIGHT, TOP);
			text(statop, x+w-3, y);
		
			textAlign(RIGHT, BOTTOM);
			text(hgt, x+w-3, y+h-2);
		}
	}
	
	StatSelect instantiate(){
		StatSelect s = new StatSelect(x,y,w,h,color(r,g,b),statfield, var, hgt, statop);
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