class TimeControl {
	String label, element;
	float x, y, w;
	int cur;	
	Slider slider;
	FwdButton bFwd;
	BackButton bBack;
	TextSwitch loop;
	int tPrev, tSum, tTotal; 	
		
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
		
		loop = new TextSwitch(x+w-40, y+30, "animate");
		loop.setTextSize(12);
		loop.setColors(color(50, 50, 50, 120), color(47, 109, 162), color(30), color(23, 64, 98), color(80), color(0), color(0));
				
		makeConsistent();
		
		tPrev = 0;
		tSum = 0;
		tTotal = 500;
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
		loop.display();
		
	    textSize(11);
		fill(0, 0, 0, 255);
	    textAlign(CENTER);
	    text(label, x + w/2, y+20);
		
	    textSize(13);
		fill(0, 0, 0, 255);
	    textAlign(CENTER, CENTER);
	    text(element, x + w/2, y+30);
		
	}
	
	void setAnimating(boolean b){
		loop.setState(b);
		if(loop.isOn()){
			slider.setActive(false);
			bFwd.setActive(false);
			bBack.setActive(false);
			tPrev = millis();
			tSum = 0;
		}
		else{
			slider.setActive(true);
			makeConsistent();
		}
	}
	
	boolean update(){
		if (loop.isOn()){
			int tCur = millis();
			tSum += tCur - tPrev;
			tPrev = tCur;
			if (tSum >= tTotal){
				PVector r = slider.getRange();
				if (++cur > r.y){
					cur = int(r.x);
				}
				slider.setVal(cur);
				updateCountLabel();
				tSum = 0;
				return true;
			}
			return false;
		}
		return false;
	}
		
	boolean interact(int mx, int my) {
		boolean interacted = slider.interact(mx, my);
		if (interacted) return interacted;
		
	    interacted = interacted || bFwd.interact(mx, my);
		if (interacted) return interacted;
		
	    interacted = interacted || bBack.interact(mx, my);
		if (interacted) return interacted;
		
	    interacted = interacted || loop.interact(mx, my);
		
		return interacted;
	}
	
	boolean drag(int mx, int my) {
		 if(bFwd.drag(mx, my)) return false;
		 if(bBack.drag(mx, my)) return false;
		 if(loop.interact(mx, my)) return false;
		
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
		if (clicked) return clicked;
		
		clicked = clicked || loop.clicked(mx, my);
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
			return released;
		}
		
		released = released || loop.released();
		if (released){
			if(loop.isOn()){
				slider.setActive(false);
				bFwd.setActive(false);
				bBack.setActive(false);
				tPrev = millis();
				tSum = 0;
				return false; //hack to prevent secondary effect of caching 				
			}
			else{
				slider.setActive(true);
				makeConsistent();
				return true;
			}
		}
		
		return released;
	}
	
	private void makeConsistent(){
		if(!slider.isDragging()) slider.setVal(cur);
		PVector r = slider.getRange();
    	bFwd.setActive((cur < r.y));
    	bBack.setActive((cur > r.x));
		
		updateCountLabel();
	}
	
	private void updateCountLabel(){
		element = String.format("%02d", cur*3);
	}
	
	boolean increment(){
		boolean affected = false;
		if (!loop.isOn()){
			if (bFwd.isActive()){
				affected = true;
				cur++;
			}
			makeConsistent();
		}
		return affected;
	}
	
	boolean decrement(){
		boolean affected = false;
		if (!loop.isOn()){
			if (bBack.isActive()){
				affected = true;
				cur--;
			}
			makeConsistent();
		}
		return affected;
	}
	
	
}