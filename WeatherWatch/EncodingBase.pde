abstract class EncodingBase {
	ColorMapf cmap;
	ArrayList<Float> isovalues;	
	boolean bilinear;
	boolean interpolate;
	Converter convert;
	int conversionState;
	
	protected EncodingBase(){		
		cmap = new ColorMapf();		
		isovalues = new ArrayList<Float>();
		
		bilinear = true;
		interpolate = false;
		convert = null;
		conversionState = 0;
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
	
	void convert_none(){
		conversionState = 0;
		convert = null;
	}
	
	void convert_K2C(){
		conversionState = 1;
		if(convert == null) convert = new Converter();
	}
	
	void convert_K2F(){
		conversionState = 2;
		if(convert == null) convert = new Converter();
	}
	
	void convert_mps2mph(){
		conversionState = 3;
		if(convert == null) convert = new Converter();
	}
	
	void convert_mps2kts(){
		conversionState = 4;
		if(convert == null) convert = new Converter();
	}
	
	int getConversionState(){
		return conversionState;
	}
	
	
	abstract void genIsovalues(float dv);
	abstract void genIsovalues(float intercept, float dv);
}