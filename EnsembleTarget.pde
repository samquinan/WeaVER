class EnsembleTarget extends Container implements Target{
	
	ArrayList<Contour2D> sp_members;
	QuadTree_Node<Segment2D> sp_qtree;
	
	boolean hover;
	TimeControl timer;
	Switch cbp;
	String label;
	
	EnsembleTarget(float ix, float iy, float dx, float dy) {
		super(ix, iy, dx, dy, 1, 1);
		sp_members = null;
		sp_qtree = null;
		timer = null;
		hover = false;
	}
	
	void setLabel(String s){
		label = s;
	}
	
	void linkSPContours(ArrayList<Contour2D> contours){ 
		sp_members = contours;
	}
	
	void linkSPQuadTree(QuadTree_Node<Segment2D> q){
		sp_qtree = q;
	}
	
	void linkTimeControl(TimeControl t){
		timer = t;
	}
	
	void linkSwitch(Switch s){
		cbp = s;
	}

  	void display() {
		textSize(8);
		textAlign(LEFT, BOTTOM);
		fill(70);
		text(label,x+2,y-1);
		super.display();		
   	}
	
	boolean interact(int mx, int my) {
		hover = (mx > x && mx < x + w && my > y && my < y + h);
		return super.interact(mx,my);
	}
	
	boolean isHovering(){
		return hover && (interacting != null);	
	}
	
	void add(Selectable s){
		if ((s instanceof EncodesSP) && (s instanceof EncodesCBP)){
			super.add(s);	
		}
	}
		
	boolean isIntersectedAABB(Selectable s){
		boolean valid = (s instanceof EncodesSP) && (s instanceof EncodesCBP);
		boolean tmp = super.isIntersectedAABB(s) && valid;
		highlight = highlight && valid;
		hover = hover && !highlight;
		return tmp;
	}
	
	void remove(Selectable s){
		super.remove(s);
		updateRenderContext();	
	}	
	
	
	void updateRenderContext(){
		int n = entries.size();
		switch(n){
			case 0:
				clear();
				break;
			case 1:
			default:
				update();
				cacheCurrent();
				break;
		}
	}
	
	void updateRenderContext(boolean cache){
		int n = entries.size();
		switch(n){
			case 0:
				clear();
				break;
			case 1:
			default:
				update();
				if (cache) cacheCurrent();
				break;
		}
	}
	
	void cacheRenderContext(){ 
		if (entries.size() > 0) cacheCurrent();
	}
	
	
	private void clear(){
		if (sp_members != null) sp_members.clear();
		if (sp_qtree != null) sp_qtree.clear();
	}
	
	private void update(){
		int fhr = (timer == null) ? 0 : timer.getIndex();
		//update based on switch to minimize processing
		if(cbp.isOn()){
			//update CBP
		}
		else {
			//update SP
			if (sp_members != null){
				sp_members.clear();
				EncodesSP s = (EncodesSP) entries.get(0);
				if (s != null){
					s.genSPContours(sp_members, fhr);
					//quadtree
					if (sp_qtree != null){
						sp_qtree.clear();
					}
				}
			}
			
		}		
	}
	
	private void cacheCurrent(){
		//cache based on switch to minimize processing
		if(cbp.isOn()){
			//update CBP
		}
		else {
			//update SP
			if (sp_members != null){
				if (sp_qtree != null){ //generate quadtree and cache contours
					sp_qtree.clear();
					for (Contour2D c: sp_members){
						c.addAllSegmentsToQuadTree(sp_qtree);
						c.genPShape();
					}
				}
				else { //cache contours only
					for (Contour2D c: sp_members){
						c.genPShape();
					}
				}
			}	
		}		
	}
	
	
	
	
}