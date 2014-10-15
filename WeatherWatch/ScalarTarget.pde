class ScalarTarget extends ScalarTargetBase {
	
	ScalarTarget(float ix, float iy, float dx, float dy) {
		super(ix, iy, dx, dy);		
	}
	
	boolean add(Selectable s){
		if ((layer0 != null)?(s instanceof EncodesScalar):(s instanceof EncodesContour)){
			return super.add(s);	
		}
		else return false;
	}
	
	boolean isIntersectedAABB(Selectable s){
		boolean tmp = super.isIntersectedAABB(s);
		highlight = highlight && ((layer0 != null)?(s instanceof EncodesScalar):(s instanceof EncodesContour));
		hover = hover && !highlight;
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
		err_out = "";
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
		if (labels != null) labels.clear();
	}
		
	private void noCacheUpdate(){
		int fhr = (timer == null) ? 0 : timer.getIndex();
		String id = entries.get(0).getID();
		//fill
		if (layer0 != null){
			EncodesScalar s = (EncodesScalar) entries.get(0);
			if (s != null){
				if (s.dataIsAvailable(fhr)){
					err_out = "";
					s.genFill(layer0, fhr);
					if (legend != null){
						legend.setColorMap(s.getColorMap());
					}
				}
				else{
					if ("".equals(id.trim())) err_out = "color map"; //TODO gracefully handle colormap and contour case
					else err_out = id;
					//clear image
					layer0.loadPixels();
					int dim = layer0.width * layer0.height;
					for (int i=0; i < dim; i++){
						layer0.pixels[i] = color(0,0,0,0);
					}
					layer0.updatePixels();
					// null color map
					if (legend != null) legend.setColorMap(null);
				}
			}
			
		}
		//contours
		if (layer1 != null){
			layer1.clear();
			EncodesContour s = (EncodesContour) entries.get(0);
			if (s != null){
				if (s.dataIsAvailable(fhr)){
					err_out = "";
					s.genContours(layer1, fhr);
					for (StickyLabel l : labels){
						int i = l.getMemberIndex();
						Contour2D c = layer1.get(i);
						if (c != null){
							l.update(c);
						}
					}
					//quadtree
					if (qtree != null){
						qtree.clear();
					}
				}
				else{
					if ("".equals(id.trim())) err_out = "contours";
					else err_out = id;
					layer1.clear();
					if (qtree != null) qtree.clear();
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
