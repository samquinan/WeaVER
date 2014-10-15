class ConditionTarget extends ScalarTargetBase {
	
	ArrayList<Float> isovalues, iso_alt;	
	ColorMapf cmap, cmap_alt;
	boolean bilinear;
	boolean interpolate;
	boolean independent;
	
	ConditionTarget(float ix, float iy, float dx, float dy) {
		super(ix, iy, dx, dy);
		cmap = new ColorMapf();
		cmap.add(0.0, color(0, 0, 0, 0));//TODO hardcoding max min values bad form
		cmap.add(100.0, color(0, 0, 0, 0));
		
		cmap_alt = cmap;
				
		isovalues = new ArrayList<Float>();
		iso_alt = new ArrayList<Float>();
		
		bilinear = true;
		interpolate = false;
		independent = false;		
	}
	
	ConditionTarget(float ix, float iy, float dx, float dy, int c, int r) {
		super(ix, iy, dx, dy, c, r);
		cmap = new ColorMapf();
		cmap.add(0.0, color(0, 0, 0, 0));//TODO hardcoding max min values bad form
		cmap.add(100.0, color(0, 0, 0, 0));
				
		cmap_alt = cmap;
		
		isovalues = new ArrayList<Float>();
		iso_alt = new ArrayList<Float>();
		
		bilinear = true;
		interpolate = false;
		independent = false;		
	}
	
	void treatConditionsAsIndependent(boolean b){
		independent = b;
	}
	
	void useBilinear(boolean b){
		bilinear = b;
	}
	
	void useInterpolation(boolean b){
		interpolate = b;
	}
	
	// ColorMapf getColorMap(){
	// 	return cmap;
	// }
		
	void setColorMap(ColorMapf c){
		cmap = c;
		cmap_alt = cmap;
	}
	
	void setColorMap(ColorMapf c, ColorMapf alt){
		cmap = c;
		cmap_alt = alt;
	}
	
	void addIsovalue(float iso){
		isovalues.add(iso);
	}
	                                                                
	void addIsovalue(float iso, boolean alt){                       
		if (alt) iso_alt.add(iso);                                      
		else isovalues.add(iso);
	}
	
	void addIsovalues(ArrayList<Float> list){
		isovalues.addAll(list);
	}
	
	void addIsovalues(ArrayList<Float> list, boolean alt){
		if (alt) iso_alt.addAll(list);
		else isovalues.addAll(list);
	}
	
	
	void genIsovalues(float intercept, float dv, float vmin, float vmax){
		float iso = intercept + floor((vmin - intercept)/dv)*dv;
		while (iso < vmax){
			isovalues.add(iso);
			iso += dv;
		}	
	}
	
	void genIsovalues(float intercept, float dv, float vmin, float vmax, boolean alt){
		float iso = intercept + floor((vmin - intercept)/dv)*dv;
		while (iso < vmax){
			if (alt) iso_alt.add(iso);
			else isovalues.add(iso);
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
	
	void genIsovalues(float dv, float vmin, float vmax, boolean alt){
		float intercept = 0;
		float iso = intercept + floor((vmin - intercept)/dv)*dv;
		while (iso < vmax){
			if (alt) iso_alt.add(iso);
			else isovalues.add(iso);
			iso += dv;
		}	
	}
	
	
	boolean add(Selectable s){
		if (s instanceof HandlesConditions){
			return super.add(s);
		}
		else return false;
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
	
	private Field generateProbabilityField(){ //does not treat as independent
		int fhr = (timer == null) ? 0 : timer.getIndex();
		Iterator<Selectable> it = entries.iterator();
		Set<String> err_set = new HashSet<String>();
		ConditionEnsemble build = null;
		boolean first = true;
		while (it.hasNext()){
			Selectable s = it.next();
			String id = s.getID();
			HandlesConditions select = (HandlesConditions) s;
			if (select != null){
				if (select.dataIsAvailable(fhr)){
					if (first){
						build = select.getConditionCopy(fhr);
						first = false;
					}
					else if (build != null) build.makeJointWith(select.getCondition(fhr));
				}
				else{
					err_set.add(id);
					build = null;
				}
			}
		}
		
		StringBuilder buff = new StringBuilder();
		String sep = "";
		for (String str : err_set) {
		    buff.append(sep);
		    buff.append(str);
		    sep = ", ";
		}
		err_out = buff.toString();
		
		if (build != null) return build.genProbabilityField();
		return null;		
	}
	
	private Field generateProbabilityField(boolean treatIndependent){
		int fhr = (timer == null) ? 0 : timer.getIndex();
		Iterator<Selectable> it = entries.iterator();
		Set<String> err_set = new HashSet<String>();
		ConditionEnsemble build = null;
		Field build2 = null;
		boolean first = true;
		while (it.hasNext()){
			Selectable s = it.next();
			String id = s.getID();
			HandlesConditions select = (HandlesConditions) s;
			if (select != null){
				if (select.dataIsAvailable(fhr)){
					if (first){
						if (treatIndependent) build2 = (select.getCondition(fhr)).genProbabilityField();
						else build = select.getConditionCopy(fhr);
						first = false;
					}
					else if (build != null) build.makeJointWith(select.getCondition(fhr));
					else if (build2 != null) build2.test_multiplyProb((select.getCondition(fhr)).genProbabilityField());
				}
				else{
					err_set.add(id);
					build = null;
					build2 = null;
					first = false;
				}
			}
		}
		
		StringBuilder buff = new StringBuilder();
		String sep = "";
		for (String str : err_set) {
		    buff.append(sep);
		    buff.append(str);
		    sep = ", ";
		}
		err_out = buff.toString();
		if (build != null) return build.genProbabilityField();
		else if (build2 != null) return build2;
		return null;
	}
	

	private void clearRenderContext(){
		err_out = "";
		clearDrawables();
	}
	
	private void clearDrawables(){
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
		Field current = generateProbabilityField(independent);
		if (current != null){
			boolean goAlt = entries.size()>1;
			//fill
			if (layer0 != null){
				ColorMapf cmap_cur = goAlt ? cmap_alt : cmap;
				//gen fill
				if (bilinear){
					current.genFillBilinear(layer0, cmap_cur, interpolate);
				}
				else{
					current.genFillNearestNeighbor(layer0, cmap_cur, interpolate);
				}
				//update legend		
				if (legend != null){
					legend.setColorMap(cmap_cur);
				}
			}
			//contours
			if (layer1 != null){
				layer1.clear();
				//gen contours
				ArrayList<Float> iso_cur = (goAlt && (iso_alt.size() > 0)) ? iso_alt : isovalues;
				Contour2D c;
				for (Float iso: iso_cur){
					  c = new Contour2D(2*current.dimy);
					  current.genIsocontour(iso, c);
					  c.setID(Float.toString(iso)); 
				   	  layer1.add(c);
				}
				for (StickyLabel l : labels){
					int i = l.getMemberIndex();
					c = layer1.get(i);
					if (c != null){
						l.update(c);
					}
				}
				//quadtree
				if (qtree != null){
					qtree.clear();
				}
			}
		}
		else {
			clearDrawables();
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