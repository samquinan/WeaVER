abstract class EncodingBase {
	ColorMapf cmap;
	ArrayList<Float> isovalues;	
	boolean bilinear;
	boolean interpolate;	
	
	protected EncodingBase(){		
		cmap = new ColorMapf();		
		isovalues = new ArrayList<Float>();
		
		bilinear = true;
		interpolate = false;
	}
			
	void useBilinear(boolean b){
		bilinear = b;
	}
	
	void useInterpolation(boolean b){
		interpolate = b;
	}
	
	ColorMapf getColorMap(){
		return cmap;
	}
		
	void setColorMap(ColorMapf c){
		cmap = c;
	}
	
	void addIsovalue(float iso){
		isovalues.add(iso);
	}
	
	void addIsovalues(ArrayList<Float> list){
		isovalues.addAll(list);
	}
	
	abstract void genIsovalues(float dv);
	abstract void genIsovalues(float intercept, float dv);
}