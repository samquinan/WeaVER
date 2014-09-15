class Library extends Container {
	int lib_idx;
	ArrayList<Container> targets;
	String label;
	
	Library(float ix, float iy, float dx, float dy, int c, int r) {
		super(ix, iy, dx, dy, c, r);
		targets = new ArrayList<Container>();
		lib_idx = 0;
		label = "";
	}
	
	void setLabel(String s){
		label = s;
	}
	
	void linkTarget(Container t){
		if (t instanceof Target) targets.add(t);
		else println("Error: attempted to link container that does not implement 'Target' interface");
	}
	
	void unlinkTarget(Container t){
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
			s.setLibIndex(lib_idx++);
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
		for (Container t: targets){
			t.display();
		}
		if (interacting != null) {
			interacting.display();
		}
	}
	
	boolean interact(int mx, int my){
		
		// get current interacting
		if (!(super.interact(mx, my))){ // if this has no interaction, test all targets for interaction
			for (Container t: targets){
				if (t.interact(mx,my)){
					interacting = t.interacting;
					//break; // need to propogate new interacting back to container of previous interacting -- TODO investigate proper solution, but in meantime this works
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
					for (Container t: targets){
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
	
	// boolean drag (int mx, int my){
	// 	// handle movement between containers
	// 	if (interacting != null && interacting.dragging){
	// 		
	// 		//remove if leaves current
	// 		if (interacting.current != null){
	// 			boolean inCurrent = interacting.current.isIntersectedAABB(interacting);
	// 			if (!inCurrent) interacting.current.remove(interacting);
	// 		}
	// 		
	// 		//add if possible
	// 		if (interacting.current == null){
	// 			if (this.isIntersectedAABB(interacting)) this.add(interacting);
	// 			else{
	// 				for (Container t: targets){
	// 					if(t.isIntersectedAABB(interacting)){
	// 						t.add(interacting);
	// 						break;
	// 					}
	// 				}
	// 			}
	// 		}
	// 	}
	// 	
	// 	return (interacting != null);
	// }
	
	boolean clicked(int mx, int my) {
		boolean click = super.clicked(mx,my);
		if (!click){
			for (Container t: targets){
				click = click || t.clicked(mx,my);
				if (click) break;
			}
		}
		return click;
	}
	
	boolean released(){
		boolean r = super.released();
		for (Container t: targets){
			r = r || t.released();	
		}
		return r;
	}
}
