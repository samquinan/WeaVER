class CharButton extends RectButton {
	char c;
	int csize;
	
	CharButton(float x0, float y0, float side, char cc){
	    super(x0,y0,side);
		c=cc;
		csize = 12;
	}
	
	void setCharSize(int s){
		csize = s;
	}
	
	void display(){
		super.display();
		if (active){
			if(mouseDown) fill(230);
			else fill(30);
			textSize(csize);		
			textAlign(CENTER, CENTER);
			text(c, x+(w/2), y+(h/3));
		}
		
	}


}