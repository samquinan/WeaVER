class Library extends Container {
	int k;
	ArrayList<DropTarget> targets;
	String label;
	
	Library(float ix, float iy, float dx, float dy, int c, int r) {
		super(ix, iy, dx, dy, c, r);
		targets = new ArrayList<DropTarget>();
		k = 0;
		label = "";
	}
	
	void setLabel(String s){
		label = s;
	}
	
	void linkTarget(DropTarget t){
		targets.add(t);
	}
	
	void unlinkTarget(DropTarget t){
		targets.remove(t);
	}
	
	void remove(Selectable s){
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
		s.current = null;
	}
	
	void add(Selectable s){ //TODO clean up index assignment
		if (s.isClone) return;
		if (s.home == null){
			s.setLibIndex(k++);
			s.setLibrary(this);
		}
		super.add(s);
	}
		
	void display() {
		textSize(12);
		textAlign(LEFT, BOTTOM);
		fill(70);
		text(label,x+2,y-1);
		
		super.display();
		for (DropTarget t: targets){
			t.display();
		}
		if (interacting != null) {
			interacting.display();
		}
	}
	
	boolean interact(int mx, int my){
		
		// get current interacting
		if (!(super.interact(mx, my))){ // if this has no interaction, test all targets for interaction
			for (DropTarget t: targets){
				if (t.interact(mx,my)){
					interacting = t.interacting;
					break;
				} 
			}
		}
		
		// handle movement between containers
		if (interacting != null && interacting.dragging){
			
			//remove if leaves current
			if (interacting.current != null){
				boolean inCurrent = interacting.current.isIntersectedAABB(interacting);
				if (!inCurrent) interacting.current.remove(interacting);
			}
			
			//add if possible
			if (interacting.current == null){
				if (this.isIntersectedAABB(interacting)) this.add(interacting);
				else{
					for (DropTarget t: targets){
						if(t.isIntersectedAABB(interacting)){
							t.add(interacting);
							break;
						}
					}
				}
			}
		}
		
		return (interacting != null);
	}
	
	boolean clicked(int mx, int my) {
		boolean click = super.clicked(mx,my);
		if (!click){
			for (DropTarget t: targets){
				click = click || t.clicked(mx,my);
				if (click) break;
			}
		}
		return click;
	}
	
	boolean released(){
		boolean r = super.released();
		for (DropTarget t: targets){
			r = r || t.released();	
		}
		return r;
	}
}