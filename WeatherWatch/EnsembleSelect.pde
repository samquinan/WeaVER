class EnsembleSelect extends Selectable implements EncodesSP, EncodesCBP{
	String var, hgt, val;
	EnsembleEncoding encd;
	boolean thereCanBeOnlyOne;
	EnsembleSelect parent;
	EnsembleSelect child;
	
	EnsembleSelect(float ix, float iy, float iw, float ih, EnsembleEncoding e){
		super(ix, iy, iw, ih);
		encd = e;
		var = "";
		hgt = "";
		val = "";
		parent = null;
		child = null;
		thereCanBeOnlyOne = false;
	}
	
	EnsembleSelect(float ix, float iy, float iw, float ih, EnsembleEncoding e, String v, String h, String i){
		super(ix, iy, iw, ih);
		encd = e;
		var = v;
		hgt = h;
		val = i;
		parent = null;
		child = null;
		thereCanBeOnlyOne = false;
	}
	
	EnsembleSelect(float iw, float ih, EnsembleEncoding e){
		super(0, 0, iw, ih);
		encd = e;
		var = "";
		hgt = "";
		val = "";
		parent = null;
		child = null;
		thereCanBeOnlyOne = false;
	}
	
	EnsembleSelect(float iw, float ih, EnsembleEncoding e, String v, String h, String i){
		super(0, 0, iw, ih);
		encd = e;
		var = v;
		hgt = h;
		val = i;
		parent = null;
		child = null;
		thereCanBeOnlyOne = false;
	}
	
	
	
	//DEPRECATED
	EnsembleSelect(float ix, float iy, float iw, float ih, color rgb, EnsembleEncoding e){
		super(ix, iy, iw, ih, rgb);
		encd = e;
		var = "";
		hgt = "";
		val = "";
		parent = null;
		child = null;
		thereCanBeOnlyOne = false;
	}
	
	EnsembleSelect(float ix, float iy, float iw, float ih, color rgb, EnsembleEncoding e, String v, String h, String i){
		super(ix, iy, iw, ih, rgb);
		encd = e;
		var = v;
		hgt = h;
		val = i;
		parent = null;
		child = null;
		thereCanBeOnlyOne = false;
	}
	
	EnsembleSelect(float iw, float ih, color rgb, EnsembleEncoding e){
		super(0, 0, iw, ih, rgb);
		encd = e;
		var = "";
		hgt = "";
		val = "";
		parent = null;
		child = null;
		thereCanBeOnlyOne = false;
	}
	
	EnsembleSelect(float iw, float ih, color rgb, EnsembleEncoding e, String v, String h, String i){
		super(0, 0, iw, ih, rgb);
		encd = e;
		var = v;
		hgt = h;
		val = i;
		parent = null;
		child = null;
		thereCanBeOnlyOne = false;
	}
	
	void setSingleCopy(boolean b){
		thereCanBeOnlyOne = b;
	}
	
	void releaseChild(){
		child = null;
	}
	
	String getID(){
		return hgt + " " + var;
	}
		
  	void display() {
		if (this.isVisible()) {
			//draw box base
			int a = 255;
			if (dragging) a = 150;
			else if (thereCanBeOnlyOne && (child != null)) a = 150;
		
			noStroke();
			fill(color(225,226,227,a));
			rect(x,y,w,h);
		
			/*fill(color(r,g,b,a));
			rect(x+6,y,7,h);*/
		
			noFill();
			if (rollover && !(thereCanBeOnlyOne && (child != null))) {
				strokeWeight(2);
				stroke(color(70));
				}
			else{
				strokeWeight(1);
				stroke(color(170));
			}
			rect(x,y,w,h);
			
			// text labels
			textSize(11);
			textAlign(LEFT, CENTER);
			fill(0, a);
			/*text(var,x+15,y+h/2-2);*/
			text(var,x+6,y+h/2-2);
		
			textSize(10);
			fill(0, a);
			textAlign(RIGHT, TOP);
			text(val, x+w-3, y);
			
			textSize(9);
			textAlign(RIGHT, BOTTOM);
			text(hgt, x+w-3, y+h-2);
		}
	}
	
	EnsembleSelect instantiate(){
		EnsembleSelect s = new EnsembleSelect(x,y,w,h, encd, var, hgt, val);
		s.isClone = true;
		s.thereCanBeOnlyOne = thereCanBeOnlyOne;
		if (this.isClone) s = null;
		else if (thereCanBeOnlyOne){
			if (this.child == null){
				s.parent = this;
				this.child = s;
			}
			else {
				s = null;
			}
		}
		return s;
	}
	
	EnsembleSelect clicked(int mx, int my) {
		if (mx > x && mx < x + w && my > y && my < y + h) {
			this.rollover = false;
			EnsembleSelect s = (this.isClone) ? this : this.instantiate();
			if (s != null){
			    s.dragging = true;
				s.offsetX = x-mx;
				s.offsetY = y-my;
			}
			return s;
		}
		return null;
	}
	
	boolean released(){
		if (dragging = false) return false;
		dragging = false;
		rollover = false;
		
		if(current == null){
			if (!isClone) home.add(this);
			else{ //is Clone
				if (thereCanBeOnlyOne && (this.parent != null)){ //child files for emancipation
					(this.parent).releaseChild();
					this.parent = null;
				}
				this.visible = false;//will be deleted by garabage collection but remove from draw cycle in meantime
			} 
		}
		else if(current instanceof Target){ //inefficient double cast -- restructure to fix
			x = restx;
			y = resty;
			
			current.isIntersectedAABB(this);
			((Target) current).updateRenderContext();
		}
		return true;
	}
			
	void genSPContours(ArrayList<Contour2D> contours){
		encd.genSPContours(contours);
	}
	
	void genSPContours(ArrayList<Contour2D> contours, int time){
		encd.genSPContours(contours, time);
	}
	
	void getCBPmedian(WrappedContour2D wrapper){
		encd.getCBPmedian(wrapper);
	}
	
	void getCBPmedian(WrappedContour2D wrapper, int idx){
		encd.getCBPmedian(wrapper, idx);
	}
	
	// Contour2D getCBPmedian(){
	// 	return encd.getCBPmedian();
	// }
	// Contour2D getCBPmedian(int idx){
	// 	return encd.getCBPmedian(idx);
	// }
	
	// ArrayList<Contour2D> getCBPoutliers(){
	// 		return encd.getCBPoutliers();
	// }
	// ArrayList<Contour2D> getCBPoutliers(int idx){
	// 		return encd.getCBPoutliers(idx);
	// }
	
	void getCBPoutliers(ArrayList<Contour2D> contours){
		encd.getCBPoutliers(contours);
	}
	void getCBPoutliers(ArrayList<Contour2D> contours, int idx){
		encd.getCBPoutliers(contours, idx);
	}
	
	void genCBPbands(PImage img, ColorMapf cmap, ColorMapf cmap2){
		encd.genCBPbands(img, cmap, cmap2);	
	}
	void genCBPbands(PImage img, ColorMapf cmap, ColorMapf cmap2, int idx){
		encd.genCBPbands(img, cmap, cmap2, idx);
	}
	
	void genCBPbands(PImage img, color c1, color c2, int idx){
		encd.genCBPbands(img,c1,c2,idx);
	}
	
	void setIsovalue(float iso){
		encd.setIsovalue(iso);
	}
	
	ArrayList<String> getMemberLabels(){
		return encd.getMemberLabels();
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