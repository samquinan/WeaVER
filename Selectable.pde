class Selectable {
	private boolean visible;
	boolean dragging;
	boolean rollover;
	boolean isClone;
	
	float x,y,w,h; // entry position and size
	float restx, resty;
	int r,g,b; //color
	float offsetX, offsetY;// mouseclick offset
	
	Library home;
	Container current;
	int lib_idx; //library index
	
	Selectable(float ix, float iy, float iw, float ih, color rgb) {
	    x = ix;
		restx = ix;
	    y = iy;
		resty = iy;
	    w = iw;
	    h = ih;
	    offsetX = 0;
	    offsetY = 0;
		
		r = int(red(rgb)); 
		g = int(green(rgb));
		b = int(blue(rgb));
		
		home = null;
		current = null;
		lib_idx = -1;
		
		visible  = true;
		dragging = false;
		rollover = false;
		isClone  = false;
	}
	
	Selectable instantiate(){
		Selectable s = new Selectable(x,y,w,h,color(r,g,b));
		s.isClone = true;
		return s;
	}
	
	boolean isVisible(){
		return visible;
	}
	
  	void display() {
		if (visible){
			//draw box for entry
			int a = dragging ? 150 : 255;
		
			noStroke();
			fill(color(225,226,227,a));
			rect(x,y,w,h);
		
			fill(color(r,g,b,a));
			rect(x+6,y,7,h);
		
			noFill();
			if (rollover) {
				strokeWeight(2);
				stroke(color(70));
				}
			else{
				strokeWeight(1);
				stroke(color(170));
			}
			rect(x,y,w,h);
		}
   	}
	
	boolean interact(int mx, int my) {
	    if (mx > x && mx < x + w && my > y && my < y + h) {
	      rollover = true;
	    } 
		else {
	      rollover = false;
	    }
		
	    if (dragging) {
	      x = mx + offsetX;
	      y = my + offsetY;
	    }
		
		return rollover || dragging;
	}
	
	void setLibrary(Library l){ home = l;}
	void setCurrentContainer(Container c){ current = c;}
	void setLibIndex(int i){ lib_idx = i;}
	
	void setRestPos(float ix, float iy){
		restx = ix;
		resty = iy;
	}
	
	void moveToRest(){
		x = restx;
		y = resty;
	}
	
	Selectable clicked(int mx, int my) {
		if (mx > x && mx < x + w && my > y && my < y + h) {
			this.rollover = false;
			Selectable s = (this.isClone) ? this : this.instantiate();
		    s.dragging = true;
			s.offsetX = x-mx;
			s.offsetY = y-my;
			return s;
		}
		return null;
	}
	
	boolean released(){
		if (dragging = false) return false;
		dragging = false;
		
		if(current == null){
			if (!isClone) home.add(this);
			else visible = false;//will be deleted by garabage collection but remove from draw cycle in meantime
		}
		else if(current instanceof Target){ //inefficient double cast -- restructure to fix
			x = restx;
			y = resty;
			
			current.isIntersectedAABB(this);
			((Target) current).updateRenderContext();
		}
		return true;
	}
	
	boolean intersectsAABB(float minx, float miny, float maxx, float maxy){
	    if (x+w <= minx || x >= maxx) return false;
	    if (y+h <= miny || y >= maxy) return false;
		return true;
	}
	
}
