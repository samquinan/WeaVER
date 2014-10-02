class ConditionSelect extends Selectable implements HandlesConditions{
	String var, hgt, val;
	ArrayList<ConditionEnsemble> conditionSeries;
	boolean thereCanBeOnlyOne;
	ConditionSelect parent;
	ConditionSelect child;
	
	ConditionSelect(float ix, float iy, float iw, float ih, ArrayList<ConditionEnsemble> e){
		super(ix, iy, iw, ih);
		conditionSeries = e;
		var = "";
		hgt = "";
		val = "";
		parent = null;
		child = null;
		thereCanBeOnlyOne = false;
	}
	
	ConditionSelect(float ix, float iy, float iw, float ih, ArrayList<ConditionEnsemble> e, String v, String h, String i){
		super(ix, iy, iw, ih);
		conditionSeries = e;
		var = v;
		hgt = h;
		val = i;
		parent = null;
		child = null;
		thereCanBeOnlyOne = false;
	}
	
	ConditionSelect(float iw, float ih, ArrayList<ConditionEnsemble> e){
		super(0, 0, iw, ih);
		conditionSeries = e;
		var = "";
		hgt = "";
		val = "";
		parent = null;
		child = null;
		thereCanBeOnlyOne = false;
	}
	
	ConditionSelect(float iw, float ih, ArrayList<ConditionEnsemble> e, String v, String h, String i){
		super(0, 0, iw, ih);
		conditionSeries = e;
		var = v;
		hgt = h;
		val = i;
		parent = null;
		child = null;
		thereCanBeOnlyOne = false;
	}
	
	
	//DEPRECATED
	ConditionSelect(float ix, float iy, float iw, float ih, color rgb, ArrayList<ConditionEnsemble> e){
		super(ix, iy, iw, ih, rgb);
		conditionSeries = e;
		var = "";
		hgt = "";
		val = "";
		parent = null;
		child = null;
		thereCanBeOnlyOne = false;
	}
	
	ConditionSelect(float ix, float iy, float iw, float ih, color rgb, ArrayList<ConditionEnsemble> e, String v, String h, String i){
		super(ix, iy, iw, ih, rgb);
		conditionSeries = e;
		var = v;
		hgt = h;
		val = i;
		parent = null;
		child = null;
		thereCanBeOnlyOne = false;
	}
	
	ConditionSelect(float iw, float ih, color rgb, ArrayList<ConditionEnsemble> e){
		super(0, 0, iw, ih, rgb);
		conditionSeries = e;
		var = "";
		hgt = "";
		val = "";
		parent = null;
		child = null;
		thereCanBeOnlyOne = false;
	}
	
	ConditionSelect(float iw, float ih, color rgb, ArrayList<ConditionEnsemble> e, String v, String h, String i){
		super(0, 0, iw, ih, rgb);
		conditionSeries = e;
		var = v;
		hgt = h;
		val = i;
		parent = null;
		child = null;
		thereCanBeOnlyOne = false;
	}
	
	boolean dataIsAvailable(int idx){
		return conditionSeries.get(idx).dataIsAvailable();
	} 
	
	boolean dataIsAvailable(){
		return conditionSeries.get(0).dataIsAvailable();
	}
	
	void setSingleCopy(boolean b){
		thereCanBeOnlyOne = b;
	}
	
	void releaseChild(){
		child = null;
	}
	
	String getID(){
		return hgt + " " + var;
	}
		
  	void display() {
		if (this.isVisible()) {
			//draw box base
			int a = 255;
			if (dragging) a = 150;
			else if (thereCanBeOnlyOne && (child != null)) a = 150;
		
			noStroke();
			fill(color(225,226,227,a));
			rect(x,y,w,h);

/*			fill(color(r,g,b,a));
			rect(x+6,y,7,h);*/
		
			noFill();
			if (rollover && !(thereCanBeOnlyOne && (child != null))) {
				strokeWeight(2);
				stroke(color(70));
				}
			else{
				strokeWeight(1);
				stroke(color(170));
			}
			rect(x,y,w,h);
			
			// text labels
			textSize(11);
			textAlign(LEFT, CENTER);
			fill(0, a);
			//text(var,x+15,y+h/2-2);
			text(var,x+6,y+h/2-2);
		
			textSize(9);
			fill(0, a);
			textAlign(RIGHT, TOP);
			text(val, x+w-3, y);
			
			textSize(9);
			textAlign(RIGHT, BOTTOM);
			text(hgt, x+w-3, y+h-2);
		}
	}
	
	ConditionSelect instantiate(){
		ConditionSelect s = new ConditionSelect(x,y,w,h, conditionSeries, var, hgt, val);
		s.isClone = true;
		s.thereCanBeOnlyOne = thereCanBeOnlyOne;
		if (this.isClone) s = null;
		else if (thereCanBeOnlyOne){
			if (this.child == null){
				s.parent = this;
				this.child = s;
			}
			else {
				s = null;
			}
		}
		return s;
	}
	
	ConditionSelect clicked(int mx, int my) {
		if (mx > x && mx < x + w && my > y && my < y + h) {
			this.rollover = false;
			ConditionSelect s = (this.isClone) ? this : this.instantiate();
			if (s != null){
			    s.dragging = true;
				s.offsetX = x-mx;
				s.offsetY = y-my;
			}
			return s;
		}
		return null;
	}
	
	boolean released(){
		if (dragging = false) return false;
		dragging = false;
		
		if(current == null){
			if (!isClone) home.add(this);
			else{ //is Clone
				if (thereCanBeOnlyOne && (this.parent != null)){ //child files for emancipation
					(this.parent).releaseChild();
					this.parent = null;
				}
				this.visible = false;//will be deleted by garabage collection but remove from draw cycle in meantime
			} 
		}
		else if(current instanceof Target){ //inefficient double cast -- restructure to fix
			x = restx;
			y = resty;
			
			current.isIntersectedAABB(this);
			((Target) current).updateRenderContext();
		}
		return true;
	}
	
	ConditionEnsemble getCondition(){
		return conditionSeries.get(0);
	}
	ConditionEnsemble getCondition(int idx){ //TODO out of bounds check
		return conditionSeries.get(idx);
	}
	
	ConditionEnsemble getConditionCopy(){
		return (conditionSeries.get(0)).getCopy();
	}
	ConditionEnsemble getConditionCopy(int idx){ //TODO out of bounds check
		return (conditionSeries.get(idx)).getCopy();
	}
	
	
	// ArrayList<ConditionEnsemble> deepCopyConditionSeries(){
	// 	ArrayList<ConditionEnsemble> tmp = new ArrayList<ConditionEnsemble>(conditionSeries.size());
	// 	for (ConditionEnsemble c : conditionSeries){
	// 		tmp.add(c.getCopy());
	// 	}
	// 	return tmp;
	// }
			
}