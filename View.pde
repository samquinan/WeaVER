abstract class View {
	Library library;
	StateTracker tracker;
	TimeControl timer;
	ArrayList<Container> targets;
	
	PShape map;
	
	int samplesx, samplesy;
	float spacing;
	int cornerx, cornery;
	int tabw, tabh;
	
	View(int sx, int sy, float ds, int cx, int cy, int tw, int th, int nliby){
		samplesx = sx;
		samplesy = sy;
		spacing  = ds;
		cornerx  = cx;
		cornery  = cy;
		tabw 	 = tw;
		tabh 	 = th;
		
		library = new Library(cornerx+(samplesx*spacing) + 20,45,tabw,tabh,2, nliby);
		library.setLabel("FIELDS");
		
		tracker = new StateTracker(cornerx+20,cornery+samplesy*spacing+30,"VIEWS");
	    timer = new TimeControl(cornerx+samplesx*spacing + 20, cornery+samplesy*spacing - 50, tabw*2, 30);
		timer.setLabel("FORECAST HOUR");
		
		targets = new ArrayList<Container>();
		
		map = null;
	}
	
	void setMap(PShape s){
		map = s;
	}
	
	PShape getMap(){
		return map;
	}
	
	abstract void loadData(String dataDir, int run_input);
	abstract void draw();
	
	void updateAnim(){
		if(timer.update()){
			for (Container c : targets){
				Target tmp = (Target) c;
				if (tmp != null){
					tmp.updateRenderContext(false); //double update of targets that do not require caching on release -- TODO revisit
				}
			}
		}
	}
	
	void haltAnim(){
		timer.setAnimating(false);
	}
	
	void mousePress(int mx, int my){
		press(mx, my);
	}
	
	protected boolean press(int mx, int my){
		if(library.clicked(mx, my)) return true;
		else if (tracker.clicked(mx, my)){
			if(tracker.changed()) tracker.update(targets);
			return true;
		}
		else if(timer.clicked(mx, my)) return true;
		else return false;
	}
	
	void mouseMove(int mx, int my){
		move(mx,my);
	}
	
	protected boolean move(int mx, int my){
		if (library.interact(mouseX,mouseY)) return true;
		else if (tracker.interact(mouseX,mouseY)) return true;
		else if (timer.interact(mouseX, mouseY)) return true;
		else return false;
	}
	
	void mouseDrag(int mx, int my){
		drag(mx,my);
	}
	
	protected boolean drag(int mx, int my){ 
		if (library.interact(mouseX,mouseY)) return true;
		else if (timer.drag(mouseX, mouseY)){
			for (Container c : targets){
				Target tmp = (Target) c;
				if (tmp != null){
					tmp.updateRenderContext(false); //double update of targets that do not require caching on release -- TODO revisit
				}
			}
			return true;	
		}
		else return false;
	}
	
	void mouseRelease(){
		release();
	}
	
	protected boolean release(){
		if (library.released()) return true;
		else if (tracker.released()) return true;
		else if (timer.released()){
			for (Container c : targets){
				Target tmp = (Target) c;
				if (tmp != null) tmp.updateRenderContext(true); //double update of targets that do not require caching -- TODO revisit
			}
			return true;
		}
		else return false;
	}
	
	boolean keyPress(char key, int code) {
		boolean changed = false;
	  	if (key == CODED) {
	  	  	if (code == LEFT) {
	  	  		changed = changed || timer.decrement();
	  	  	} else if (code == RIGHT) {
	  	  		changed = changed || timer.increment();
	  	  	} 
	  	}
		
		if (changed){
			for (Container c : targets){
				Target tmp = (Target) c;
				if (tmp != null) tmp.updateRenderContext(true);
			}
		}
		
		return changed;
	}		
	
}