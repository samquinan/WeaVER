public interface EncodesContour extends HandlesMissingData{
	void genContours(ArrayList<Contour2D> contours);
	void genContours(ArrayList<Contour2D> contours, int idx);
}