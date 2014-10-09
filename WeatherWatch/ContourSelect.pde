class ContourSelect extends Selectable implements EncodesContour{
	String var, hgt, statop;
	ContourEncoding statfield;
	
	/*deprecated*/
	ContourSelect(float ix, float iy, float iw, float ih, color rgb, ContourEncoding f){
		super(ix, iy, iw, ih, rgb);
		statfield = f;
		var = "";
		hgt = "";
		statop = "";
	}
	
	ContourSelect(float ix, float iy, float iw, float ih, ContourEncoding f){
		super(ix, iy, iw, ih);
		statfield = f;
		var = "";
		hgt = "";
		statop = "";
	}
	
	/*deprecated*/
	ContourSelect(float ix, float iy, float iw, float ih, color rgb, ContourEncoding f, String v, String h, String op){
		super(ix, iy, iw, ih, rgb);
		statfield = f;
		var = v;
		hgt = h;
		statop = op;
	}
	
	ContourSelect(float ix, float iy, float iw, float ih, ContourEncoding f, String v, String h, String op){
		super(ix, iy, iw, ih);
		statfield = f;
		var = v;
		hgt = h;
		statop = op;
	}
	
	/*deprecated*/
	ContourSelect(float iw, float ih, color rgb, ContourEncoding f){
		super(0, 0, iw, ih, rgb);
		statfield = f;
		var = "";
		hgt = "";
		statop = "";
	}
	
	ContourSelect(float iw, float ih, ContourEncoding f){
		super(0, 0, iw, ih);
		statfield = f;
		var = "";
		hgt = "";
		statop = "";
	}
	
	/*deprecated*/
	ContourSelect(float iw, float ih, color rgb, ContourEncoding f, String v, String h, String op){
		super(0, 0, iw, ih, rgb);
		statfield = f;
		var = v;
		hgt = h;
		statop = op;
	}
	
	ContourSelect(float iw, float ih, ContourEncoding f, String v, String h, String op){
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
	
	ContourSelect instantiate(){
		ContourSelect s = new ContourSelect(x,y,w,h,statfield, var, hgt, statop);
		s.isClone = true;
		return s;
	}
		
	void genContours(ArrayList<Contour2D> contours){
		statfield.genContours(contours);
	}
	
	void genContours(ArrayList<Contour2D> contours, int time){
		statfield.genContours(contours, time);
	}
		
	
}