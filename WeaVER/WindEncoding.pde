class WindEncoding extends EncodingBase implements EncodesScalar, EncodesVector{
	ArrayList<WindField> fields;
	BarbGlyphList glyphs;
		
	WindEncoding(WindField f, BarbGlyphList g){
		super();
		fields = new ArrayList<WindField>();
		fields.add(f);
		glyphs = g;
		
		cmap.add(fields.get(0).getMin(), color(0, 0, 0, 0));
		cmap.add(fields.get(0).getMax(), color(0, 0, 0, 0));
	}
		
	WindEncoding(ArrayList<WindField> f, BarbGlyphList g){
		super();
		fields = f;
		glyphs = g;
	}
	
	boolean dataIsAvailable(int idx){
		return fields.get(idx).dataIsAvailable();
	} 
	
	boolean dataIsAvailable(){
		return fields.get(0).dataIsAvailable();
	}
			
	void genIsovalues(float dv){
		float intercept = 0;
		float vmin = 0;
		float vmax = 0;
		boolean first = true;
		
		Iterator<WindField> it = fields.iterator();
		while (it.hasNext()){
			WindField f = it.next();
			if (f.dataIsAvailable()){
				if (first){
					vmin = f.getMin();
					vmax = f.getMax();
					first = false;
				}
				else{
					vmin = min(vmin, f.getMin());
					vmax = max(vmax, f.getMax());
				}
			}
		}
		
		float iso = intercept + floor((vmin - intercept)/dv)*dv;
		while (iso < vmax){
			isovalues.add(iso);
			iso += dv;
		}
	}
	
	void genIsovalues(float intercept, float dv){
		float vmin = 0;
		float vmax = 0;
		boolean first = true;
		
		Iterator<WindField> it = fields.iterator();
		while (it.hasNext()){
			WindField f = it.next();
			if (f.dataIsAvailable()){
				if (first){
					vmin = f.getMin();
					vmax = f.getMax();
					first = false;
				}
				else{
					vmin = min(vmin, f.getMin());
					vmax = max(vmax, f.getMax());
				}
			}
		}
				
		float iso = intercept + floor((vmin - intercept)/dv)*dv;
		while (iso < vmax){
			isovalues.add(iso);
			iso += dv;
		}
	}
	
	void genContours(ArrayList<Contour2D> contours){
		Contour2D c;
		WindField f = fields.get(0);
		for (Float iso: isovalues){
			c = new Contour2D(2*f.dimy);
			f.genIsocontour(iso, c);
			float val = iso;
  	  		switch (conversionState){
  	  			case 1:
  	  				val = convert.K_to_C(val);
  	  				break;
  	  			case 2:
  	  				val = convert.K_to_F(val);
  	  				break;				
  	  			case 3:
  	  				val = convert.mps_to_mph(val);
  	  				break;
  	  			case 4:
  	  				val = convert.mps_to_kt(val);
  	  				break;
	  			case 5:
	  				val = convert.fakeHaines(val);
	  				break;
	  			case 6:
	  				val = convert.kgmm_to_in(val);
	  				break;																																																							
  	  			default:
  	  				break;
  	  		}
			c.setID(df.format(val)); 
			contours.add(c);
		}
	}
	
	void genContours(ArrayList<Contour2D> contours, int idx){
		Contour2D c;
		WindField f = fields.get(idx);
		for (Float iso: isovalues){
			c = new Contour2D(2*f.dimy);
			f.genIsocontour(iso, c);
			float val = iso;
  	  		switch (conversionState){
  	  			case 1:
  	  				val = convert.K_to_C(val);
  	  				break;
  	  			case 2:
  	  				val = convert.K_to_F(val);
  	  				break;				
  	  			case 3:
  	  				val = convert.mps_to_mph(val);
  	  				break;
  	  			case 4:
  	  				val = convert.mps_to_kt(val);
  	  				break;
	  			case 5:
	  				val = convert.fakeHaines(val);
	  				break;
	  			case 6:
	  				val = convert.kgmm_to_in(val);
	  				break;																																																							
  	  			default:
  	  				break;
  	  		}
			c.setID(df.format(val)); 
			contours.add(c);
		}
	}	
	
	void genFill(PImage img){
		if (bilinear){
			(fields.get(0)).genFillBilinear(img, cmap, interpolate);
		}
		else{
			(fields.get(0)).genFillNearestNeighbor(img, cmap, interpolate);
		}
	}
	
	void genFill(PImage img, int idx){
		if (bilinear){
			(fields.get(idx)).genFillBilinear(img, cmap, interpolate);
		}
		else{
			(fields.get(idx)).genFillNearestNeighbor(img, cmap, interpolate);
		}
	}
	
	void genBarbs(ArrayList<Barb> barbs){
		(fields.get(0)).generateBarbs(barbs, glyphs);
	}
	
	void genBarbs(ArrayList<Barb> barbs, int idx){
		(fields.get(idx)).generateBarbs(barbs, glyphs);
	}
	
}