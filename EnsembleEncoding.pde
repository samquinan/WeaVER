class EnsembleEncoding implements EncodesSP, EncodesCBP {
	
	// SP
	ArrayList< ArrayList<Field> > members;
	ArrayList< ArrayList<Contour2D> > cached_sp;
	ArrayList<String> labels;
	
	ContourBoxPlot cbp;
	
	private boolean initComplete;
	float isovalue;
	
	// CBP
	// ColorMapf cmap;
	// boolean bilinear;
	// boolean interpolate;
	//
	// ArrayList < Field > bands;
	// ArrayList< ArrayList<Contour2D> > outliers;
	
	EnsembleEncoding(ArrayList< ArrayList<Field> > fields, ContourBoxPlot c){
		members = fields;
		cbp = c;
		initComplete = false;
		cached_sp = null;
		// bilinear = true;
		// interpolate = false;
		genMemberLabels();	
	}
	
	EnsembleEncoding(ArrayList< ArrayList<Field> > fields, ContourBoxPlot c, ArrayList<String> member_labels){
		members = fields;
		cbp = c;
		initComplete = false;
		cached_sp = null;
		// bilinear = true;
		// interpolate = false;
		if (members.size() != member_labels.size()){
			println("ERROR: Number of labels for EnsembleEncoding does not match number of members");
			genMemberLabels();
		}
		else labels = member_labels;
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
			Contour2D c;
			ArrayList<Field> member;
			for (int i = 0; i < members.size(); i++){
				member = members.get(i);
				Field f = member.get(0);
				c = new Contour2D(2*f.dimy);
				f.genIsocontour(isovalue, c);
				c.setID(labels.get(i));
				contours.add(c);
			}
		}
		else{
			contours.addAll(cached_sp.get(0));
		}
	}
	
	void genSPContours(ArrayList<Contour2D> contours, int idx){
		if (cached_sp == null){
			Contour2D c;
			ArrayList<Field> member;
			for (int i = 0; i < members.size(); i++){
				member = members.get(i);
				Field f = member.get(idx);
				c = new Contour2D(2*f.dimy);
				f.genIsocontour(isovalue, c);
				c.setID(labels.get(i));
				contours.add(c);
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
				// ArrayList<Field> member;
				for (int i = 0; i < members.size(); i++){
					// member = members.get(i);
					Field f = (members.get(i)).get(idx);
					c = new Contour2D(2*f.dimy);
					f.genIsocontour(isovalue, c);
					c.setID(labels.get(i));
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
	
	void getCBPmedian(WrappedContour2D wrapper){
		cbp.getCBPmedian(wrapper);
	}
	
	void getCBPmedian(WrappedContour2D wrapper, int idx){
		cbp.getCBPmedian(wrapper, idx);
	}
	
	
	// Contour2D getCBPmedian(){
	// 	return cbp.getCBPmedian();
	// }
	// Contour2D getCBPmedian(int idx){
	// 	return cbp.getCBPmedian(idx);
	// }
	
	// ArrayList<Contour2D> getCBPoutliers(){
	// 		return cbp.getCBPoutliers();
	// }
	// ArrayList<Contour2D> getCBPoutliers(int idx){
	// 		return cbp.getCBPoutliers(idx);
	// }
	
	void getCBPoutliers(ArrayList<Contour2D> contours){
		cbp.getCBPoutliers(contours);
	}
	void getCBPoutliers(ArrayList<Contour2D> contours, int idx){
		cbp.getCBPoutliers(contours, idx);
	}
	
	void genCBPbands(PImage img, ColorMapf cmap, ColorMapf cmap2){
		cbp.genCBPbands(img, cmap, cmap2);	
	}
	void genCBPbands(PImage img, ColorMapf cmap, ColorMapf cmap2, int idx){
		cbp.genCBPbands(img, cmap, cmap2, idx);
	}
	
	
		
}
