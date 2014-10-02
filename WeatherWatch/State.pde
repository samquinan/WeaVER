class State {
	
	float x,y,w,h;
	boolean rollover = false;
	boolean active = false;
	String s;
	int textsize;
	ArrayList< ArrayList<Selectable> > dtargetEntries;
		
	State(float x0, float y0, float side, String ss){
	    x=x0;
		y=y0;
		w=side;
		h=side;
		s=ss;
		textsize = 12;
		
		dtargetEntries = new ArrayList< ArrayList<Selectable> >();
		// dtargetEntries.add(new ArrayList<Selectable>());
		// dtargetEntries.add(new ArrayList<Selectable>());
		// dtargetEntries.add(new ArrayList<Selectable>());
	}
	
	void setTextSize(int s){
		textsize = s;
	}
	
	boolean isActive(){
		return active;
	}
	
	void setActive(boolean b){
		active = b;
	}
	
	void display(){
		noStroke();
		if (active) fill(120);
		else if (rollover){
			strokeWeight(2);
			stroke(90);
			fill(160);
		}
		else fill(160);
		rect(x,y,w,h);
		
		fill(230);
		textSize(textsize);		
		textAlign(CENTER, CENTER);
		text(s, x+(w/2), y+(h/3));
	}
	
	// void saveState(Container t1, Container t2, Container t3){
	// 	dtargetEntries.clear();
	// 	dtargetEntries.add(new ArrayList<Selectable>(t1.entries));
	// 	dtargetEntries.add(new ArrayList<Selectable>(t2.entries));
	// 	dtargetEntries.add(new ArrayList<Selectable>(t3.entries));
	// }
	// 
	// void restoreState(Container t1, Container t2, Container t3){
	// 	t1.entries = dtargetEntries.get(0);
	// 	t2.entries = dtargetEntries.get(1);
	// 	t3.entries = dtargetEntries.get(2);
	// }
	
	void saveState(ArrayList<Container> targets){
		dtargetEntries.clear();
		for (int i = 0; i < targets.size(); i++){
			ArrayList<Selectable> tmp = new ArrayList<Selectable>((targets.get(i)).entries);
			dtargetEntries.add(tmp);
			for(Selectable s : tmp){
				if (s instanceof EnsembleSelect){
					EnsembleSelect es = (EnsembleSelect) s;
					if (es != null){
						(es.parent).child = null;
					}
				}
				else if (s instanceof ConditionSelect){
					ConditionSelect es = (ConditionSelect) s;
					if (es != null){
						(es.parent).child = null;
					}
				}
			}
		}
	}
	
	void restoreState(ArrayList<Container> targets){
		for (int i = 0; i < targets.size(); i++){
			if (i < dtargetEntries.size()){ 
				ArrayList<Selectable> tmp = dtargetEntries.get(i);
				(targets.get(i)).entries = tmp;
				for(Selectable s : tmp){
					if (s instanceof EnsembleSelect){
						EnsembleSelect es = (EnsembleSelect) s;
						if (es != null){
							(es.parent).child = es;
						}
					}
					else if (s instanceof ConditionSelect){
						ConditionSelect es = (ConditionSelect) s;
						if (es != null){
							(es.parent).child = es;
						}
					}
				}
			}
			else (targets.get(i)).entries = new ArrayList<Selectable>();
		}		
	}
	
	private boolean intersected(int mx, int my){
		return (mx > x && mx < x+w && my > y && my < y+h) ? true : false;
	}
	
	boolean interact(int mx, int my) {
		rollover = !active & intersected(mx, my);
		return rollover;
	}
	
	boolean clicked(int mx, int my) {
		return !active && intersected(mx, my);
	}
	
	    void released(){
	    }
	
}