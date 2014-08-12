class ContourBoxPlot {//implements EncodesCBP{
	// color c_band, c_envl;
	// ColorMapf cmap, cmap2;
	boolean bilinear;
	boolean interpolate;
	
	ArrayList < Field > bands;
	ArrayList < Field > envelop;
	ArrayList < Integer > ordering;
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
		bands = b;
		envelop = e;
				
		ordering = o;
		
		bilinear = true;
		interpolate = false;
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
		if (img != null){
			if (bilinear){
				(envelop.get(0)).genFillBilinear(img, cmap2, interpolate, true);
				(bands.get(0)).genFillBilinear(img, cmap, interpolate, false);
			}
			else{
				(envelop.get(0)).genFillNearestNeighbor(img, cmap2, interpolate, true);
				(bands.get(0)).genFillNearestNeighbor(img, cmap, interpolate, false);
			}
		}
		return;
	}

	void genCBPbands(PImage img, ColorMapf cmap, ColorMapf cmap2, int idx){
		if (img != null){
			if (bilinear){
				(envelop.get(idx)).genFillBilinear(img, cmap2, interpolate, true);
				(bands.get(idx)).genFillBilinear(img, cmap, interpolate, false);
			}
			else{
				(envelop.get(idx)).genFillNearestNeighbor(img, cmap2, interpolate, true);
				(bands.get(idx)).genFillNearestNeighbor(img, cmap, interpolate, false);
			}
		}
		return;
	}	
		
}