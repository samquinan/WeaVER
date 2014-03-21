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
		dtargetEntries.add(new ArrayList<Selectable>());
		dtargetEntries.add(new ArrayList<Selectable>());
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
	
	void saveState(DropTarget t1, DropTarget t2){
		dtargetEntries.clear();
		dtargetEntries.add(new ArrayList<Selectable>(t1.entries));
		dtargetEntries.add(new ArrayList<Selectable>(t2.entries));
	}
	
	void restoreState(DropTarget t1, DropTarget t2){
		t1.entries = dtargetEntries.get(0);
		t2.entries = dtargetEntries.get(1);
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