class ColorMapf {
	int conversionState;
	
	ArrayList<Float> val;
	ArrayList<Integer> col;
		
	ColorMapf(){
		val = new ArrayList<Float>();
		col = new ArrayList<Integer>();
		conversionState = 0;
	}
	
	ColorMapf(int initalCapacity){
		val = new ArrayList<Float>(initalCapacity);
		col = new ArrayList<Integer>(initalCapacity);
		conversionState = 0;
	}
	
	void convert_none(){
		conversionState = 0;
	}
	
	void convert_K2C(){
		conversionState = 1;
	}
	
	void convert_K2F(){
		conversionState = 2;
	}
	
	void convert_mps2mph(){
		conversionState = 3;
	}
	
	void convert_mps2kts(){
		conversionState = 4;
	}
	
	int getConversionState(){
		return conversionState;
	}
	
	void add(float v, int c){
		if (val.size() == 0){
			val.add(v);
			col.add(c);
		}
		else {
			//binary search
			int imin = 0;
			int imax = val.size()-1;
		
			while (imin < imax){
				int imid = (imin+imax)/2;
			
				if(val.get(imid) < v){
					imin = imid + 1;
				}
				else{
					imax = imid;
				}
			}
		
			//insert
			if (val.get(imin) >= v){
				val.add(imin, v);
				col.add(imin, c);
			}
			else{
				val.add(v);
				col.add(c);
			}
			
			
		}
	}
	
	color getColor(float v){ //defaults to continuous mapping
		
		if (v < val.get(0)){
			/*println("WARNING in ColorMapf 'getColor': Out of bounds request");*/
			return (color) col.get(0);
		}
		else if (v > val.get(val.size()-1)){
			/*println("WARNING in ColorMapf 'getColor': Out of bounds request");*/
			return (color) col.get(val.size()-1);
		}
		
		//binary search
		int imin = 0;
		int imax = val.size()-1;
	
		while (imin < imax){
			int imid = (imin+imax)/2;
		
			if(val.get(imid) < v){
				imin = imid + 1;
			}
			else{
				imax = imid;
			}
		}
		
		//interpolate
		float vMin, vMax;
		vMin = val.get(imin);
		vMax = vMin;
		color c0, c1;
		c0 = (color) col.get(imin);
		c1 = c0;
		if (vMin < v){
			vMax = val.get(imin+1);
			c1 = (color) col.get(imin+1);
		}
		else if (vMax > v){
			 vMin = val.get(imin-1);
			 c0 = (color) col.get(imin-1);
		}
		
		float a = map(v, vMin, vMax, 0.0, 1.0);
		return lerpColor(c0,c1,a);
	}
	
	color getColor(float v, boolean continuous){
		
		if (v < val.get(0)){
			/*println("WARNING in ColorMapf 'getColor': Out of bounds request");*/
			return (color) col.get(0);
		}
		else if (v > val.get(val.size()-1)){
			/*println("WARNING in ColorMapf 'getColor': Out of bounds request");*/
			return (color) col.get(val.size()-1);
		}
		
		//binary search
		int imin = 0;
		int imax = val.size()-1;
	
		while (imin < imax){
			int imid = (imin+imax)/2;
		
			if(val.get(imid) <= v){
				imin = imid + 1;
			}
			else{
				imax = imid;
			}
		}
		
		if (!continuous) return (color) col.get(imin); //colors interval greater than or equal to lower
		
		//interpolate
		float vMin, vMax;
		vMin = val.get(imin);
		vMax = vMin;
		color c0, c1, c;
		c0 = (color) col.get(imin);
		c1 = c0;
		if (vMin < v){
			vMax = val.get(imin+1);
			c1 = (color) col.get(imin+1);
		}
		else if (vMax > v){
			 vMin = val.get(imin-1);
			 c0 = (color) col.get(imin-1);
		}
		else return c0;
		
		float a = map(v, vMin, vMax, 0.0, 1.0);
		c = lerpColor(c0,c1,a);
		return c;
	}
	
	void print(){
		println("ColorMapf:");
		for (int i=0; i < val.size(); i++){
			println(val.get(i) + " , " + hex(col.get(i)));
			//println(val.get(i));
		}
	}

}