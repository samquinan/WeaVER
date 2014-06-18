class EnsembleTarget extends Container implements Target{
	
	ArrayList<Contour2D> sp_members;
	QuadTree_Node<Segment2D> sp_qtree;
	
	boolean h_setup;
	float h_anchorX, h_anchorY;
	boolean generated;
	ArrayList<TextHoverable> sp_hoverables;
	
	boolean hover;
	TimeControl timer;
	Switch cbp;
	String label;
	color clr;
	color border;
	
	EnsembleTarget(float ix, float iy, float dx, float dy) {
		super(ix, iy, dx, dy, 1, 1);
		sp_members = null;
		sp_qtree = null;
		sp_hoverables = null;
		timer = null;
		h_setup = false;
		hover = false;
		clr = color(255,255,255,0);
		border = color(170, 0);
		generated = false;
	}
	
	void setColor(color cin){
		clr = cin;
		border = color(170, 255);
	}
	
	void setLabel(String s){
		label = s;
	}
	
	boolean hasSelectable(){
		return (entries.size() > 0);
	}
	
	void linkSPHoverables(ArrayList<TextHoverable> member_labels, float anchorX, float anchorY){ 
		sp_hoverables = member_labels;
		h_anchorX = anchorX;
		h_anchorY = anchorY;
		h_setup = true;
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
		stroke(border);
		strokeWeight(1);
		fill(clr);
		rect(x+2+textWidth(label)+5, y-2-textAscent()-textDescent(), 9, 9);
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
			if (h_setup && (entries.size()==1) && !generated) generateHoverables();
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
		if (h_setup && (entries.size()==0)){
			sp_hoverables.clear();
			generated = false;
		}
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
	
	private void generateHoverables(){
		EncodesSP s = (EncodesSP) entries.get(0);
		if (s != null){
			ArrayList<String> labels = s.getMemberLabels();
			TextHoverable t;
			float gap = 3;
			float x = h_anchorX;
			float y = h_anchorY;
			for(String text : labels){
				t = new TextHoverable(x,y,text);
				t.setTextSize(11);
				sp_hoverables.add(t);
				
				y = y + t.getHeight() + gap;
			}
			generated = true;
		}
	}
	
	private void clear(){
		if (sp_members != null) sp_members.clear();
		if (sp_qtree != null) sp_qtree.clear();
	}
	
	private void update(){
		int fhr = (timer == null) ? 0 : timer.getIndex();
		
		//update SP -- need members in both views but do not need quad tree
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
		
		if(cbp.isOn()){
			//update CBP
		}
	}
	
	private void cacheCurrent(){
		//cache based on switch to minimize processing
		
		if (sp_members != null){
			if (!cbp.isOn() && sp_qtree != null){ //generate quadtree and cache contours
				sp_qtree.clear();
				for (Contour2D c: sp_members){
					c.addAllSegmentsToQuadTree(sp_qtree);
					c.genPShape();
				}
			}
			else { // cache contours only
				for (Contour2D c: sp_members){
					c.genPShape();
				}
			}
		}	
		
		if(cbp.isOn()){
			//update CBP
		}
	}
	
	
	
	
}