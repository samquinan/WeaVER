class LoadAnimation {
	// PVector cOrbit;
	// float rOrbit;
	// float angularVelocity;
	ArrayList<Orbiter> sats;

	LoadAnimation(PVector center, float radius, float angVel, float s){
		// cOrbit = center;
		// rOrbit = radius;
		// angularVelocity = angVel;
		sats = new ArrayList<Orbiter>();
		sats.add(new Orbiter(center, radius, angVel, radians(0),   3 ));
		sats.add(new Orbiter(center, radius, angVel, radians(s),  6 ));
		sats.add(new Orbiter(center, radius, angVel, radians(2*s),  8 ));
		sats.add(new Orbiter(center, radius, angVel, radians(3*s), 11));
		sats.add(new Orbiter(center, radius, angVel, radians(4*s), 7 ));
		sats.add(new Orbiter(center, radius, angVel, radians(5*s), 4 ));
		sats.add(new Orbiter(center, radius, angVel, radians(6*s), 2 ));		
	}
	
	void display(){
		color c = color(50);
		noStroke();
		for (Orbiter s: sats){
			s.display(c);
		}
	}
	
	void switchState(){
		for (Orbiter s: sats){
			s.switchState();
		}
	}
	
	void update(){//TODO switch to universal time animation?
		for (Orbiter s: sats){
			s.update();
		}
	}
}
