public interface Target{
	boolean isHovering();
	void updateRenderContext();
	void updateRenderContext(boolean cache);
	void cacheRenderContext();
}