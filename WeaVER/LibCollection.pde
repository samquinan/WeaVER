class LibCollection extends Container {
	int lib_idx;
	String label;
	
	LibCollection(float ix, float iy, float dx, float dy, int c, int r) {
		super(ix, iy, dx, dy, c, r);
		lib_idx = 0;
		label = "";
	}
	
	void setLabel(String s){
		label = s;
	}
				
	boolean add(Selectable s){ //TODO clean up index assignment
		if (s.isClone) return false;
		if (s.home == null){
			s.setLibIndex(lib_idx++);
			s.setLibCollection(this);
		}
		return super.add(s);
	}
		
	void display() {
		textSize(10);
		textAlign(LEFT, BOTTOM);
		fill(70);
		text(label,x+2,y-1);
		
		super.display();
	}
		
}
