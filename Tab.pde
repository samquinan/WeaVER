class Tab extends TextButton{
	int bufferx;
	int mode;
	
	Tab(float x0, float y0, String s, int buffer, int m){
		super(x0,y0,s);
		bufferx = buffer;
		
		inactive = color(30);
		rest = color(30);
		highlight = color(255);
		pressed = color(255);
		
		mode = m;
	}
	
	void display(){
		noStroke();
		fill(230); // TODO -- un-hardcode parallel to background
		if (!active) rect(x-bufferx, y, 2*bufferx+textWidth(text), textsize+2);
		super.display();
	}
	
	protected boolean intersected(float mx, float my){
		textSize(textsize);
		return (mx > x-bufferx && mx < x+bufferx+textWidth(text) && my > y+1 && my < y+textsize+1) ? true : false;
	}
	
	int getMode(){
		return mode;
	}
	
	float endX(){
		return x+bufferx+textWidth(text);
	}
}