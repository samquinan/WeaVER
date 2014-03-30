class TimeControl {
	String label, element;
	float x, y, w;
	int cur;	
	Slider slider;
	FwdButton bFwd;
	BackButton bBack;
	
	// boolean animate;
		
	TimeControl(float x0, float y0, float w0, int stages){
		x = x0;
		y = y0;
		w = w0;
		
		label = "";
		element = "";
				
		slider = new Slider(x, x+w, y, 0, stages-1);
	    slider.displaySliderValue(false);
	    
		cur = int(slider.getValue());
		
	    bFwd = new FwdButton(x+25, y+30, 13);
	    bBack = new BackButton(x,  y+30, 13);
				
		makeConsistent();
	}
	
	int getIndex(){
		return cur;
	}
	
	void setLabel(String l){
		label = l;
	}
		
	void display(){
		slider.display();
	    bFwd.display();
	    bBack.display();
		
	    textSize(11);
		fill(0, 0, 0, 255);
	    textAlign(CENTER);
	    text(label, x + w/2, y+20);
		
	    textSize(13);
		fill(0, 0, 0, 255);
	    textAlign(CENTER, CENTER);
	    text(element, x + w/2, y+30);
		
	}
		
	boolean interact(int mx, int my) {
		boolean interacted = slider.interact(mx, my);
		if (interacted) return interacted;
		
	    interacted = interacted || bFwd.interact(mx, my);
		if (interacted) return interacted;
		
	    interacted = interacted || bBack.interact(mx, my);
		return interacted;
	}
	
	boolean drag(int mx, int my) {
		 if(bFwd.drag(mx, my)) return false;
		 if(bBack.drag(mx, my)) return false;
		
		boolean interacted = slider.interact(mx, my);
		int now = int(slider.getValue());
	
		if (slider.isDragging() && (cur != now)){
			cur = now;
			makeConsistent();
		}
				
		return interacted;	
	}
	
	boolean clicked(int mx, int my) {
		boolean clicked = slider.clicked(mx, my);
		if (clicked) return clicked;
		
		clicked = clicked || bFwd.clicked(mx, my);
		if (clicked) return clicked;
		
		clicked = clicked || bBack.clicked(mx, my);
		return clicked;
	}
	
    boolean released(){
		boolean released = slider.released();
		if (released) return released;
		
		released = released || bFwd.released();
		if (released){
			cur++;
			makeConsistent();
			return released;
		}
		released = released || bBack.released();
		if (released){
			cur--;
			makeConsistent();
		}
		return released;
	}
	
	private void makeConsistent(){
		if(!slider.isDragging()) slider.setVal(cur);
		PVector r = slider.getRange();
    	bFwd.setActive((cur < r.y));
    	bBack.setActive((cur > r.x));
		
		element = String.format("%02d", cur*3);
	}
}