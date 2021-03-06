class EnsembleEncoding implements EncodesSP, EncodesCBP {
	
	// SP
	ArrayList< ArrayList<Field> > members;
	ArrayList< ArrayList<Contour2D> > cached_sp;
	ArrayList<String> labels;
	ArrayList<Contour2D> tmp;
	float vMax, vMin;
	
	ContourBoxPlot cbp;
	
	private boolean initComplete;
	float isovalue;
		
	EnsembleEncoding(ArrayList< ArrayList<Field> > fields, ContourBoxPlot c){
		members = fields;
		cbp = c;
		initComplete = false;
		cached_sp = null;
		cacheSPContours();
		tmp = new ArrayList<Contour2D>();
		genMemberLabels();	
		
		
		vMax = 0;
		vMin = 0;
		boolean first = true;
		for (ArrayList<Field> member : members){
			for (Field current : member){
				if (first){
					vMax = current.getMax();
					vMin = current.getMin();
					first = false;
				}
				else{
					vMax = max(vMax, current.getMax());
					vMin = min(vMin, current.getMin());
				}
			}
		}
		
	}
	
	EnsembleEncoding(ArrayList< ArrayList<Field> > fields, ContourBoxPlot c, ArrayList<String> member_labels){
		members = fields;
		cbp = c;
		initComplete = false;
		cached_sp = null;
		cacheSPContours();
		if (members.size() != member_labels.size()){
			println("ERROR: Number of labels for EnsembleEncoding does not match number of members");
			genMemberLabels();
		}
		else labels = member_labels;
		
		vMax = 0;
		vMin = 0;
		boolean first = true;
		for (ArrayList<Field> member : members){
			for (Field current : member){
				if (first){
					vMax = current.getMax();
					vMin = current.getMin();
					first = false;
				}
				else{
					vMax = max(vMax, current.getMax());
					vMin = min(vMin, current.getMin());
				}
			}
		}
	}
	
	private void genMemberLabels(){
		labels = new ArrayList<String>();
		for (int idx = 0; idx < members.size(); idx++){
			String id = "member " + Integer.toString(idx);
			labels.add(id);
		}
	}
	
	boolean setMemberLabels(ArrayList<String> member_labels){
		if (members.size() != member_labels.size()){
			println("ERROR: Number of labels for EnsembleEncoding does not match number of members");
			return false;
		}
		else {
			labels = member_labels;
			return true;
		}
	}
	
	ArrayList<String> getMemberLabels(){
		return labels;
	}
			
	void genSPContours(ArrayList<Contour2D> contours){
		if (cached_sp == null){
			tmp.clear();
			Contour2D c;
			ArrayList<Field> member;
			for (int i = 0; i < members.size(); i++){
				member = members.get(i);
				Field f = member.get(0);
				c = new Contour2D(2*f.dimy);
				f.genIsocontour(isovalue, c);
				c.setID(labels.get(i));
				c.genPShape();
				contours.add(c);
				tmp.add(c);
			}
		}
		else{
			contours.addAll(cached_sp.get(0));
		}
	}
	
	void genSPContours(ArrayList<Contour2D> contours, int idx){
		if (cached_sp == null){
			tmp.clear();
			Contour2D c;
			ArrayList<Field> member;
			for (int i = 0; i < members.size(); i++){
				member = members.get(i);
				Field f = member.get(idx);
				c = new Contour2D(2*f.dimy);
				f.genIsocontour(isovalue, c);
				c.setID(labels.get(i));
				c.genPShape();
				contours.add(c);
				tmp.add(c);
			}
		}
		else{
			contours.addAll(cached_sp.get(idx));
		}
	}
	
	private void cacheSPContours(){
		int n = (members.get(0)).size();
		int m = members.size();

	    if (cached_sp == null) cached_sp = new ArrayList< ArrayList<Contour2D> >(n);
	    else cached_sp.clear();
             
		if (initComplete){
			for (int idx = 0; idx < n; idx++){
				ArrayList<Contour2D> contours = new ArrayList<Contour2D>(m);
				Contour2D c;
				for (int i = 0; i < members.size(); i++){
					Field f = (members.get(i)).get(idx);
					c = new Contour2D(2*f.dimy);
					f.genIsocontour(isovalue, c);
					c.setID(labels.get(i));
					c.genPShape();
					contours.add(c);
				}
				cached_sp.add(contours);
			}
		}
	}
	
	void setIsovalue(float iso){
		isovalue = iso;
		initComplete = true; //reassigning on change
		if (cached_sp != null) cacheSPContours(); //if cached re-cache
	}
	
	void setCachingSP(boolean b){
		if (b){
			if (cached_sp == null) cacheSPContours(); // if not cached, cache
		}
		else{
			cached_sp = null; // clear cache
		}
	}
	
	boolean ignoreLowRes(){
		return cbp.ignoreLowRes();
	}
	void setIgnoreLowRes(boolean b){
		cbp.setIgnoreLowRes(b);
	}
	
	void getCBPmedian(WrappedContour2D wrapper){
		int member = cbp.getCBPmedianIndex();
		Contour2D c = null;
		if (cached_sp != null){
			if(member != -1) c = (cached_sp.get(0)).get(member);
		}
		else{
			if(member != -1) c = tmp.get(member);
		}
		wrapper.replaceContour(c);
	}
	
	void getCBPmedian(WrappedContour2D wrapper, int idx){
		int member = cbp.getCBPmedianIndex();
		Contour2D c = null;
		if (cached_sp != null){
			if(member != -1) c = (cached_sp.get(idx)).get(member);
		}
		else{
			if(member != -1) c = tmp.get(member);
		}
		wrapper.replaceContour(c);
	}
		
	void getCBPoutliers(ArrayList<Contour2D> contours){
		List<Integer> outlier_idx = cbp.getOutlierIndexList();
		if (outlier_idx != null){
			for(Integer i:outlier_idx){
				Contour2D c = null;
				if (cached_sp != null){
					c = (cached_sp.get(0)).get(i);
				}
				else{
					c = tmp.get(i);
				}
				contours.add(c);
			}
		}		
	}
	
	void getCBPoutliers(ArrayList<Contour2D> contours, int idx){
		List<Integer> outlier_idx = cbp.getOutlierIndexList();
		if (outlier_idx != null){
			for(Integer i:outlier_idx){
				Contour2D c = null;
				if (cached_sp != null){
					c = (cached_sp.get(idx)).get(i);
				}
				else{
					c = tmp.get(i);
				}				
				contours.add(c);
			}
		}		
	}
	
	void genCBPbands(PImage img, ColorMapf cmap, ColorMapf cmap2){
		cbp.genCBPbands(img, cmap, cmap2);
	}
	
	void genCBPbands(PImage img, ColorMapf cmap, ColorMapf cmap2, int idx){
		cbp.genCBPbands(img, cmap, cmap2, idx);
	}
	
	void genCBPbands(PImage img, color c1, color c2, int idx){
		BitSet band = null;
		BitSet envelope = null;
		int n = img.width*img.height;
		
		if (cbp.isBandCached()){
			band = cbp.getCachedBand(idx);
			envelope = cbp.getCachedEnvelope(idx);
		}
		else{
			ArrayList<Integer> ordering = cbp.getOrdering();
			if (ordering != null){
				
				boolean[] union =  new boolean[n];
				Arrays.fill(union, false);
				boolean[] intersection =  new boolean[n];
				Arrays.fill(intersection, true);

				ArrayList<Field> member;
				
				int half = round(ordering.size()/2.0);
				int whole = ordering.size() - 3;

				for (int i=0; i < half; i++){
					member = members.get(ordering.get(i));
					Field f = member.get(idx);
					f.genMaskBilinear(union, intersection, img.width, img.height, isovalue);
				}

				boolean[] union_50 = union.clone();
				boolean[] intersection_50 = intersection.clone();
				
				for (int i=half; i < whole; i++){
					member = members.get(ordering.get(i));
					Field f = member.get(idx);
					f.genMaskBilinear(union, intersection, img.width, img.height, isovalue);
				}
								
				band = new BitSet(n);
				envelope = new BitSet(n);
				for (int i=0; i < n; i++){
					band.set(i,(union_50[i] & !intersection_50[i]));
					envelope.set(i,(union[i] & !intersection[i]));
				}
			}
		}
		
		img.loadPixels();

		if ((band != null) && (envelope != null) && (band.size() >= n) && (envelope.size() >= n) ){
			for (int i=0; i < n; i++){
				color c;
				if (band.get(i)) c = c1;
				else if (envelope.get(i)) c = c2;
				else c = (0 << 24) | (c2 & 0x00FFFFFF);
				img.pixels[i] = c;
			}
		}
		else { //clear image -- fail gracefully
			println("ERROR: [genCBPbands] either band/envelope is either null or of insufficient size for image");
			color c = (0 << 24) | (c2 & 0x00FFFFFF);
			for (int i=0; i < n; i++){
				img.pixels[i] = c;
			}
		}
		
		img.updatePixels();
		
	}
	
	void cacheCBPbands(int w, int h){
		if (initComplete) cbp.cacheCBPbands(members, w, h, isovalue);
		else println("ERROR: cannot run cacheCBPbands until init is complete");
	}
		
}
