class Button {
	
	float x,y,w,h;
	boolean rollover = false;
	boolean mouseDown = false;
	boolean active = true;
		
	Button(float x0, float y0, float side){
	    x=x0;
		y=y0;
		w=side;
		h=side;
	}
	
	boolean isActive(){
		return active;
	}
	
	void setActive(boolean b){
		active = b;
	}
	
	void display(){
		noStroke();
		if (!active) fill(190);
		else if (mouseDown) fill(100);
		else if (rollover){
			// strokeWeight(1);
			// stroke(70);
			fill(160);
		}
		else fill(190);
		rect(x,y,w,h);
	}
	
	private boolean intersected(int mx, int my){
		return (mx > x && mx < x+w && my > y && my < y+h) ? true : false;
	}
	
	void interact(int mx, int my) {
		rollover = active & intersected(mx, my);
	}
	
	boolean clicked(int mx, int my) {
		mouseDown = active && intersected(mx, my);
		return mouseDown;
	}
	
    void released(){
      mouseDown = false;
    }
	
}