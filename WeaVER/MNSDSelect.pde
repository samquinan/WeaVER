class MNSDSelect extends Selectable implements EncodesScalar{
	String var, hgt, statop;
	ScalarEncoding mean;
	ScalarEncoding stddev;
	
	MNSDSelect(float ix, float iy, float iw, float ih, ScalarEncoding mn, ScalarEncoding sd){
		super(ix, iy, iw, ih);
		mean = mn;
		stddev = sd;
		var = "";
		hgt = "";
		statop = "MNSD";
	}
	
	MNSDSelect(float ix, float iy, float iw, float ih, ScalarEncoding mn, ScalarEncoding sd, String v, String h){
		super(ix, iy, iw, ih);
		mean = mn;
		stddev = sd;
		var = v;
		hgt = h;
		statop = "MNSD";
	}
	
	MNSDSelect(float iw, float ih, ScalarEncoding mn, ScalarEncoding sd){
		super(0, 0, iw, ih);
		mean = mn;
		stddev = sd;
		var = "";
		hgt = "";
		statop = "MNSD";
	}
	
	MNSDSelect(float iw, float ih, ScalarEncoding mn, ScalarEncoding sd, String v, String h){
		super(0, 0, iw, ih);
		mean = mn;
		stddev = sd;
		var = v;
		hgt = h;
		statop = "MNSD";
	}
	
	//Deprecated
	MNSDSelect(float ix, float iy, float iw, float ih, color rgb, ScalarEncoding mn, ScalarEncoding sd){
		super(ix, iy, iw, ih, rgb);
		mean = mn;
		stddev = sd;
		var = "";
		hgt = "";
		statop = "MNSD";
	}
	
	MNSDSelect(float ix, float iy, float iw, float ih, color rgb, ScalarEncoding mn, ScalarEncoding sd, String v, String h){
		super(ix, iy, iw, ih, rgb);
		mean = mn;
		stddev = sd;
		var = v;
		hgt = h;
		statop = "MNSD";
	}
	
	MNSDSelect(float iw, float ih, color rgb, ScalarEncoding mn, ScalarEncoding sd){
		super(0, 0, iw, ih, rgb);
		mean = mn;
		stddev = sd;
		var = "";
		hgt = "";
		statop = "MNSD";
	}
	
	MNSDSelect(float iw, float ih, color rgb, ScalarEncoding mn, ScalarEncoding sd, String v, String h){
		super(0, 0, iw, ih, rgb);
		mean = mn;
		stddev = sd;
		var = v;
		hgt = h;
		statop = "MNSD";
	}
	
	String getID(){
		return hgt + " " + var;
	}
	
	boolean dataIsAvailable(int idx){
		return mean.dataIsAvailable(idx) && stddev.dataIsAvailable(idx);
	} 
	
	boolean dataIsAvailable(){
		return mean.dataIsAvailable(0) && stddev.dataIsAvailable(0);
	}
	
  	void display() {
		if (this.isVisible()) {
			super.display();
			textSize(11);
			textAlign(LEFT, CENTER);
			fill(0);
			text(var,x+6,y+h/2-2);
		
			textSize(9);
			fill(0);
			textAlign(RIGHT, TOP);
			text(statop, x+w-3, y);
		
			textAlign(RIGHT, BOTTOM);
			text(hgt, x+w-3, y+h-2);
		}
	}
	
	MNSDSelect instantiate(){
		MNSDSelect s = new MNSDSelect(x,y,w,h, mean, stddev, var, hgt);
		s.isClone = true;
		return s;
	}
	
	ColorMapf getColorMap(){ //TODO error handling bad encodings
		return stddev.getColorMap();
	}
	
	void genFill(PImage img){
		stddev.genFill(img);
	}
	
	void genFill(PImage img, int time){
		stddev.genFill(img, time);
	}
	
	void genContours(ArrayList<Contour2D> contours){
		mean.genContours(contours);
	}
	
	void genContours(ArrayList<Contour2D> contours, int time){
		mean.genContours(contours, time);
	}
	
}