class Orbiter {
	int state;
	color current;
	
	PVector cOrbit;
	float rOrbit;
	float angularVelocity;
	float aOrbit;
	int tPrev;

	float sizeSat;
	float xSat, ySat;
	
	int tTotal;
	int transitionLength;
	float dTransition;
	
	Orbiter(PVector center, float radius, float angVel, float initAng, float size){
		state = 0;
		cOrbit = center;
		rOrbit = radius;
		aOrbit = initAng;
		angularVelocity = angVel;
		tPrev = millis();
		
		sizeSat= size;
		xSat = cOrbit.x + rOrbit*sin(aOrbit);
		ySat = cOrbit.y + rOrbit*cos(aOrbit);
		
		tTotal = 0;
		transitionLength = 500;
		dTransition = 0;
	}
	
	int display(color argb){
		if (state==0) return 0;
		int a = (argb >> 24) & 0xFF;
		color cc = (round(map(dTransition, 0, 1, 0, a)) << 24) | (argb & 0x00FFFFFF);
		fill(cc);
		ellipse(xSat, ySat, sizeSat, sizeSat);
		a = (cc >> 24) & 0xFF;
		return a;
	}
	
	boolean isOff(){
		return (state == 0);
	}
	
	void switchState(){
		switch(state){
			case 0:
			case 2:
			state++;
			break;
			case 1:
			tTotal = transitionLength - tTotal;
			state = 3;
			break;
			case 3:
			tTotal = transitionLength - tTotal;
			state = 1;
			break;
			default:
		}
	}
	
	void update(){
		
		int tCur = millis();
		int dt = tCur-tPrev;
		aOrbit += dt*angularVelocity;
		if(aOrbit > TWO_PI) aOrbit -= TWO_PI;
		
		switch(state){
			case 1://opening
			tTotal += dt;
			dTransition = float(tTotal)/transitionLength;
			if (tTotal > transitionLength){
				dTransition = 1;
				tTotal=0;
				state=2;
			}
			break;
			case 3://closing
			tTotal += dt;
			dTransition = 1.0 - float(tTotal)/transitionLength;
			if (tTotal > transitionLength){
				dTransition = 0;
				tTotal=0;
				state = 0;
			}
			break;
			default:
		}
		
		float r = dTransition*rOrbit;	
		xSat = cOrbit.x + r*sin(aOrbit);
		ySat = cOrbit.y + r*cos(aOrbit);
		tPrev=tCur;
	}
}
