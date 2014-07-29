public interface EncodesScalar extends HandlesMissingData{
	ColorMapf getColorMap();
	void genContours(ArrayList<Contour2D> contours);
	void genContours(ArrayList<Contour2D> contours, int idx);
	void genFill(PImage img);
	void genFill(PImage img, int idx);
}