class ContourBoxPlot {//implements EncodesCBP{
	// color c_band, c_envl;
	// ColorMapf cmap, cmap2;
	boolean bilinear;
	boolean interpolate;
	
	ArrayList < Field > bands;
	ArrayList < Field > envelop;
	ArrayList < Integer > ordering;
	
	private boolean ignoreLowRes;
	private boolean cacheAuto;
	ArrayList < BitSet > bands_gen;
	ArrayList < BitSet > env_gen;
	
	// ArrayList < Contour2D > median;
	// ArrayList < ArrayList < Contour2D > > outliers;
	//
	// ContourBoxPlot(ArrayList < Contour2D > m, ArrayList < Field > b, ArrayList < Field > e, ArrayList < ArrayList < Contour2D > > o){
	// 	bands = b;
	// 	envelop = e;
	//
	// 	ordering = null;
	//
	// 	median = m;
	// 	outliers = o;
	//
	// 	bilinear = true;
	// 	interpolate = false;
	// }
	
	ContourBoxPlot(ArrayList < Field > b, ArrayList < Field > e, ArrayList < Integer > o){
		ignoreLowRes = false;
		bands = b;
		envelop = e;
				
		ordering = o;
		
		bilinear = true;
		interpolate = false;
		
		cacheAuto = false;
		bands_gen = null;
		env_gen = null;
	}
	
	ContourBoxPlot(ArrayList < Integer > o){
		ignoreLowRes = true;
		bands = null;
		envelop = null;
				
		ordering = o;
		
		bilinear = true;
		interpolate = false;
		
		cacheAuto = false;
		bands_gen = null;
		env_gen = null;
	}
	
	
		
	void useBilinear(boolean b){
		bilinear = b;
	}
	
	void useInterpolation(boolean b){
		interpolate = b;
	}
	
	void setIgnoreLowRes(boolean b){
		ignoreLowRes = b;
	}
	
	boolean ignoreLowRes(){
		return (cacheAuto || ignoreLowRes);
	}
	
	
	// ColorMapf getColorMap(){
	// 	return cmap;
	// }
		
	// void setBandColors(color c0, color c1){ //fix
	// 	c_band = c0;
	// 	c_envl = c1;
	//
	// 	color tmp;
	//
	// 	cmap = new ColorMapf();
	// 	tmp = (0 << 24) | (c_band & 0x00FFFFFF);
	// 	cmap.add(0, tmp);
	// 	cmap.add(0.49, tmp);
	// 	cmap.add(0.5, tmp);
	// 	cmap.add(1.0, c_band);
	//
	// 	cmap2 = new ColorMapf();
	// 	tmp = (0 << 24) | (c_envl & 0x00FFFFFF);
	// 	cmap2.add(0, tmp);
	// 	cmap2.add(0.49, tmp);
	// 	cmap2.add(0.5, tmp);
	// 	cmap2.add(1.0, c_envl);
	// }
	
	// Contour2D getCBPmedian(){
	// 	return median.get(0);
	// }
	//
	// Contour2D getCBPmedian(int idx){
	// 	return median.get(idx);
	// }
	
	int getCBPmedianIndex(){
		if (ordering != null) return ordering.get(0);
		else return -1;		
	}
	
	ArrayList<Integer> getOrdering(){
		if (ordering != null) return ordering;
		else return null;
	}
	
	// void getCBPmedian(WrappedContour2D wrapper){
	// 	if (wrapper != null && median != null) wrapper.replaceContour(median.get(0));
	// }
	//
	// void getCBPmedian(WrappedContour2D wrapper, int idx){
	// 	if (wrapper != null && median != null) wrapper.replaceContour(median.get(idx));
	// }
	
	
	// ArrayList<Contour2D> getCBPoutliers(){
	// 	return outliers.get(0);
	// }
	//
	// ArrayList<Contour2D> getCBPoutliers(int idx){
	// 	return outliers.get(idx);
	// }
	
	List<Integer> getOutlierIndexList(){
		int n = ordering.size();
		if (ordering != null) return ordering.subList(n-3, n);
		else return null;		
	}
	
	// void getCBPoutliers(ArrayList<Contour2D> contours){
	// 	if (contours != null && outliers != null) contours.addAll(outliers.get(0));
	// }
	//
	// void getCBPoutliers(ArrayList<Contour2D> contours, int idx){
	// 	if (contours != null && outliers != null) contours.addAll(outliers.get(idx));
	// }
	
	
	void genCBPbands(PImage img, ColorMapf cmap, ColorMapf cmap2){
		if ((img != null) && (bands != null) && (envelop!=null)){
			if (bilinear){
				(envelop.get(0)).genFillBilinear(img, cmap2, interpolate, true);
				(bands.get(0)).genFillBilinear(img, cmap, interpolate, false);
			}
			else{
				(envelop.get(0)).genFillNearestNeighbor(img, cmap2, interpolate, true);
				(bands.get(0)).genFillNearestNeighbor(img, cmap, interpolate, false);
			}
		}
		else println("ERROR: [genCBPbands] either image null, or low res masks not loaded");
		return;
	}

	void genCBPbands(PImage img, ColorMapf cmap, ColorMapf cmap2, int idx){
		if ((img != null) && (bands != null) && (envelop!=null)){
			if (bilinear){
				(envelop.get(idx)).genFillBilinear(img, cmap2, interpolate, true);
				(bands.get(idx)).genFillBilinear(img, cmap, interpolate, false);
			}
			else{
				(envelop.get(idx)).genFillNearestNeighbor(img, cmap2, interpolate, true);
				(bands.get(idx)).genFillNearestNeighbor(img, cmap, interpolate, false);
			}
		}
		else println("ERROR: [genCBPbands] either image null, or low res masks not loaded");
		return;
	}
	
	boolean isBandCached(){
		return cacheAuto;
	}
	
	BitSet getCachedBand(int idx){
		return bands_gen.get(idx);
	}
	
	BitSet getCachedEnvelope(int idx){
		return env_gen.get(idx);
	}
	
	void cacheCBPbands(ArrayList< ArrayList<Field> > members, int w, int h, float isovalue){
		cacheAuto = true;		
		
		ArrayList<Field> member = members.get(0);
		int maxIdx = member.size();
		int n = w*h;
		int half = round(ordering.size()/2.0);
		int whole = ordering.size() - 3;
		
		bands_gen = new ArrayList< BitSet >(maxIdx);
		env_gen = new ArrayList< BitSet >(maxIdx);
		
		for (int idx=0; idx < maxIdx; idx++){
			long startTime = System.currentTimeMillis();
					
			boolean[] union =  new boolean[n];
			Arrays.fill(union, false);
			boolean[] intersection =  new boolean[n];
			Arrays.fill(intersection, true);
			
			/*BitSet union = new BitSet(n);
			BitSet intersection = new BitSet(n);
			intersection.flip(0,intersection.size()-1);// flip all to true
			BitSet mask = new BitSet(n);*/
			
			for (int i=0; i < half; i++){
				member = members.get(ordering.get(i));
				if ((idx==0) && (member.size() != maxIdx)){ //fail gracefully
					println("ERROR: inconsistent timesteps in members supplied to cacheCBPbands");
					cacheAuto = false;
					bands_gen = null;
					env_gen = null;
					return;
				}
				Field f = member.get(idx);
				f.genMaskBilinear(union, intersection, w, h, isovalue);
				/*f.genMaskBilinear(mask, w, h, isovalue);
				union.or(mask);
				intersection.and(mask);*/
			}
			
			boolean[] union_50 = union.clone();
			boolean[] intersection_50 = intersection.clone();
			/*BitSet union_50 = (BitSet) union.clone();
			BitSet intersection_50 = (BitSet) intersection.clone();*/
			
			for (int i=half; i < whole; i++){
				member = members.get(ordering.get(i));
				if ((idx==0) && (member.size() != maxIdx)){ //fail gracefully
					println("ERROR: inconsistent timesteps in members supplied to cacheCBPbands");
					cacheAuto = false;
					bands_gen = null;
					env_gen = null;
					return;
				}
				Field f = member.get(idx);
				f.genMaskBilinear(union, intersection, w, h, isovalue);
				/*f.genMaskBilinear(mask, w, h, isovalue);
				union.or(mask);
				intersection.and(mask);*/
			}
			
			long midTime = System.currentTimeMillis();			
			
			BitSet band = new BitSet(n);
			BitSet env = new BitSet(n);
			for (int i=0; i < n; i++){
				band.set(i,(union_50[i] & !intersection_50[i]));
				env.set(i,(union[i] & !intersection[i]));
			}
			bands_gen.add(band);
			env_gen.add(env);
						
			/*union_50.andNot(intersection_50); // is band
			union.andNot(intersection);// is envelope

			bands_gen.add(union_50);
			env_gen.add(union);*/
			
			long endTime = System.currentTimeMillis();			
			println("cbp: " + ((midTime-startTime)/1000.0) + " s \t" + ((endTime-midTime)/1000.0) + "s");
		}
	}
		

		


		
}