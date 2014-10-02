class Library {
	ArrayList<LibCollection> sources;
	ArrayList<Container> targets;
	Selectable dragging;
	String label;
	float x,y,w,h;
	
	Library(float ix, float iy, float dx, float dy, int c, int r) {
		sources = new ArrayList<LibCollection>();
		sources.add(new LibCollection(ix, iy, dx, dy, c, r));
		targets = new ArrayList<Container>();
		label = "";
		dragging = null;
		x = ix;
		y = iy;
		w = c*dx;
		h = r*dy;
	}
	
	PVector getMaxXY(){
		return new PVector(x+w, y+h);
	}
	
	PVector getMinXY(){
		return new PVector(x, y);
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
	
	void addCollection(int c, int r){
		float tmpY,dx,dy;
		float buffer = 7;
		LibCollection last = sources.get(sources.size()-1);
		tmpY = y + h + buffer;
		dx = last.getDx();
		dy = last.getDy();
		h += dy*r + buffer;
		sources.add(new LibCollection(x, tmpY, dx, dy, c, r));
	}
	
	boolean remove(Selectable s){
		boolean done = false;
		for (LibCollection c : sources){
			done = c.remove(s);
			if (done) break;
		}
		return done;
	}
	
	boolean add(Selectable s){
		return (sources.get(0)).add(s);
	}
	
	boolean add(Selectable s, int collection_index){
		LibCollection c = sources.get(collection_index);
		if (c != null){
			return c.add(s);
		}
		return false;
	}
		
	void display() {
		textSize(12);
		textAlign(LEFT, BOTTOM);
		fill(70);
		text(label,x+2,y-1);
		
		//super.display();
		for (LibCollection c: sources){
			c.display();
		}
		for (Container t: targets){
			t.display();
		}
		if (dragging != null) {
			dragging.display();
		}
	}
	
	boolean interact(int mx, int my){
		
		boolean interacted = false;		
		// get current interacting
		if (dragging != null){
			interacted = dragging.interact(mx,my);
		}
		else { // check all containers for interaction then, test all targets for interaction
			for (LibCollection c: sources){
				if(c.interact(mx,my)){
					dragging = c.handoffDragging();
					interacted = true;
					break;
				}
			}
			if (dragging == null){
				for (Container t: targets){
					if (t.interact(mx,my)){
						dragging = t.handoffDragging();
						interacted = true;
						break;
					}
				} 
			}
		}
				
		// handle movement between containers
		if (dragging != null){ //dragging.dragging == true, handled in handoff dragging
			
			//remove if leaves current
			if (dragging.current != null){
				boolean inCurrent = dragging.current.isIntersectedAABB(dragging);
				if (!inCurrent) dragging.current.remove(dragging);
			}
			
			//add if possible
			if (dragging.current == null){
				boolean added = false;
				/*for (LibCollection c: sources){
					if(c.isIntersectedAABB(dragging)){
						added = c.add(dragging);
						break;
					}
				}*/
				if (!added){
					for (Container t: targets){
						if(t.isIntersectedAABB(dragging)){
							added = t.add(dragging);
							break;
						}
					}
				}
			}
			
			/*if (interacting.current == null){
				if (this.isIntersectedAABB(interacting)) this.add(interacting);
				else{
					for (Container t: targets){
						if(t.isIntersectedAABB(interacting)){
							t.add(interacting);
							break;
						}
					}
				}
			}*/
		}
		
		return interacted || (dragging != null);
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
		boolean click = false;
		for (LibCollection c: sources){
			click = click || c.clicked(mx,my);
			if (click) break;
		}
		if (!click){
			for (Container t: targets){
				click = click || t.clicked(mx,my);
				if (click) break;
			}
		}
		return click;
	}
	
	boolean released(){
		boolean r = false;
		if (dragging != null){
			r = dragging.released();
			dragging = null;
		} //TODO better propogation of highlight disable (only thing release is really doing at the moment) than individual test
		for (LibCollection c: sources){
				r = r || c.released();
		}
		for (Container t: targets){
			r = r || t.released();	
		}
		return r;		
	}
}
