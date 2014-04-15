class WindField extends Field {	
	//data is speed -- as this is the quantity defaulted to for non-vector displays
	//data2 is direction
	FloatList data2;
	
	WindField(String file, String file2, int dx, int dy, PVector offset, float maxh, float maxw){
		//load speed
		super(file, dx, dy, offset, maxh, maxw);
		//load direction in radians
		data2 = new FloatList();
	    String[] lines = loadStrings(file2);  
	    for(String line: lines)
	    {
	      float val = float(line.trim());
	      data2.append(val);
	    } 	
	}
	
	void generateBarbs(ArrayList<Barb> barbs, BarbGlyphList src){
		int k = ceil(32/spacing);
		int countx = floor(float(dimx)/k);
		int county = floor(float(dimy)/k);
		
		float span_x, span_y;
		span_x = countx * k;
		span_y = county * k;
		
		int x_start = floor((dimx - span_x)/2);
		int y_start = floor((dimy - span_y)/2);
		
		for (int i=0; i < countx; i++){
			for(int j=0; j < county; j++){
				int x = x_start + round(k/2.0) + i*k; 
				int y = y_start + round(k/2.0) + j*k;
				int idx = (y*dimx)+x;
				float tmp = data.get(idx);
				
				barbs.add(new Barb(viewZero.x+(x+0.5)*spacing, viewZero.y+viewHeight-((y+0.5)*spacing), tmp, data2.get(idx), src.getBarbGlyph(tmp)));
			}
		}	
	}
}