class ScalarEncoding extends ContourEncoding implements EncodesScalar{
	
	ScalarEncoding(Field f){
		super(f);
		
		cmap.add(fields.get(0).getMin(), color(0, 0, 0, 0));
		cmap.add(fields.get(0).getMax(), color(0, 0, 0, 0));
	}
	
	ScalarEncoding(ArrayList<Field> f){
		super(f);
				
		cmap.add(fields.get(0).getMin(), color(0, 0, 0, 0));
		cmap.add(fields.get(0).getMax(), color(0, 0, 0, 0));
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