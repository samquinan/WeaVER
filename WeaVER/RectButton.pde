class RectButton implements Button {
	
	float x,y,w,h;
	boolean rollover = false;
	boolean mouseDown = false;
	boolean active = true;
		
	RectButton(float x0, float y0, float side){
	    x=x0;
		y=y0;
		w=side;
		h=side;
	}
	
	RectButton(float x0, float y0, float w0, float h0){
	    x=x0;
		y=y0;
		w=w0;
		h=h0;
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
			fill(160);
		}
		else fill(190);
		rect(x,y,w,h);
	}
	
	private boolean intersected(int mx, int my){
		return (mx > x && mx < x+w && my > y && my < y+h) ? true : false;
	}
	
	boolean interact(int mx, int my) {
		rollover = active & intersected(mx, my);
		return rollover;
	}
	
	boolean clicked(int mx, int my) {
		mouseDown = active && intersected(mx, my);
		return mouseDown;
	}
	
    boolean released(){//returns true if release did work
	  boolean tmp = mouseDown;
      mouseDown = false;
	  return tmp;
    }
	
}