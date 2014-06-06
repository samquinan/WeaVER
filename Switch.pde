class Switch implements Button{
	String label1, label2;
	float x,y,w,h;
	boolean rollover, mouseDown, active, on;
	int textsize;
	color cBase, cTab, cHighlight, cLabel;
	//for animation
	float curx, cury;
	int tPrev, tSum, tTotal;
	
	Switch(float x0, float y0, float size){
		label1 = "";
		label2 = "";
		x = x0;
		y = y0;
		w = size;
		h = size;
		
		rollover=false;
		mouseDown=false;
		active = true;
		on = false;
		
		textsize = 10;
		cBase = color(70, 70, 85);
		cTab = color(200);
		cHighlight = color(185);
		cLabel = color(0);
		
		curx = x;
		cury = y;
		
		tPrev = 0;
		tSum = 300;
		tTotal = 300;
	}
	
	Switch(float x0, float y0, float w0, float h0){
		label1 = "";
		label2 = "";
		x = x0;
		y = y0;
		w = w0;
		h = h0;
		
		rollover=false;
		mouseDown=false;
		active = true;
		on = false;
		
		textsize = 11;
		cBase = color(70, 70, 85);
		cTab = color(200);
		cHighlight = color(185);
		
		curx = x+1;
		cury = y+1;
		
		tPrev = 0;
		tSum = 200;
		tTotal = 200;
	}
	
	void setColors(color b, color t, color h){
		cBase = b;
		cTab = t;
		cHighlight = h;
	}
	
	void setColors(color b, color t, color h, color l){
		cBase = b;
		cTab = t;
		cHighlight = h;
		cLabel = l;
	}
	
	void setLabels(String l1, String l2){
		label1 = l1;
		label2 = l2;
	}
	
	void setTextSize(int s){
		textsize = s;
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
		
		noStroke();
		fill(cBase);
		rect(x, y, 2*w, h);
						
		fill((rollover ? cHighlight : cTab));
		rect(curx,cury,(w-1),(h-2));
		
		textSize(textsize);
		fill(cLabel);
		textAlign(RIGHT, CENTER);
		text(label1, x-3, y+(h/2)-2);
		textAlign(LEFT, CENTER);
		text(label2, x+2*w+3, y+(h/2)-2);
	}
	
	private boolean intersected(float mx, float my){
		return (mx > x && mx < x+2*w && my > y && my < y+2*h) ? true : false;
	}
	
	void update(){
		//animate if approriate
		if (tSum < tTotal){
			int tCur = millis();
			tSum = tSum + (tCur - tPrev);
			tPrev = tCur;
			curx = (on ? map(min(tSum, tTotal), 0, tTotal, x+1, x+w) : map(min(tSum, tTotal), 0, tTotal, x+w, x+1) );			
		}		
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
	  if (tmp){
		   on = !on;
		   //trigger animation
		   tPrev=millis();
		   tSum=0;
	   }
	  return tmp;
    }

}