public interface QuadTreeElement{
	boolean intersectsAABB(float minx, float miny, float maxx, float maxy);
	PVector getClosestPoint(float x, float y);
}