class Barb{
	PShape glyph;
	float speed, dir; //dir in radians
	float tx, ty;
	
	Barb(float x, float y, float spd, float d, PShape s){
		glyph = s;
		tx = x;
		ty = y;
		speed = spd;
		dir = d;
	}
	
	void draw(){
		pushMatrix();
		translate(tx, ty);
		rotate(dir);
		shape(glyph);
		popMatrix();
	}
	
}