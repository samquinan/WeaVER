class MNSDView extends View {
							   //TODO add 2nd target (texture)
	ScalarTarget mnsd_target0; //TODO deal with same selectable in multiple targets?
	
	PImage fill;
	ArrayList<Contour2D> contours;
	int member_index;
	Legend legend;
	QuadTree_Node<Segment2D> cselect;
	Contour2D highlight;
	
	ArrayList<StickyLabel> labels;
	StickyLabel l_cur;
	
	QuadTree_Node<Segment2D> ctooltip;
	PVector tooltipPos;
	ColorMapf mnsd, mnsd2;
	
	MNSDView(int sx, int sy, float ds, int cx, int cy, int tw, int th, int libsize){
		super(sx, sy, ds, cx, cy, tw, th, libsize);
		
		library.addCollection(3,1);
		library.addCollection(3,1);
		
		// Initialize Render State
		//Color Map
		fill = createImage(int(samplesx*spacing), int(samplesy*spacing), ARGB);
		legend = new Legend(cornerx-22,cornery+1,12,int(samplesy*spacing)-2);
		
		//Contours
		contours = new ArrayList<Contour2D>();
		cselect = new QuadTree_Node<Segment2D>(cornerx, cornery, cornerx+samplesx*spacing, cornery+samplesy*spacing, 21);
		highlight = null;
		member_index = -2;
		tooltipPos = null;
		ctooltip = new QuadTree_Node<Segment2D>(cornerx, cornery, cornerx+samplesx*spacing, cornery+samplesy*spacing, 7);
		labels = new ArrayList<StickyLabel>();
		l_cur = null;
		
				
		// Initialize Targets
			
		mnsd_target0 = new ScalarTarget(cornerx+10,cornery-tabh-10,tabw,tabh);
		mnsd_target0.linkImage(fill);
		mnsd_target0.linkLegend(legend);
		mnsd_target0.linkContours(contours);
		mnsd_target0.linkQuadTree(cselect);
		mnsd_target0.linkLabels(labels);
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
			shape(map, cornerx+(38*spacing), cornery+(34*spacing), 120*spacing, 74*spacing);
		}
	
		// fill
		image(fill, cornerx, cornery);
	
		// draw outline
		if (map != null){
			strokeWeight(2);
			stroke(255,255,255,255);//stroke(85,46,27,255);
			noFill();
			shape(map, cornerx+(38*spacing), cornery+(34*spacing), 120*spacing, 74*spacing);
		}	
	
		// contours
		//draw contours
		colorMode(HSB, 360, 100, 100, 100);
		stroke(0,0,15,100);
		strokeCap(SQUARE);
		drawContours(contours, color(0,0,0), (mnsd_target0.isHovering() ? 1.0 : 2.0));
		strokeCap(ROUND);
		colorMode(RGB,255);	
		
		//labels
		for (StickyLabel l : labels){
			l.display();	
		}
		
		// draw controls
		library.display();
		legend.display();
		tracker.display();
		timer.display();
		
		//Error Message		
	 	buildErrString();
		if (!errmsg.isEmpty()){
			boolean fontsAvailable = (fReg != null) && (fErr != null);
			if (fontsAvailable){
				textFont(fErr);
				textSize(14);
			}
			else textSize(12);
			textAlign(CENTER, TOP);
			fill(120, 12, 12);
			text(errmsg, cornerx+(samplesx*spacing/2), cornery+(samplesy*spacing)+20);
			if (fontsAvailable){
				textFont(fReg);
			}
		}
		
		//Default Label
		textSize(11);
		textAlign(CENTER, TOP);
		fill(70);
		String full_label = (origin == null) ? "" : origin.getDateString(timer.getValue()); 
		text(full_label, cornerx+(samplesx*spacing/2), cornery+(samplesy*spacing)+5);
		
		/*//frame rate for testing
		textSize(10);
		textAlign(RIGHT, BOTTOM);
		fill(70);
		text(frameRate, width-3, height-3);
		textSize(10);*/
		
		//selection tooltip
		drawToolTip();
	}
	
	protected void buildErrString(){
		String err;
		
		err = mnsd_target0.getErrorMessage();		
		
		String tmp = err;
		if (tmp.isEmpty()) errmsg = tmp;
		else errmsg = "Data for " + tmp + " unavailable";
	}
	
	
	protected void drawContours(ArrayList<Contour2D> contours, color select, float weight)
	{
		noFill();
		strokeWeight(weight);
	
		int n = int(contours.size());
	
		//draw all but selection
		Contour2D c;
		for (int i=0; i<n; i++){
			c = contours.get(i);
			if (c == highlight){
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
		if ((highlight != null) && (l_cur == null)){// && trigger){		
			String s = highlight.getID();
			fill(255,179);
			noStroke();
			float x, y;
			x = (tooltipPos != null) ? tooltipPos.x : mouseX;
			y = (tooltipPos != null) ? tooltipPos.y+2 : mouseY-5;
			rect(x - textWidth(s)/2 -2, y-textAscent()-textDescent(), textWidth(s)+4, textAscent()+textDescent());
			fill(0);
			textAlign(CENTER,BOTTOM);
			textSize(10);
			text(s, x, y);
		}
	}
		
	protected boolean move(int mx, int my){
		if (super.move(mx,my)){
			return true;
		} 
		else {
			if (!timer.isAnimating()){
				for (StickyLabel l : labels){
					if (l.interact(mx,my)){
						l_cur = l;
						highlight = l.getContour();
						member_index = l.getMemberIndex();
						return true;
					}
				}
			}
			// if no label selected
			l_cur = null;
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
	
	protected boolean drag(int mx, int my){
		if (super.drag(mx,my)) return true;
		else if (l_cur != null){
			l_cur.reposition(mx,my);
			return true;
		}
		else if (highlight != null){
			tooltipPos = ctooltip.getClosestPoint(mx,my);
			if (tooltipPos == null) highlight = null;
			return true;
		}		
		return false;	
	}	
	
	protected boolean press(int mx, int my, int clickCount){
		if (super.press(mx,my,clickCount)) return true;
		else if (l_cur != null){
			if (clickCount > 1){
				labels.remove(l_cur);
				highlight = null;
				member_index = -2;				
				return true;
			}		
		}
		else if (highlight != null){
			ctooltip.clear();
			highlight.addAllSegmentsToQuadTree(ctooltip);
			tooltipPos = ctooltip.getClosestPoint(mx,my);
			return true;
		}
		return false;	
	}
	
	protected boolean release(){
		if (super.release()) return true;
		else if (tooltipPos != null){
			//add sticky label
			l_cur = new StickyLabel(tooltipPos, ctooltip, highlight, member_index);
			labels.add(l_cur);
			//end tool-tip
			ctooltip =  new QuadTree_Node<Segment2D>(cornerx, cornery, cornerx+samplesx*spacing, cornery+samplesy*spacing, 7); //new base obj
			tooltipPos = null;
			return true;
		}
		return false;	
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
		else if (tracker.keyPress(key, code)){
			if (tracker.changed()){
				highlight = null;
				member_index = -2;
				ctooltip.clear();
				tooltipPos = null;
								
				tracker.update(targets);
				changed = true;
			}
		}
		return changed;
	}		
	
	private void updateHighlight(){
		for (StickyLabel l : labels){
			int i = l.getMemberIndex();
			Contour2D c = contours.get(i);
			if (c != null){
				l.update(c);
			}
		}
		if (highlight != null){
			highlight = contours.get(member_index);
			if ((tooltipPos != null)&&(highlight != null)){
				ctooltip.clear();
				highlight.addAllSegmentsToQuadTree(ctooltip);
				tooltipPos = ctooltip.getClosestPoint(tooltipPos.x,tooltipPos.y);
			}
		}
	}			
	
	void loadData(String dataDir, int run_input){
		
		// testing MNSD
		mnsd = new ColorMapf();
		colorMode(HSB, 360, 100, 100, 100);
        mnsd.add(  0,  color(360, 20, 87, 0));
		mnsd.add(1.49, color(360, 20, 87, 0));
		mnsd.add( 1.5, color(360, 20, 87, 100));
		mnsd.add(   2, color(337, 26, 83, 100));
		mnsd.add(   3, color(315, 32, 76, 100));
		mnsd.add(   5, color(292, 38, 71, 100));
		mnsd.add(   7, color(270, 45, 65, 100));
		mnsd.add(  10, color(247, 51, 62, 100));
		mnsd.add(  15, color(225, 57, 52, 100));
		mnsd.add(  20, color(202, 63, 37, 100));
		mnsd.add(  25, color(180, 70, 25, 100));
		colorMode(RGB,255);
		
		mnsd2 = new ColorMapf();
		colorMode(HSB, 360, 100, 100, 100);
        mnsd2.add(  0,  color(360, 20, 87, 0));
		mnsd2.add(9.99, color(360, 20, 87, 0));
		mnsd2.add(  10, color(360, 20, 87, 100));
		mnsd2.add(  30, color(337, 26, 83, 100));
		mnsd2.add(  40, color(315, 32, 76, 100));
		mnsd2.add(  50, color(292, 38, 71, 100));
		mnsd2.add(  60, color(270, 45, 65, 100));
		mnsd2.add(  70, color(247, 51, 62, 100));
		mnsd2.add(  80, color(225, 57, 52, 100));
		mnsd2.add(  90, color(202, 63, 37, 100));
		mnsd2.add( 100, color(180, 70, 25, 100));
		colorMode(RGB,255);

		// println("loading 500mb");
		addMNSD_TMP(dataDir, run_input, "500mb", 0);
		addMNSD_HGT(dataDir, run_input, "500mb", 0);
		
		// println("loading 700mb");
		addMNSD_TMP(dataDir, run_input, "700mb", 1);
		addMNSD_HGT(dataDir, run_input, "700mb", 1);
		
		// println("loading 2m");
		addMNSD_TMP(dataDir, run_input, "2m", 2);
		addMNSD_RH( dataDir, run_input, "2m", 2);
		
	}
	
	private void addMNSD_RH(String dataDir, int run_input, String hgt, int libIndex){
		String var = "RH";
		String dir = dataDir + "/StatFields/"+hgt+"_"+var+"/";;
		PVector corner = new PVector(cornerx, cornery);
		String run = String.format("%02d", run_input);
		String grid = "212";
		
		loadDetails = "mnsd "+ hgt + " " + var;
		
		Field f;
		ArrayList<Field> fields = new ArrayList<Field>();
		String deriv = "mean";
		for (int k=0; k<=87; k+=3){
			String fhr = String.format("%02d", k);
			String file = dir + "sref.t" + run + "z.pgrb" + grid + ".f" + fhr + "."+ deriv + ".txt";
			f = new Field(file, samplesx, samplesy, corner, samplesy*spacing, samplesx*spacing);
			fields.add(f);
		}
		
		ScalarEncoding encd = new ScalarEncoding(fields);
		encd.useBilinear(true);
		encd.useInterpolation(false);
		encd.genIsovalues(0, 10);
		
		ArrayList<Field> fields2 = new ArrayList<Field>();
		deriv = "stddev";
		for (int k=0; k<=87; k+=3){
			String fhr = String.format("%02d", k);
			String file = dir + "sref.t" + run + "z.pgrb" + grid + ".f" + fhr + "."+ deriv + ".txt";
			f = new Field(file, samplesx, samplesy, corner, samplesy*spacing, samplesx*spacing);
			fields2.add(f);
		}
		
		ScalarEncoding encd2 = new ScalarEncoding(fields2);
		encd2.useBilinear(true);
		encd2.useInterpolation(false);
		encd2.setColorMap(mnsd);
		encd2.addIsovalue(1);
		encd2.addIsovalue(1.5);
		encd2.addIsovalue(2);
		encd2.addIsovalue(3);
		encd2.addIsovalue(5);
		encd2.addIsovalue(7);
		encd2.addIsovalue(10);
		encd2.addIsovalue(15);
		encd2.addIsovalue(20);
		
		library.add(new MNSDSelect(tabw,tabh, encd, encd2, var, hgt), libIndex);
	}
	
	private void addMNSD_HGT(String dataDir, int run_input, String hgt, int libIndex){
		String var = "HGT";
		String dir = dataDir + "/StatFields/"+hgt+"_"+var+"/";;
		PVector corner = new PVector(cornerx, cornery);
		String run = String.format("%02d", run_input);
		String grid = "212";
		
		loadDetails = "mnsd "+ hgt + " " + var;
		
		Field f;
		ArrayList<Field> fields = new ArrayList<Field>();
		String deriv = "mean";
		for (int k=0; k<=87; k+=3){
			String fhr = String.format("%02d", k);
			String file = dir + "sref.t" + run + "z.pgrb" + grid + ".f" + fhr + "."+ deriv + ".txt";
			f = new Field(file, samplesx, samplesy, corner, samplesy*spacing, samplesx*spacing);
			fields.add(f);
		}
		
		ScalarEncoding encd = new ScalarEncoding(fields);
		encd.useBilinear(true);
		encd.useInterpolation(false);
		encd.genIsovalues(0, 60);
		
		ArrayList<Field> fields2 = new ArrayList<Field>();
		deriv = "stddev";
		for (int k=0; k<=87; k+=3){
			String fhr = String.format("%02d", k);
			String file = dir + "sref.t" + run + "z.pgrb" + grid + ".f" + fhr + "."+ deriv + ".txt";
			f = new Field(file, samplesx, samplesy, corner, samplesy*spacing, samplesx*spacing);
			fields2.add(f);
		}
		
		ScalarEncoding encd2 = new ScalarEncoding(fields2);
		encd2.useBilinear(true);
		encd2.useInterpolation(false);
		encd2.setColorMap(mnsd2);
		encd2.addIsovalue( 10);
		encd2.addIsovalue( 30);
		encd2.addIsovalue( 40);
		encd2.addIsovalue( 50);
		encd2.addIsovalue( 60);
		encd2.addIsovalue( 70);
		encd2.addIsovalue( 80);
		encd2.addIsovalue( 90);
		encd2.addIsovalue(100);
		
		library.add(new MNSDSelect(tabw,tabh, encd, encd2, var, hgt), libIndex);
	}
	
	
	
	private void addMNSD_TMP(String dataDir, int run_input, String hgt, int libIndex){
		String var = "TMP";
		String dir = dataDir + "/StatFields/"+hgt+"_"+var+"/";;
		PVector corner = new PVector(cornerx, cornery);
		String run = String.format("%02d", run_input);
		String grid = "212";
		
		loadDetails = "mnsd "+ hgt + " " + var;
		
		Field f;
		ArrayList<Field> fields = new ArrayList<Field>();
		String deriv = "mean";
		for (int k=0; k<=87; k+=3){
			String fhr = String.format("%02d", k);
			String file = dir + "sref.t" + run + "z.pgrb" + grid + ".f" + fhr + "."+ deriv + ".txt";
			f = new Field(file, samplesx, samplesy, corner, samplesy*spacing, samplesx*spacing);
			fields.add(f);
		}
		
		ScalarEncoding encd = new ScalarEncoding(fields);
		encd.useBilinear(true);
		encd.useInterpolation(false);
		encd.convert_K2C();
		encd.genIsovalues(273.15, 5);
		
		ArrayList<Field> fields2 = new ArrayList<Field>();
		deriv = "stddev";
		for (int k=0; k<=87; k+=3){
			String fhr = String.format("%02d", k);
			String file = dir + "sref.t" + run + "z.pgrb" + grid + ".f" + fhr + "."+ deriv + ".txt";
			f = new Field(file, samplesx, samplesy, corner, samplesy*spacing, samplesx*spacing);
			fields2.add(f);
		}
		
		ScalarEncoding encd2 = new ScalarEncoding(fields2);
		encd2.useBilinear(true);
		encd2.useInterpolation(false);
		encd2.setColorMap(mnsd);
		encd2.addIsovalue(1);
		encd2.addIsovalue(1.5);
		encd2.addIsovalue(2);
		encd2.addIsovalue(3);
		encd2.addIsovalue(5);
		encd2.addIsovalue(7);
		encd2.addIsovalue(10);
		encd2.addIsovalue(15);
		encd2.addIsovalue(20);
		
		library.add(new MNSDSelect(tabw,tabh, encd, encd2, var, hgt), libIndex);
	}

}