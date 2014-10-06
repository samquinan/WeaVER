class Legend {
	PImage img;
	ColorMapf cmap;
	boolean interpolate;
	/*boolean convert;*/
	float x,y;
	int w,h;
	int m,n;
	
	Converter convert;	
	
	Legend(float ix, float iy, int iw, int ih){
		x = ix;
		y = iy; 
		w = iw;
		h = ih;
		
		n=0;
		m=0;
		
		cmap = null;
		
		img = createImage(int(w), int(h), ARGB);
		
		interpolate=false;
		/*convert = false;*/
		
		convert = new Converter();
	}
	
	void useInterpolation(boolean b){
		interpolate = b;
		update();
	}
	
	void setColorMap(ColorMapf c){
		cmap = c;
		update();
	}
	
	/*void convertToCelcius(boolean b){
		convert = b;
	}*/
	
	void display(){
		
		if (cmap == null || cmap.col.size() < 2) return; 
		
		//outline
		strokeWeight(1);
		stroke(30);
		noFill();
		rect(x-1,y-1,w+1,h+1);
		image(img, x, y);
		
		float vmin, vmax;
		vmin = cmap.val.get(n);
		vmax = cmap.val.get(m);
		
		fill(0);
		textAlign(RIGHT, CENTER);
		for(int i=n; i<=m; i++){
			float val = cmap.val.get(i);
			float tag_y = map(val, vmax, vmin, 0, h);
			int cstate = cmap.getConversionState();
			switch (cstate){
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
				default:
					break;
			}
			//line(x-10, y+tag_y, x-5, y+tag_y);
			//if (convert) val = cc.K_to_C(val);
			text(Float.toString(val), x-3, y-2+tag_y);
		}
		
	}
	
	private void update(){
		
		if (cmap == null || cmap.col.size() < 2) return; //short circut
		
		n = 0;
		m = cmap.col.size()-1;
		
		//ignore leading transparent entries
		color c = (color) cmap.col.get(n);
		while (alpha(c) == 0){
			n++;
			c = (color) cmap.col.get(n);
		}
		if (interpolate) n = max(0, --n);//handle blending into transparent
		
		//ignore trailing transparent entries
		c = (color) cmap.col.get(m);
		while (alpha(c) == 0){
			m--;
			c = (color) cmap.col.get(m);
		}
		if (interpolate) m = min(cmap.col.size()-1, ++m);//handle blending into transparent
		
		// create legend
		img.loadPixels();
		
		float vmin, vmax;
		vmin = cmap.val.get(n);
		vmax = cmap.val.get(m);
		
	  	for (int y = 0; y < img.height; y++){
	  		for (int x = 0; x < img.width; x++){
				float val = map(y, 0, img.height-1, vmax, vmin);
				c = cmap.getColor(val, interpolate);
				
				img.pixels[getIndex(x,y,img.width)] = c;
			}
		}
		
		img.updatePixels();
	}
	
    private int getIndex(int x, int y, int N)
    {
       int idx = (y*N)+x;
       return idx;
    }
}