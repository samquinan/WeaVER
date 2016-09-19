public interface EncodesCBP{
	
	void getCBPmedian(WrappedContour2D wrapper);
	void getCBPmedian(WrappedContour2D wrapper, int idx);
		
	void getCBPoutliers(ArrayList<Contour2D> contours);
	void getCBPoutliers(ArrayList<Contour2D> contours, int idx);
	
	void genCBPbands(PImage img, ColorMapf cmap, ColorMapf cmap2);
	void genCBPbands(PImage img, ColorMapf cmap, ColorMapf cmap2, int idx);
	void genCBPbands(PImage img, color c1, color c2, int idx);
	
	boolean ignoreLowRes();
	void setIgnoreLowRes(boolean b);

}