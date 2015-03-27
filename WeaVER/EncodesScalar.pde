public interface EncodesScalar extends EncodesContour{
	ColorMapf getColorMap();
	void genFill(PImage img);
	void genFill(PImage img, int idx);
}