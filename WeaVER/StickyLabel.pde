class StickyLabel {
	PVector pos;
	QuadTree_Node<Segment2D> search_tree;
	Contour2D source;
	int member_index;
	boolean rollover;
	
	String label;
	float x,y,w,h;
	
	StickyLabel(PVector init, QuadTree_Node<Segment2D> qtree, Contour2D current, int m_idx){
		pos = init;
		search_tree = qtree;
		source = current;
		member_index = m_idx;
		rollover = true;
		
		label = source.getID();
		x = pos.x;
		y = pos.y+2;
		textSize(10);
		w = textWidth(label)+4;
		h = textAscent()+textDescent();
	}
	
	int getMemberIndex(){
		return member_index;
	}
	
	Contour2D getContour(){
		return source;
	}
	
	void update(){			
		search_tree.clear();
		source.addAllSegmentsToQuadTree(search_tree);
		pos = search_tree.getClosestPoint(x,y);
		if (pos != null){
			x = pos.x;
			y = pos.y+2;
		}
	}
	
	void update(Contour2D c){
		source = c;
		label = source.getID();
		textSize(10);
		w = textWidth(label)+4;
		h = textAscent()+textDescent();
		
		update();
	}
	
	void reposition(float mx, float my){
		pos = search_tree.getClosestPoint(mx,my);
		if (pos != null){
			x = pos.x;
			y = pos.y+2;
		}
	}
	
	void display(){
		if (pos == null) return;//short circuit
		fill(255,179);
		if (!rollover) noStroke();
		else{
			strokeWeight(1);
			stroke(0,0,0,128);
		}
		rect(x - w/2, y - h, w, h);
		fill(0);
		noStroke();
		textAlign(CENTER,BOTTOM);
		textSize(10);
		text(label, x, y);
	}
	
	boolean interact(int mx, int my) {
	    if (mx > x - w/2 && mx < x + w/2&& my > y - h && my < y ) {
	      rollover = true;
	    }
		else {
	      rollover = false;
	    }
				
		return rollover;
	}
	
		
		
		
	
}
