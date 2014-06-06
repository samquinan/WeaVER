class WindTarget extends Container implements Target{
	
	ArrayList<Barb> layer;
	boolean hover;
	
	TimeControl timer;
	String label;
	
	WindTarget(float ix, float iy, float dx, float dy) {
		super(ix, iy, dx, dy, 1, 1);
		layer = null;
		timer = null;
		hover = false;
	}
	
	void setLabel(String s){
		label = s;
	}
	
	void linkBarbs(ArrayList<Barb> b){
		layer = b;
	}
	
	void linkTimeControl(TimeControl t){
		timer = t;
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
		return hover;	
	}
	
	
	void add(Selectable s){
		if (s instanceof EncodesVector){
			super.add(s);	
		}
	}
		
	boolean isIntersectedAABB(Selectable s){
		boolean valid = (s instanceof EncodesVector);
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
				break;
		}
	}
	
	void updateRenderContext(boolean cache){//caching does nothing
		updateRenderContext();
	}
	
	void cacheRenderContext(){ //caching does nothing
	}
	
	
	private void clear(){
		if (layer != null) layer.clear();
	}
	
	private void update(){
		int fhr = (timer == null) ? 0 : timer.getIndex();
		//barbs
		if (layer != null){
			layer.clear();
			EncodesVector s = (EncodesVector) entries.get(0);
			if (s != null){
				s.genBarbs(layer, fhr);
			}
		}
	}
	
	
	
	
}