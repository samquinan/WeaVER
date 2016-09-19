class ContourBoxPlot {
	boolean bilinear;
	boolean interpolate;
	
	ArrayList < Field > bands;
	ArrayList < Field > envelop;
	ArrayList < Integer > ordering;
	
	private boolean ignoreLowRes;
	private boolean cacheAuto;
	ArrayList < BitSet > bands_gen;
	ArrayList < BitSet > env_gen;
		
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
		
	int getCBPmedianIndex(){
		if (ordering != null) return ordering.get(0);
		else return -1;		
	}
	
	ArrayList<Integer> getOrdering(){
		if (ordering != null) return ordering;
		else return null;
	}
	
	List<Integer> getOutlierIndexList(){
		int n = ordering.size();
		if (ordering != null) return ordering.subList(n-3, n);
		else return null;		
	}	
	
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
					
			boolean[] union =  new boolean[n];
			Arrays.fill(union, false);
			boolean[] intersection =  new boolean[n];
			Arrays.fill(intersection, true);
			
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
			}
			
			boolean[] union_50 = union.clone();
			boolean[] intersection_50 = intersection.clone();

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
			}
						
			BitSet band = new BitSet(n);
			BitSet env = new BitSet(n);
			for (int i=0; i < n; i++){
				band.set(i,(union_50[i] & !intersection_50[i]));
				env.set(i,(union[i] & !intersection[i]));
			}
			bands_gen.add(band);
			env_gen.add(env);
		}
	}
		

		


		
}