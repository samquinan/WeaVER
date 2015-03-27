abstract class TargetBase extends Container implements Target{
	ArrayList<StickyLabel> labels;
	DecimalFormat df;
	
	TargetBase(float ix, float iy, float dx, float dy) {
		super(ix, iy, dx, dy, 1, 1);
		labels = null;
		df = new DecimalFormat("#.##");
	}
	
	TargetBase(float ix, float iy, float dx, float dy, int c, int r) {
		super(ix, iy, dx, dy, c, r);
		labels = null;
		df = new DecimalFormat("#.##");
	}
	
	void linkLabels(ArrayList<StickyLabel> l){
		labels = l;
	}	
}