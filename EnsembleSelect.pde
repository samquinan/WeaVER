class EnsembleSelect extends Selectable implements EncodesSP, EncodesCBP{
	String var, hgt, val;
	EnsembleEncoding encd;
	
	EnsembleSelect(float ix, float iy, float iw, float ih, color rgb, EnsembleEncoding e){
		super(ix, iy, iw, ih, rgb);
		encd = e;
		var = "";
		hgt = "";
		val = "";
	}
	
	EnsembleSelect(float ix, float iy, float iw, float ih, color rgb, EnsembleEncoding e, String v, String h, String i){
		super(ix, iy, iw, ih, rgb);
		encd = e;
		var = v;
		hgt = h;
		val = i;
	}
	
	EnsembleSelect(float iw, float ih, color rgb, EnsembleEncoding e){
		super(0, 0, iw, ih, rgb);
		encd = e;
		var = "";
		hgt = "";
		val = "";
	}
	
	EnsembleSelect(float iw, float ih, color rgb, EnsembleEncoding e, String v, String h, String i){
		super(0, 0, iw, ih, rgb);
		encd = e;
		var = v;
		hgt = h;
		val = i;
	}
		
  	void display() {
		if (this.isVisible()) {
			super.display();
			textSize(11);
			textAlign(LEFT, CENTER);
			fill(0);
			text(var,x+15,y+h/2-2);
		
			textSize(10);
			fill(0);
			textAlign(RIGHT, TOP);
			text(val, x+w-3, y);
			
			textSize(9);
			textAlign(RIGHT, BOTTOM);
			text(hgt, x+w-3, y+h-2);
		}
	}
	
	EnsembleSelect instantiate(){
		EnsembleSelect s = new EnsembleSelect(x,y,w,h,color(r,g,b), encd, var, hgt, val);
		s.isClone = true;
		return s;
	}
		
	void genSPContours(ArrayList<Contour2D> contours){
		encd.genSPContours(contours);
	}
	
	void genSPContours(ArrayList<Contour2D> contours, int time){
		encd.genSPContours(contours, time);
	}
	
	void setIsovalue(float iso){
		encd.setIsovalue(iso);
	}
	
	
	// ColorMapf getColorMap(){
	// 	return encd.getColorMap();
	// }
	
	// void genFill(PImage img){
	// 	encd.genFill(img);
	// }
	// 
	// void genFill(PImage img, int time){
	// 	encd.genFill(img, time);
	// }	
	
}