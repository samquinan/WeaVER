class MenuBar {
	float x,y,w,h;
	int textSize, buffer;
	float nextx;
	ArrayList<Tab> items;
	Tab active;
	
	MenuBar(float ix, float iy, float iw, int sText){
		x = ix;
		y = iy;
		w = iw;
		h = sText+3;
		
		buffer = 7;
		textSize = sText;
		
		nextx = x+buffer+2;
		
		items = new ArrayList<Tab>();
		active = null; 
	}
	
	void addItem(String text){
		Tab t = new Tab(nextx, y+1, text, buffer, items.size());
		float tmp = t.endX();
		if (tmp < x+w){
			items.add(t);
			nextx = tmp+buffer+2;
			
			if (active == null){//first item is active by default
				active = t;
				active.setActive(false);
			}
		}
	}
	
	void display(){
		fill(190);
		noStroke();
		rect(x,y,w,h);
		for(Tab t : items){
			t.display();
		}
	}
	
	int getMode(){
		return active.getMode();
	}
	
	boolean clicked(int mx, int my){
		for(Tab t : items){
			if (t.clicked(mx,my)){
				return true;
			}
		}
		return false; 	
	}
	
	boolean interact(int mx, int my){
		for(Tab t : items){
			if (t.interact(mx,my)){
				return true;
			}
		}
		return false;
	}
	
	boolean released(){
		for(Tab t : items){
			if (t.released()){
				active.setActive(true);
				active = t;
				active.setActive(false);
				return true;
			}
		}
		return false;
	}
	
}