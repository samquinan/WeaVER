public interface EncodesCBP{
	
	// ColorMapf getColorMap();
	// void setColors(Color c1, Color c2);
	
	// Contour2D getCBPmedian();
	// Contour2D getCBPmedian(int idx);
	void getCBPmedian(WrappedContour2D wrapper);
	void getCBPmedian(WrappedContour2D wrapper, int idx);
	
	
	// ArrayList<Contour2D> getCBPoutliers();
	// ArrayList<Contour2D> getCBPoutliers(int idx);
	
	void getCBPoutliers(ArrayList<Contour2D> contours);
	void getCBPoutliers(ArrayList<Contour2D> contours, int idx);
	
	void genCBPbands(PImage img, ColorMapf cmap, ColorMapf cmap2);
	void genCBPbands(PImage img, ColorMapf cmap, ColorMapf cmap2, int idx);
	void genCBPbands(PImage img, color c1, color c2, int idx);
	
	boolean ignoreLowRes();
	void setIgnoreLowRes(boolean b);
	
	// void genOutliers(ArrayList<Contour2D> contours);
	// void genOutliers(ArrayList<Contour2D> contours, int idx);
	// 
	// void genMedian(Contour2D contours);
	// void genMedian(Contour2D contours, int idx);
	// 
	// void genMean(Contour2D contours);
	// void genMean(Contour2D contours, int idx);
}