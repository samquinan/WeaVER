abstract class View {
	PFont fReg, fErr;
	Library library;
	StateTracker tracker;
	TimeControl timer;
	ArrayList<TargetBase> targets;
	DateTime origin;
	
	PShape map;
	
	int samplesx, samplesy;
	float spacing;
	int cornerx, cornery;
	int tabw, tabh;
	
	String errmsg;
		
	View(int sx, int sy, float ds, int cx, int cy, int tw, int th, int libsize){
		samplesx = sx;
		samplesy = sy;
		spacing  = ds;
		cornerx  = cx;
		cornery  = cy;
		tabw 	 = tw;
		tabh 	 = th;
		
		library = new Library(cornerx+(samplesx*spacing) + 20,45,tabw,tabh,3, ceil(libsize/3.0));
		library.setLabel("FIELDS");
		
		tracker = new StateTracker(cornerx+20,cornery+samplesy*spacing+30,"VIEWS");
	    timer = new TimeControl(cornerx+samplesx*spacing + 20, cornery+samplesy*spacing - 50, tabw*3, 30);
		timer.setLabel("FORECAST HOUR");
		
		targets = new ArrayList<TargetBase>();
		
		errmsg = "";
		fReg = null;
		fErr = null;
						
		map = null;
		origin = null;
	}
	
	void setFonts(PFont r, PFont e){
		fReg = r;
		fErr = e;
	}   
	
	
	void setMap(PShape s){
		map = s;
	}
	
	PShape getMap(){
		return map;
	}
	
	void setDateTimeOrigin(DateTime o){
		origin = o;
	}
	
	DateTime getDateTimeOrigin(){
		return origin;
	}
	
	abstract void loadData(String dataDir, int run_input);
	abstract void draw();
	
	void updateAnim(){
		if(timer.update()){
			for (TargetBase c : targets){
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
	
	void mousePress(int mx, int my, int clickCount){
		press(mx, my, clickCount);
	}
	
	void mousePress(int mx, int my){
		press(mx, my, 1);
	}
	
	protected boolean press(int mx, int my, int clickCount){
		if(library.clicked(mx, my)) return true;
		else if (tracker.clicked(mx, my)){
			if(tracker.changed()) tracker.update(targets);
			return true;
		}
		else if(timer.clicked(mx, my)) return true;
		else return false;
	}
	
	protected boolean press(int mx, int my){
		return press(mx,my,1);
	}
	
	
	/*void mousePress(int mx, int my, int clickCount){
		press(mx, my, clickCount);
	}

	protected boolean press(int mx, int my, int clickCount){
		if(library.clicked(mx, my)) return true;
		else if (tracker.clicked(mx, my)){
			if(tracker.changed()) tracker.update(targets);
			return true;
		}
		else if(timer.clicked(mx, my)) return true;
		else return false;
	}

	protected boolean press(int mx, int my){
		return press(mx,my,1);
	}*/
	
	void mouseMove(int mx, int my){
		move(mx,my);
	}
	
	protected boolean move(int mx, int my){
		if (library.interact(mx,my)) return true;
		else if (tracker.interact(mx,my)) return true;
		else if (timer.interact(mx, my)) return true;
		else return false;
	}
	
	void mouseDrag(int mx, int my){
		drag(mx,my);
	}
	
	protected boolean drag(int mx, int my){ 
		if (library.interact(mx,my)) return true;
		else if (timer.drag(mx, my)){
			for (TargetBase c : targets){
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
			for (TargetBase c : targets){
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
			for (TargetBase c : targets){
				Target tmp = (Target) c;
				if (tmp != null) tmp.updateRenderContext(true);
			}
		}
		else if (tracker.keyPress(key, code)){
			if (tracker.changed()){
				tracker.update(targets);
				changed = true;
			}
		}
		return changed;
	}
	
    public FloatList readDataToFloatList(String file){ //again should be a static method but processing doesn't like so this is the messy hack
  	  FloatList tmp = new FloatList();
	   
      String[] lines = loadStrings(file);
      boolean first = true;  
      for(String line: lines)
      {
        float val = float(line.trim());
        tmp.append(val);
      }
	  
  	  return tmp; 
    }			
	
}