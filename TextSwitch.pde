class TextSwitch implements Button{
	String text;
	float x,y;
	int textsize;
	boolean rollover, mouseDown, active, on;
	color inactive, rest_on, rest_off, highlight_on, highlight_off, pressed_on, pressed_off;
	
	TextSwitch(float x0, float y0, String s){
		text = s;
		x = x0;
		y = y0;
		textsize = 12;
		rollover=false;
		mouseDown=false;
		active = true;
		on = false;
		
		inactive = color(190, 190, 190, 120);
		rest_on = color(60);
		rest_off = color(30);
		highlight_on = color(120);
		highlight_off = color(120);
		pressed_on = color(30);
		pressed_off = color(30);
	}
	
	void setTextSize(int s){
		textsize = s;
	}
	
	void setColors(color a, color on, color off, color hon, color hoff, color pon, color poff){
		inactive 	  = a;
		rest_on  	  = on;
		rest_off      = off;
		highlight_on  = hon;
		highlight_off = hoff;
		pressed_on    = pon;
		pressed_on    = poff;
	}
	
	boolean isOn(){
		return on;
	}
	
	void setState(boolean b){
		on = b;
	}
	
	boolean isActive(){
		return active;
	}
	
	void setActive(boolean b){
		active = b;
	}
	
	
	void display(){
		if (!active) fill(inactive);
		else if (on){
			if (mouseDown && rollover) fill(pressed_on);
			else if (rollover) fill(highlight_on);
			else fill(rest_on);
		}
		else {
			if (mouseDown && rollover) fill(pressed_off);
			else if (rollover) fill(highlight_off);
			else fill(rest_off);
		}
		
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
	  if (tmp) on = !on;
	  return tmp;
    }

}