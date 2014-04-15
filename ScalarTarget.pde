class ScalarTarget extends ScalarTargetBase {
	
	ScalarTarget(float ix, float iy, float dx, float dy) {
		super(ix, iy, dx, dy);		
	}
	
	void add(Selectable s){
		if (s instanceof EncodesScalar){
			super.add(s);	
		}
	}
	
	boolean isIntersectedAABB(Selectable s){
		boolean tmp = super.isIntersectedAABB(s);
		highlight = highlight && (s instanceof EncodesScalar);
		return tmp;
	}
	
	void updateRenderContext(){ //defaults to cached update
		int n = entries.size();
		switch(n){
			case 0:
				clearRenderContext();
				break;
			case 1:
			default:
				noCacheUpdate();
				cacheCurrent();
				break;
		}
	}
	
	void updateRenderContext(boolean cache){
		int n = entries.size();
		switch(n){
			case 0:
				clearRenderContext();
				break;
			case 1:
			default:
				noCacheUpdate();
				if (cache) cacheCurrent();
				break;
		}
	}
	
	void cacheRenderContext(){
		int n = entries.size();
		switch(n){
			case 0:
				break;
			case 1:
			default:
				cacheCurrent();
				break;
		}
	}
	
	private void clearRenderContext(){
		if (layer0 != null){
			//clear image
			layer0.loadPixels();
			int dim = layer0.width * layer0.height;
			for (int i=0; i < dim; i++){
				layer0.pixels[i] = color(0,0,0,0);
			}
			layer0.updatePixels();
		}
		if (legend != null) legend.setColorMap(null);
		if (layer1 != null) layer1.clear();
		if (qtree != null) qtree.clear();
	}
		
	private void noCacheUpdate(){
		int fhr = timer.getIndex();
		//fill
		if (layer0 != null){
			EncodesScalar s = (EncodesScalar) entries.get(0);
			if (s != null){
				s.genFill(layer0, fhr);
				if (legend != null){
					legend.setColorMap(s.getColorMap());
				}
			}
			
		}
		//contours
		if (layer1 != null){
			layer1.clear();
			EncodesScalar s = (EncodesScalar) entries.get(0);
			if (s != null){
				s.genContours(layer1, fhr);
				//quadtree
				if (qtree != null){
					qtree.clear();
				}
			}
		}
	}
	
	private void cacheCurrent(){
		//contours
		if (layer1 != null){
			//quadtree
			if (qtree != null){
				qtree.clear();
				for (Contour2D c: layer1){
					c.addAllSegmentsToQuadTree(qtree);
				}
			}
			//cache contours
			for (Contour2D c: layer1){
				c.genPShape();
			}
		}
	}
			
}