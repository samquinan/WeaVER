class ScalarEncoding extends EncodingBase implements EncodesScalar{
	ArrayList<Field> fields;
	
	ScalarEncoding(Field f){
		super();
		fields = new ArrayList<Field>();
		fields.add(f);
		
		cmap.add(fields.get(0).getMin(), color(0, 0, 0, 0));
		cmap.add(fields.get(0).getMax(), color(0, 0, 0, 0));
	}
	
	ScalarEncoding(ArrayList<Field> f){
		super();
		fields = f;
		
		cmap.add(fields.get(0).getMin(), color(0, 0, 0, 0));
		cmap.add(fields.get(0).getMax(), color(0, 0, 0, 0));
	}
			
	void genIsovalues(float dv){
		float intercept = 0;
		float vmin, vmax;
		vmin = fields.get(0).getMin();
		vmax = fields.get(0).getMax();
		
		float iso = intercept + floor((vmin - intercept)/dv)*dv;
		while (iso < vmax){
			isovalues.add(iso);
			iso += dv;
		}
	}
	
	void genIsovalues(float intercept, float dv){
		float vmin, vmax;
		vmin = fields.get(0).getMin();
		vmax = fields.get(0).getMax();
		
		float iso = intercept + floor((vmin - intercept)/dv)*dv;
		while (iso < vmax){
			isovalues.add(iso);
			iso += dv;
		}
	}
	
	void genContours(ArrayList<Contour2D> contours){
		Contour2D c;
		Field f = fields.get(0);
		for (Float iso: isovalues){
			  c = new Contour2D(2*f.dimy);
			  f.genIsocontour(iso, c);
			  c.setID(Float.toString(iso)); 
		   	  contours.add(c);
		}
	}
	
	void genContours(ArrayList<Contour2D> contours, int idx){
		Contour2D c;
		Field f = fields.get(idx);
		for (Float iso: isovalues){
			  c = new Contour2D(2*f.dimy);
			  f.genIsocontour(iso, c);
			  c.setID(Float.toString(iso)); 
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
	
}