class MNSDView extends View {
							   //TODO add 2nd target (texture)
	ScalarTarget mnsd_target0; //TODO deal with same selectable in multiple targets?
	
	PImage fill;
	ArrayList<Contour2D> contours;
	int member_index;
	Legend legend;
	QuadTree_Node<Segment2D> cselect;
	Contour2D highlight;
	
	MNSDView(int sx, int sy, float ds, int cx, int cy, int tw, int th, int libsize){
		super(sx, sy, ds, cx, cy, tw, th, ceil(libsize/2.0));
		
		// Initialize Render State
			//Color Map
		fill = createImage(int(samplesx*spacing), int(samplesy*spacing), ARGB);
		legend = new Legend(cornerx-22,cornery+1,12,int(samplesy*spacing)-2);
		
			//Contours
		contours = new ArrayList<Contour2D>();
		cselect = new QuadTree_Node<Segment2D>(cornerx, cornery, cornerx+samplesx*spacing, cornery+samplesy*spacing, 21);
		highlight = null;
		member_index = -2;
				
		// Initialize Targets
			
		mnsd_target0 = new ScalarTarget(cornerx+10,cornery-tabh-10,tabw,tabh);
		mnsd_target0.linkImage(fill);
		mnsd_target0.linkLegend(legend);
		mnsd_target0.linkContours(contours);
		mnsd_target0.linkQuadTree(cselect);
		mnsd_target0.linkTimeControl(timer);
		mnsd_target0.setLabel("COLOR / CONTOUR");
		library.linkTarget(mnsd_target0);
		targets.add(mnsd_target0);
	}	
	
	void draw(){
		//update state if animating
		updateAnim();
		
		//draw map bg
		fill(255);
		noStroke();
		rect(cornerx, cornery, samplesx*spacing, samplesy*spacing, 0);
	
		//draw map
		if (map != null){
			strokeWeight(2);
			stroke(30,30,30,255);//stroke(85,46,27,255);
			fill(210);//fill(247,241,230);
			shape(map, cornerx+(39*spacing), cornery+(35*spacing), 123*spacing, 75*spacing);
		}
	
		// fill
		image(fill, cornerx, cornery);
	
		// draw outline
		if (map != null){
			strokeWeight(2);
			stroke(255,255,255,255);//stroke(85,46,27,255);
			noFill();
			shape(map, cornerx+(39*spacing), cornery+(35*spacing), 123*spacing, 75*spacing);
		}	
	
		// contours
		//draw contours
		colorMode(HSB, 360, 100, 100, 100);
		stroke(0,0,15,100);
		strokeCap(SQUARE);
		drawContours(contours, color(0,0,0), (mnsd_target0.isHovering() ? 1.0 : 2.0));
		strokeCap(ROUND);
		colorMode(RGB,255);	
		
		// draw controls
		library.display();
		legend.display();
		tracker.display();
		timer.display();
	
		//frame rate for testing
		textSize(10);
		textAlign(RIGHT, BOTTOM);
		fill(70);
		text(frameRate, width-3, height-3);
		textSize(10);
		
		//selection tooltip
		drawToolTip();
	}
	
	protected void drawContours(ArrayList<Contour2D> contours, color select, float weight)
	{
		noFill();
		strokeWeight(weight);
	
		int n = int(contours.size());
		// boolean trigger = false;
	
		//draw all but selection
		Contour2D c;
		for (int i=0; i<n; i++){
			c = contours.get(i);
			if (c == highlight){
				// trigger = true;
				continue;
			}
			c.drawContour();
		}
	
		//draw selection
		if ((highlight != null)){// && trigger){
			strokeWeight(weight+1);
			stroke(select);
			highlight.drawContour();
		}
	}

	protected void drawToolTip(){
		if ((highlight != null)){// && trigger){		
			String s = highlight.getID();
			fill(255,179);
			noStroke();
			rect(mouseX - textWidth(s)/2 -2, mouseY-textAscent()-textDescent()-5, textWidth(s)+4, textAscent()+textDescent());
			fill(0);
			textAlign(CENTER,BOTTOM);
			textSize(10);
			text(s, mouseX, mouseY-5);
		}
	}
		
	protected boolean move(int mx, int my){
		if (super.move(mx,my)){
			return true;
		} 
		else {
			Segment2D selection = cselect.select(mouseX, mouseY, 4);
			if (selection != null){
				highlight = selection.getSrcContour();
				member_index = contours.indexOf(highlight);
				return true;
			}
			else{
				highlight = null;
				member_index = -2;
				return false;
			}
		}
	}
	
	boolean keyPress(char key, int code) {
		boolean changed = false;
	  	if (key == CODED) {
	  	  	if (code == LEFT) {
	  	  		changed = changed || timer.decrement();
	  	  	} else if (code == RIGHT) {
	  	  		changed = changed || timer.increment();
	  	  	} 
	  	}
		
		if (changed){
			for (Container c : targets){
				Target tmp = (Target) c;
				if (tmp != null) tmp.updateRenderContext(true);
			}
			updateHighlight();
		}
		
		return changed;
	}		
	
	private void updateHighlight(){
		if (highlight != null){
			highlight = contours.get(member_index);
		}
	}
			
	
	void loadData(){
		
		// testing MNSD
		ColorMapf test = new ColorMapf();
		colorMode(HSB, 360, 100, 100, 100);
        test.add(  0, color(360, 20, 84, 0));
		test.add(1.49, color(360, 20, 84, 0));
		test.add( 1.5, color(360, 20, 84, 100));
		test.add(   2, color(337, 26, 80, 100));
		test.add(   3, color(315, 32, 76, 100));
		test.add(   5, color(292, 38, 71, 100));
		test.add(   7, color(270, 45, 65, 100));
		test.add(  10, color(247, 51, 59, 100));
		test.add(  15, color(225, 57, 52, 100));
		test.add(  20, color(202, 63, 43, 100));
		test.add(  25, color(180, 70, 29, 100));
		colorMode(RGB,255);

		Field f;
		ScalarEncoding encd, encd2;
		PVector corner = new PVector(cornerx, cornery);
		
		color c700mb, c500mb;
		c500mb = color(83,30,175);
		c700mb = color(0,116,162);
	
		// 700mb tmp
		ArrayList<Field> fields = new ArrayList<Field>();
		String dir = "./datasets/StatFields/700mb_TMP/";
		String run = "21";
		String grid = "212";
		String deriv = "mean";
		for (int k=0; k<=87; k+=3){
			String fhr = String.format("%02d", k);
			String file = dir + "sref.t" + run + "z.pgrb" + grid + ".f" + fhr + "."+ deriv + ".txt";
			f = new Field(file, samplesx, samplesy, corner, samplesy*spacing, samplesx*spacing);
			fields.add(f);
		}
	
		encd = new ScalarEncoding(fields);
		encd.useBilinear(true);
		encd.useInterpolation(false);
		encd.genIsovalues(273.15, 2);
		
		// LOAD STDDEV
		ArrayList<Field> fields2 = new ArrayList<Field>();
		deriv = "stddev";
		for (int k=0; k<=87; k+=3){
			String fhr = String.format("%02d", k);
			String file = dir + "sref.t" + run + "z.pgrb" + grid + ".f" + fhr + "."+ deriv + ".txt";
			f = new Field(file, samplesx, samplesy, corner, samplesy*spacing, samplesx*spacing);
			fields2.add(f);
		}
		
		encd2 = new ScalarEncoding(fields2);
		encd2.useBilinear(true);
		encd2.useInterpolation(false);
		encd2.setColorMap(test);
		encd2.addIsovalue(1);
		encd2.addIsovalue(1.5);
		encd2.addIsovalue(2);
		encd2.addIsovalue(3);
		encd2.addIsovalue(5);
		encd2.addIsovalue(7);
		encd2.addIsovalue(10);
		encd2.addIsovalue(15);
		encd2.addIsovalue(20);
		
		// Create Selectable 
		library.add(new MNSDSelect(tabw,tabh,c700mb, encd, encd2, "TMP", "700mb"));
		
		//500mb tmp 
		fields = new ArrayList<Field>();
		dir = "./datasets/StatFields/500mb_TMP/";
		deriv = "mean";
		for (int k=0; k<=87; k+=3){
			String fhr = String.format("%02d", k);
			String file = dir + "sref.t" + run + "z.pgrb" + grid + ".f" + fhr + "."+ deriv + ".txt";
			f = new Field(file, samplesx, samplesy, corner, samplesy*spacing, samplesx*spacing);
			fields.add(f);
		}
		
		encd = new ScalarEncoding(fields);
		encd.useBilinear(true);
		encd.useInterpolation(false);
		encd.genIsovalues(273.15, 2);		
		
		fields2 = new ArrayList<Field>();
		deriv = "stddev";
		for (int k=0; k<=87; k+=3){
			String fhr = String.format("%02d", k);
			String file = dir + "sref.t" + run + "z.pgrb" + grid + ".f" + fhr + "."+ deriv + ".txt";
			f = new Field(file, samplesx, samplesy, corner, samplesy*spacing, samplesx*spacing);
			fields2.add(f);
		}
		
		encd2 = new ScalarEncoding(fields2);
		encd2.useBilinear(true);
		encd2.useInterpolation(false);
		encd2.setColorMap(test);
		encd2.addIsovalue(1);
		encd2.addIsovalue(1.5);
		encd2.addIsovalue(2);
		encd2.addIsovalue(3);
		encd2.addIsovalue(5);
		encd2.addIsovalue(7);
		encd2.addIsovalue(10);
		encd2.addIsovalue(15);
		encd2.addIsovalue(20);
		
		library.add(new MNSDSelect(tabw,tabh,c500mb, encd, encd2, "TMP", "500mb"));
		
	}

}