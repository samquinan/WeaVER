class ConditionTarget extends ScalarTargetBase {
	
	ArrayList<Float> isovalues;	
	ColorMapf cmap;
	boolean bilinear;
	boolean interpolate;
	
	ConditionTarget(float ix, float iy, float dx, float dy) {
		super(ix, iy, dx, dy);
		cmap = new ColorMapf();
		cmap.add(0.0, color(0, 0, 0, 0));//TODO hardcoding max min values bad form
		cmap.add(100.0, color(0, 0, 0, 0));
				
		isovalues = new ArrayList<Float>();
		
		bilinear = true;
		interpolate = false;		
	}
	
	ConditionTarget(float ix, float iy, float dx, float dy, int c, int r) {
		super(ix, iy, dx, dy, c, r);
		cmap = new ColorMapf();		
		isovalues = new ArrayList<Float>();
		
		bilinear = true;
		interpolate = false;		
	}
	
	void useBilinear(boolean b){
		bilinear = b;
	}
	
	void useInterpolation(boolean b){
		interpolate = b;
	}
	
	ColorMapf getColorMap(){
		return cmap;
	}
		
	void setColorMap(ColorMapf c){
		cmap = c;
	}
	
	void addIsovalue(float iso){
		isovalues.add(iso);
	}
	
	void addIsovalues(ArrayList<Float> list){
		isovalues.addAll(list);
	}
	
	void genIsovalues(float intercept, float dv, float vmin, float vmax){
		float iso = intercept + floor((vmin - intercept)/dv)*dv;
		while (iso < vmax){
			isovalues.add(iso);
			iso += dv;
		}	
	}
	
	void genIsovalues(float dv, float vmin, float vmax){
		float intercept = 0;
		float iso = intercept + floor((vmin - intercept)/dv)*dv;
		while (iso < vmax){
			isovalues.add(iso);
			iso += dv;
		}	
	}
	
	void add(Selectable s){
		if (s instanceof HandlesConditions){
			super.add(s);
		}
	}
	
	boolean isIntersectedAABB(Selectable s){
		boolean tmp = super.isIntersectedAABB(s);
		highlight = highlight && (s instanceof HandlesConditions);
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
	
	private Field generateProbabilityField(){
		int fhr = (timer == null) ? 0 : timer.getIndex();
		Iterator<Selectable> it = entries.iterator();
		if (it.hasNext()){ // should always pass b/c never called without at least 1 entry
			HandlesConditions select = (HandlesConditions) it.next();
			if (select != null){
				ConditionEnsemble build = select.getConditionCopy(fhr);
				while (it.hasNext()){
					select = (HandlesConditions) it.next();
					if (select != null) build.makeJointWith(select.getCondition(fhr));
				}
				return build.genProbabilityField();
			}
		}
		return null;
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
		Field current = generateProbabilityField();
		if (current != null){
			//fill
			if (layer0 != null){
				//gen fill
				if (bilinear){
					current.genFillBilinear(layer0, cmap, interpolate);
				}
				else{
					current.genFillNearestNeighbor(layer0, cmap, interpolate);
				}
				//update legend		
				if (legend != null){
					legend.setColorMap(cmap);
				}
			}
			//contours
			if (layer1 != null){
				layer1.clear();
				//gen contours
				Contour2D c;
				for (Float iso: isovalues){
					  c = new Contour2D(2*current.dimy);
					  current.genIsocontour(iso, c);
					  c.setID(Float.toString(iso)); 
				   	  layer1.add(c);
				}
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