abstract class TargetBase extends Container implements Target{
	ArrayList<StickyLabel> labels;
	
	TargetBase(float ix, float iy, float dx, float dy) {
		super(ix, iy, dx, dy, 1, 1);
		labels = null;
	}
	
	TargetBase(float ix, float iy, float dx, float dy, int c, int r) {
		super(ix, iy, dx, dy, c, r);
		labels = null;
	}
	
	void linkLabels(ArrayList<StickyLabel> l){
		labels = l;
	}	
}