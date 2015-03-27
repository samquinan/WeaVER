class WindSelect extends Selectable implements EncodesScalar, EncodesVector{
	String var, hgt, statop;
	WindEncoding encd;
	
	WindSelect(float ix, float iy, float iw, float ih, WindEncoding e){
		super(ix, iy, iw, ih);
		encd = e;
		var = "";
		hgt = "";
		statop = "";
	}
	
	WindSelect(float ix, float iy, float iw, float ih, WindEncoding e, String h, String op){
		super(ix, iy, iw, ih);
		encd = e;
		var = "WIND";
		hgt = h;
		statop = op;
	}
	
	WindSelect(float iw, float ih, WindEncoding e){
		super(0, 0, iw, ih);
		encd = e;
		var = "";
		hgt = "";
		statop = "";
	}
	
	WindSelect(float iw, float ih, WindEncoding e, String h, String op){
		super(0, 0, iw, ih);
		encd = e;
		var = "WIND";
		hgt = h;
		statop = op;
	}
	
	
	//Deprecated
	WindSelect(float ix, float iy, float iw, float ih, color rgb, WindEncoding e){
		super(ix, iy, iw, ih, rgb);
		encd = e;
		var = "";
		hgt = "";
		statop = "";
	}
	
	WindSelect(float ix, float iy, float iw, float ih, color rgb, WindEncoding e, String h, String op){
		super(ix, iy, iw, ih, rgb);
		encd = e;
		var = "WIND";
		hgt = h;
		statop = op;
	}
	
	WindSelect(float iw, float ih, color rgb, WindEncoding e){
		super(0, 0, iw, ih, rgb);
		encd = e;
		var = "";
		hgt = "";
		statop = "";
	}
	
	WindSelect(float iw, float ih, color rgb, WindEncoding e, String h, String op){
		super(0, 0, iw, ih, rgb);
		encd = e;
		var = "WIND";
		hgt = h;
		statop = op;
	}
		
	
	boolean dataIsAvailable(int idx){
		return encd.dataIsAvailable(idx);
	} 
	
	boolean dataIsAvailable(){
		return encd.dataIsAvailable(0);
	} 	
	
	String getID(){
		return hgt + " " + var;
	}
			
  	void display() {
		if (this.isVisible()) {
			super.display();
			textSize(11);
			textAlign(LEFT, CENTER);
			fill(0);
			/*text(var,x+15,y+h/2-2);*/
			text(var,x+6,y+h/2-2);
			
		
			textSize(9);
			fill(0);
			textAlign(RIGHT, TOP);
			text(statop, x+w-3, y);
		
			textAlign(RIGHT, BOTTOM);
			text(hgt, x+w-3, y+h-2);
		}
	}
	
	WindSelect instantiate(){
		WindSelect s = new WindSelect(x,y,w,h,color(r,g,b), encd, hgt, statop);
		s.isClone = true;
		return s;
	}
	
	ColorMapf getColorMap(){
		return encd.getColorMap();
	}
	
	void genContours(ArrayList<Contour2D> contours){
		encd.genContours(contours);
	}
	
	void genContours(ArrayList<Contour2D> contours, int time){
		encd.genContours(contours, time);
	}
	
	void genFill(PImage img){
		encd.genFill(img);
	}
	
	void genFill(PImage img, int time){
		encd.genFill(img, time);
	}
	
	void genBarbs(ArrayList<Barb> barbs){
		encd.genBarbs(barbs);
	}
	void genBarbs(ArrayList<Barb> barbs, int time){
		encd.genBarbs(barbs, time);
	}
	
	
}