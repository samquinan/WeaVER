class WindTarget extends TargetBase{
	
	ArrayList<Barb> layer;
	boolean hover;
	
	TimeControl timer;
	String label;
	
	String err_out;
	
	WindTarget(float ix, float iy, float dx, float dy) {
		super(ix, iy, dx, dy, 1, 1);
		layer = null;
		timer = null;
		hover = false;
		err_out = "";
	}
	
	String getErrorMessage(){
		return err_out;
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
		return hover && (interacting != null);	
	}
	
	
	boolean add(Selectable s){
		boolean b = false;
		if (s instanceof EncodesVector){
			b = super.add(s);	
		}
		return b;
	}
		
	boolean isIntersectedAABB(Selectable s){
		boolean valid = (s instanceof EncodesVector);
		boolean tmp = super.isIntersectedAABB(s) && valid;
		highlight = highlight && valid;
		hover = hover && !highlight;
		return tmp;
	}
	
	boolean remove(Selectable s){
		boolean b = super.remove(s);
		if (b) updateRenderContext();
		return b;
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
		err_out = "";
		if (layer != null) layer.clear();
	}
	
	private void update(){
		int fhr = (timer == null) ? 0 : timer.getIndex();
		//barbs
		if (layer != null){
			String id = entries.get(0).getID();
			layer.clear();
			EncodesVector s = (EncodesVector) entries.get(0);
			if (s != null){
				if (s.dataIsAvailable(fhr)){
					err_out = "";
					s.genBarbs(layer, fhr);
				}
				else{
					if ("".equals(id.trim())) err_out = "barbs";
					else err_out = id;
				}
			}
		}
	}
	
	
	
	
}