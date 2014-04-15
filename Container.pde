class Container { //TODO double check threadsafety for all operations, reduce length of synchronized ops
	private final Object lock = new Object();
	boolean highlight;
	float x,y,w,h;
	int cols, rows;
	ArrayList<Selectable> entries;
	Selectable interacting;
	
	Container(float ix, float iy, float dx, float dy, int c, int r) {
		x = ix;
		y = iy;
		w = c*dx;
		h = r*dy;
		cols = c;
		rows = r;
			
		entries = new ArrayList<Selectable>(cols*rows);
		interacting = null;
	}
	
	PVector getMaxXY(){return new PVector(x+w, y+h);}
	PVector getMinXY(){return new PVector(x, y);}
	
  	void display() {
		noStroke();
		if (highlight){
			strokeWeight(2);
			stroke(110,110,140);
		}
		fill(170);
		rect(x,y,w+1,h+1);
		
		synchronized(lock){
			for (Selectable s: entries){ // display everything except current interacting
				if (s != interacting) s.display();
			}
		}
		 
   	}
	
	void add(Selectable s){
		synchronized(lock){
		if (entries.size() == rows*cols){
			// println("Error: Attempted to Add Selectable to Full Container!");
			return;	
		}
		int index;
		if (this == s.home){
			index = 0;
			Selectable cur;
			int i,j;
			for (int k=entries.size()-1; k >= 0; k--){
				cur = entries.get(k);
				if(cur.lib_idx < s.lib_idx){
					index = k+1;
					break;
				}
				int new_idx = k+1;
				j = new_idx / cols;
				i = new_idx - (cols*j);
				cur.setRestPos(x+(i*w/cols), y+(j*h/rows));
				cur.moveToRest();
			}
			// update s
			j = index / cols;
			i = index - (cols*j);
			s.setRestPos(x+(i*w/cols), y+(j*h/rows));
			if (!s.dragging) s.moveToRest();
			entries.add(index, s);
		}
		else{
			index = entries.size();
			int j = index / cols;
			int i = index - (cols*j);
			s.setRestPos(x+(i*w/cols), y+(j*h/rows));
			if (!s.dragging) s.moveToRest();
			entries.add(s);
		}
		}
		s.current = this;
	}
		
	void remove(Selectable s){
		synchronized(lock){
		int index = entries.indexOf(s);
		if (index == -1) return;
		Selectable cur;
		for (int k=entries.size()-1; k>index; k--){
			cur = entries.get(k);
			int new_idx = k-1;
			int j = new_idx / cols;
			int i = new_idx - (cols*j);
			cur.setRestPos(x+(i*w/cols), y+(j*h/rows));
			cur.moveToRest();
		}
		entries.remove(index);
		}
		s.current = null;
	}
	
	boolean interact(int mx, int my) {
		highlight = false;
		//check if last interacting is still interacting -- propogate interaction
		synchronized(lock){ 
		if (interacting != null) {
			if (interacting.interact(mx,my)){
				return true;
			} 
			else interacting = null;
		}
		if (interacting == null){ //if no current interacting find topmost interacting
			if (!(mx > x && mx < x + w && my > y && my < y + h)) return false;
			for (int j=entries.size()-1; j >=0; j--){ 
				Selectable s = entries.get(j);
				if (s.interact(mx,my)){
					interacting = s;
					return true;
				}
			}
		}
		}
		return false;
	}
	
	boolean clicked(int mx, int my) {
		if (interacting != null){
			Selectable s = interacting.clicked(mx,my);
			boolean b = (s != null);
			if (b) interacting = s;
			return b;
		}
		else{//shouldn't hit
			if (!(mx > x && mx < x + w && my > y && my < y + h)) return false;
			synchronized(lock){ 
			for (int j=entries.size()-1; j >=0; j--){ 
				Selectable s = (entries.get(j)).clicked(mx,my);
				if (s != null){
					interacting = s;
					return true;
				}
			}
			}
			return false;
		}
	}
	
	boolean released(){
		highlight = false;
		if (interacting != null) return interacting.released();
		return false;
	}
	
	boolean isIntersectedAABB(Selectable s){
		boolean tmp = s.intersectsAABB(x,y,x+w,y+h);
		highlight = tmp && s.dragging;
		return tmp;
	}
	
	// void updateRenderContext(){}
	
}
