class ProbabilityView extends View {
	ConditionTarget target0;
	
	PImage fill;
	ArrayList<Contour2D> contours;
	int member_index;
	Legend legend;
	QuadTree_Node<Segment2D> cselect;
	Contour2D highlight;
	
	ProbabilityView(int sx, int sy, float ds, int cx, int cy, int tw, int th, int libsize){
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
		
		
		ColorMapf test = new ColorMapf();
		colorMode(HSB, 360, 100, 100, 100);
        test.add(  0, color(360, 20, 84, 0));
		test.add(49.99, color(360, 20, 84, 0));
		test.add( 50, color(360, 20, 84, 100));
		test.add( 70, color(315, 32, 76, 100));
		test.add( 90, color(270, 45, 65, 100));
		test.add(100, color(247, 51, 59, 100));
		colorMode(RGB,255);
				
		// Initialize Targets		
		target0 = new ConditionTarget(cornerx+10,cornery-tabh-10,tabw,tabh,4,1);
		target0.linkImage(fill);
		target0.linkLegend(legend);
		target0.linkContours(contours);
		target0.linkQuadTree(cselect);
		target0.linkTimeControl(timer);
		target0.setLabel("CONDITIONS");
		target0.useBilinear(true);
		target0.useInterpolation(false);
		target0.genIsovalues(10.0, 20.0, 0.0, 100.0);
		target0.setColorMap(test);
		library.linkTarget(target0);
		targets.add(target0);
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
		if (!target0.isHovering()){
			colorMode(HSB, 360, 100, 100, 100);
			stroke(0,0,15,100);
			strokeCap(SQUARE);
			drawContours(contours, color(0,0,0), 1.5);
			strokeCap(ROUND);
			colorMode(RGB,255);	
		}
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
			
	
	void loadData(String dataDir, int run_input){
		
		ConditionEnsemble f;
		PVector corner = new PVector(cornerx, cornery);
		
		color c2m;
		c2m = color(31,78,160);		
	
		// 2m_RH
		ArrayList<ConditionEnsemble> fields = new ArrayList<ConditionEnsemble>();
		String dir = dataDir + "/Probabilities/2m_RH/";
		String run = String.format("%02d", run_input);
		String grid = "212";
		String deriv = "le.15";
		for (int k=0; k<=87; k+=3){
			String fhr = String.format("%02d", k);
			String file = dir + "sref.t" + run + "z.pgrb" + grid + ".f" + fhr + "."+ deriv + ".txt";
			f = new ConditionEnsemble(file, samplesx, samplesy, 21, corner, samplesy*spacing, samplesx*spacing);
			fields.add(f);
		}
		
		library.add(new ConditionSelect(tabw,tabh,c2m, fields, "RH", "2m", "≤ 15"));
		
		// 10m_WSPD
		fields = new ArrayList<ConditionEnsemble>();
		dir = dataDir + "/Probabilities/10m_WSPD/";
		deriv = "ge.20";
		for (int k=0; k<=87; k+=3){
			String fhr = String.format("%02d", k);
			String file = dir + "sref.t" + run + "z.pgrb" + grid + ".f" + fhr + "."+ deriv + ".txt";
			f = new ConditionEnsemble(file, samplesx, samplesy, 21, corner, samplesy*spacing, samplesx*spacing);
			fields.add(f);
		}
		
		library.add(new ConditionSelect(tabw,tabh,c2m, fields, "WSPD", "10m", "≥ 20"));
				
	}

}