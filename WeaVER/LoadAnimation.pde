class LoadAnimation {
	PVector pCenter;
	// float rOrbit;
	// float angularVelocity;
	ArrayList<Orbiter> sats;
	private boolean is_off;
	String message;
	String details;

	LoadAnimation(PVector center, float radius, float angVel, float s){
		// cOrbit = center;
		// rOrbit = radius;
		// angularVelocity = angVel;
		message = "LOADING";
		sats = new ArrayList<Orbiter>();
		sats.add(new Orbiter(center, radius, angVel, radians(0),    3 ));
		sats.add(new Orbiter(center, radius, angVel, radians(s),    6 ));
		sats.add(new Orbiter(center, radius, angVel, radians(2*s),  8 ));
		sats.add(new Orbiter(center, radius, angVel, radians(3*s), 11 ));
		sats.add(new Orbiter(center, radius, angVel, radians(4*s),  7 ));
		sats.add(new Orbiter(center, radius, angVel, radians(5*s),  4 ));
		sats.add(new Orbiter(center, radius, angVel, radians(6*s),  2 ));
		pCenter = center;
		details = "";		
	}
		
	void display(){
		int a = 0;
		color c = color(50);
		noStroke();
		for (Orbiter s: sats){
			a = s.display(c);
		}
		
		textAlign(CENTER, CENTER);
		fill((a << 24) | (c & 0x00FFFFFF));
		textSize(12);
		text(message, pCenter.x, pCenter.y);
		text(details, pCenter.x, pCenter.y+80);
	}
	
	void switchState(){
		for (Orbiter s: sats){
			s.switchState();
		}
	}
	
	boolean isOff(){
		return is_off;
	}
	
	void update(){//TODO switch to universal time animation?
		for (Orbiter s: sats){
			s.update();
		}
		is_off = (sats.get(0)).isOff();
	}
}
