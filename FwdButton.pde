class FwdButton implements Button {
	
	boolean rollover = false;
	boolean mouseDown = false;
	boolean active = true;
	PVector t0, t1, t2;
		
	FwdButton(float x0, float y1, float s){
	    float y0 = y1 + s;
	    float tx0 = x0 + s*(2.0 - sqrt(3))/4.0;
	    float tx1 = x0 + s - s*(2.0 - sqrt(3))/4.0;
	    float tymid = y1 + s/2.0;
		
		t0 = new PVector(tx0, y0);
		t1 = new PVector(tx0, y1);
		t2 = new PVector(tx1, tymid);
	}
	
	boolean isActive(){
		return active;
	}
	
	void setActive(boolean b){
		active = b;
	}
	
	void display(){
		noStroke();
		if (!active) fill(30,30,30,110);
		else if (mouseDown && rollover) fill(0);
		else if (rollover){
			strokeWeight(1);
			stroke(30);
			fill(130,200,250);
		}
		else fill(50);
		triangle(t0.x, t0.y, t1.x, t1.y, t2.x, t2.y);
	}
	
	private boolean intersected(int mx, int my){
		// barycentric coordinate intersection test
		PVector p, v0, v1, v2;
		p = new PVector(mx, my);
		
		v0 = PVector.sub(t2, t0);
		v1 = PVector.sub(t1, t0);
		v2 = PVector.sub(p, t0);
		
		float dot00, dot01, dot02, dot11, dot12;
		dot00 = v0.dot(v0);
		dot01 = v0.dot(v1);
		dot02 = v0.dot(v2);
		dot11 = v1.dot(v1);
		dot12 = v1.dot(v2);
		
		float x = 1.0 / (dot00 * dot11 - dot01 * dot01);
		float u = (dot11 * dot02 - dot01 * dot12) * x;
		float v = (dot00 * dot12 - dot01 * dot02) * x;
		
		return (u >= 0) && (v >= 0) && (u + v < 1);
	}
	
	boolean interact(int mx, int my) {
		rollover = active & intersected(mx, my);
		return rollover;
	}
	
	boolean drag(int mx, int my) {
		interact(mx, my);
		return mouseDown;
	}
	
	boolean clicked(int mx, int my) {
		mouseDown = active && intersected(mx, my);
		return mouseDown;
	}
	
    boolean released(){
		boolean tmp = mouseDown && rollover;
      	mouseDown = false;
		return tmp;
    }
	
}