class TextButton implements Button{
	String text;
	float x,y;
	int textsize;
	boolean rollover, mouseDown, active;
	color inactive, rest, highlight, pressed;
	
	TextButton(float x0, float y0, String s){
		text = s;
		x = x0;
		y = y0;
		textsize = 12;
		rollover=false;
		mouseDown=false;
		active = true;
		
		inactive = color(190, 190, 190, 120);
		rest = color(60);
		highlight = color(120);
		pressed = color(30);
	}
	
	void setTextSize(int s){
		textsize = s;
	}
	
	void setColors(color a, color r, color h, color p){
		inactive  = a;
		rest      = r;
		highlight = h;
		pressed   = p;
	}
	
	boolean isActive(){
		return active;
	}
	
	void setActive(boolean b){
		active = b;
	}
	
	void display(){
		if (!active) fill(inactive);
		else if (mouseDown && rollover) fill(pressed);
		else if (rollover) fill(highlight);
		else fill(rest);
		
		textAlign(LEFT,TOP);
		textSize(textsize);
		text(text, x, y);
	}
	
	private boolean intersected(float mx, float my){
		textSize(textsize);
		return (mx > x && mx < x+textWidth(text) && my > y+1 && my < y+textsize+1) ? true : false;
	}
	
	boolean interact(int mx, int my){
		rollover = active && intersected(mx,my);
		return rollover;
	}
	
	boolean clicked(int mx, int my) {
		mouseDown = active && intersected(mx, my);
		return mouseDown;
	}
	
    boolean released(){//returns true if release did work
	  boolean tmp = mouseDown && rollover;
      mouseDown = false;
	  return tmp;
    }

}