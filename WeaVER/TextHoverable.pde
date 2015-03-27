class TextHoverable{
	String text;
	float x,y,w,h;
	int textsize;
	boolean rollover, active;
	color inactive, rest, highlight;
	
	TextHoverable(float x0, float y0, String s){
		text = s;
		x = x0;
		y = y0;
		textsize = 12;
		rollover=false;
		active = true;
		
		inactive = color(190, 190, 190, 120);
		rest = color(60);
		highlight = color(240);
		
		textSize(textsize);
		h = textAscent()+textDescent();
		w = textWidth(text);
	}
	
	void setTextSize(int s){
		textsize = s;
		textSize(textsize);
		h = textAscent()+textDescent();
		w = textWidth(text);
	}
	
	float getHeight(){
		return  h;
	}
	
	float getWidth(){
		return  w;
	}
	
	void setColors(color a, color r, color h){
		inactive  = a;
		rest      = r;
		highlight = h;
	}
	
	boolean isActive(){
		return active;
	}
	
	void setActive(boolean b){
		active = b;
	}
	
	void display(){
		textAlign(LEFT,TOP);
		textSize(textsize);
		
		if (!active) fill(inactive);
		else if (rollover){
			strokeWeight(1);
			stroke(150);
			fill(170);
			rect(x-1,y,w+2,h);
			
			noStroke();
			fill(highlight);
		}
		else fill(rest);
		
		text(text, x, y);
	}
	
	private boolean intersected(float mx, float my){
		return (mx > x && mx < x+w && my > y && my < y+h) ? true : false;
	}
	
	boolean interact(int mx, int my){
		rollover = active && intersected(mx,my);
		return rollover;
	}
	
	// boolean clicked(int mx, int my) {
	// 	mouseDown = active && intersected(mx, my);
	// 	return mouseDown;
	// }
	// 
	//     boolean released(){//returns true if release did work
	//   boolean tmp = mouseDown && rollover;
	//       mouseDown = false;
	//   return tmp;
	//     }

}