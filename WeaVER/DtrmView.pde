class DtrmView extends View {
	BarbGlyphList glyphs;
	
	ScalarTarget t_cmap, t_contour;
	WindTarget t_barbs;
		
	PImage fill;
	ArrayList<Contour2D> contours;
	int member_index;
	Legend legend;
	QuadTree_Node<Segment2D> cselect;
	Contour2D highlight;
	ArrayList<Barb> barbs;
	
	ArrayList<StickyLabel> labels;
	StickyLabel l_cur;
	
	QuadTree_Node<Segment2D> ctooltip;
	PVector tooltipPos;
	
	ColorMapf wind, rh, tmp_5c, haines, apcp;
	
	DtrmView(int sx, int sy, float ds, int cx, int cy, int tw, int th, int libsize){
		super(sx, sy, ds, cx, cy, tw, th, libsize);
		glyphs = null;
		
		//add collections to library
		library.addCollection(3,1);
		library.addCollection(3,2);
		library.addCollection(3,2);
		library.addCollection(3,2);
		library.addCollection(3,3);
		library.addCollection(3,1);
		/*library.addCollection(3,1);*/
		
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
		
		//Barbs
		barbs = new ArrayList<Barb>();
				
		// Initialize Targets
		t_barbs = new WindTarget(cornerx+10+(2*(tabw+4)),cornery-tabh-10,tabw,tabh);
		t_barbs.linkBarbs(barbs);
		t_barbs.linkTimeControl(timer);
		t_barbs.setLabel("BARBS");
		library.linkTarget(t_barbs);
		targets.add(t_barbs);
			
		t_contour = new ScalarTarget(cornerx+10+(1*(tabw+4)),cornery-tabh-10,tabw,tabh);
		t_contour.linkContours(contours);
		t_contour.linkQuadTree(cselect);
		t_contour.linkLabels(labels);
		t_contour.linkTimeControl(timer);
		t_contour.setLabel("CONTOUR");
		library.linkTarget(t_contour);
		targets.add(t_contour);
	
		t_cmap = new ScalarTarget(cornerx+10,cornery-tabh-10,tabw,tabh);
		t_cmap.linkImage(fill);
		t_cmap.linkLegend(legend);
		t_cmap.linkTimeControl(timer);
		t_cmap.setLabel("COLOR MAP");
		library.linkTarget(t_cmap);
		targets.add(t_cmap);
	}
	
	void linkGlyphs(BarbGlyphList g){
		glyphs = g;
	}
	
	BarbGlyphList getGlyphs(){
		return glyphs;
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
		if(t_barbs.isHovering() || t_contour.isHovering()) tint(255, 200);
		image(fill, cornerx, cornery);
		noTint();
	
		// draw outline
		if (map != null){
			strokeWeight(2);
			stroke(255,255,255,255);//stroke(85,46,27,255);
			noFill();
			shape(map, cornerx+(38*spacing), cornery+(34*spacing), 120*spacing, 74*spacing);
		}
		
		/*//draw grid
		fill(150);
		noStroke();
	    for (int j=0; j < samplesy; j++){ //simulate 2D array
	      for (int i=0; i < samplesx; i++) {
	        PVector val00Pos = new PVector (round(cornerx+(i+0.5)*spacing), round(cornery+samplesy*spacing-((j+0.5)*spacing)));
	        ellipse(val00Pos.x, val00Pos.y, 3, 3);
	      }
	    }*/
		
		color clr;
		float weight;
		// contours
		//draw contours
		colorMode(HSB, 360, 100, 100, 100);
		strokeCap(SQUARE);
		if (t_contour.isHovering()){
			clr = color(0,0,15,100);
			weight = 2.3;
		}
		else {
			if(t_barbs.isHovering() || t_cmap.isHovering()){
				clr = color(0,0,15,50);
				weight = 1.0;
			}
			else{
				clr = color(0,0,15,100);
				weight = 2.0;
			}
		}
		stroke(clr);
		drawContours(contours, color(0,0,0), weight);
		strokeCap(ROUND);
		colorMode(RGB,255);	
	
		// barbs
		clr = color(60);
		strokeWeight(1.3);
		if(t_barbs.isHovering()){
			clr = color(40);	
			strokeWeight(2.3);
			}
		else if (t_contour.isHovering() || t_cmap.isHovering()) clr = color(60, 60);
		fill(clr);
		stroke(clr);
		for(Barb barb : barbs){
			barb.draw();
		}
		
		//labels
		for (StickyLabel l : labels){
			l.display();	
		}
	
		// draw controls
		library.display();
		
		if(t_barbs.isHovering() || t_contour.isHovering()) tint(255, 200);
		legend.display();
		noTint();
		
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
		Set<String> err_set = new HashSet<String>();
		String err;
		
		err = t_cmap.getErrorMessage();		
		if (!err.isEmpty()) err_set.add(err);
		
		err = t_contour.getErrorMessage();
		if (!err.isEmpty()) err_set.add(err);
		
		err = t_barbs.getErrorMessage();
		if (!err.isEmpty()) err_set.add(err);
		
		
		StringBuilder buff = new StringBuilder();
		String sep = "";
		for (String str : err_set) {
		    buff.append(sep);
		    buff.append(str);
		    sep = ", ";
		}
		
		String tmp = buff.toString();
		if (tmp.isEmpty()) errmsg = tmp;
		else errmsg = "Data for " + tmp + " unavailable";
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
	
	/*protected boolean press(int mx, int my){
		return press(mx,my,1);
	}*/
		
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
				
		// TMP : increments of 5 degrees C
		tmp_5c = new ColorMapf();
		colorMode(HSB, 360, 100, 100, 100);
		tmp_5c.add(213.15, color(270,  100,  29));
		tmp_5c.add(218.15, color(260,   85,  29));
		tmp_5c.add(223.15, color(250,   85,  43));
		tmp_5c.add(228.15, color(240,   75,  53));
		tmp_5c.add(233.15, color(230,   67,  59));
		tmp_5c.add(238.15, color(220,   59,  63));
		tmp_5c.add(243.15, color(210,   50,  67));
		tmp_5c.add(248.15, color(200,   42,  71));
		tmp_5c.add(253.15, color(190,   34,  75));
		tmp_5c.add(258.15, color(180,   26,  78));
		tmp_5c.add(263.15, color(170,   18,  81));
		tmp_5c.add(268.15, color(160,   10,  84));
		tmp_5c.add(273.15, color(145,    0,  84));
		tmp_5c.add(278.15, color(110,   10,  84));
		tmp_5c.add(283.15, color(100,   18,  81));
		tmp_5c.add(288.15, color( 90,   26,  78));
		tmp_5c.add(293.15, color( 80,   34,  75));
		tmp_5c.add(298.15, color( 70,   42,  71));
		tmp_5c.add(303.15, color( 60,   50,  67));
		tmp_5c.add(308.15, color( 50,   59,  63));
		tmp_5c.add(313.15, color( 40,   67,  59));
		tmp_5c.add(318.15, color( 30,   75,  53));
		tmp_5c.add(323.15, color( 20,   83,  47));
		tmp_5c.add(328.15, color( 10,   91,  40));
		tmp_5c.add(333.15, color(  0,  100,  29));
		colorMode(RGB,255);
		tmp_5c.convert_K2C();
		

		/*// TMP : increments of 3 degrees C
		ColorMapf tmp_3c = new ColorMapf();
		colorMode(HSB, 360, 100, 100, 100);
		tmp_3c.add(228.15, color(270, 100,  29));
		tmp_3c.add(231.15, color(262,  93,  38));
		tmp_3c.add(234.15, color(254,  87,  44));
		tmp_3c.add(237.15, color(246,  80,  50));
		tmp_3c.add(240.15, color(238,  74,  54));
		tmp_3c.add(243.15, color(230,  67,  58));
		tmp_3c.add(246.15, color(222,  61,  62));
		tmp_3c.add(249.15, color(215,  55,  65));
		tmp_3c.add(252.15, color(207,  48,  69));
		tmp_3c.add(255.15, color(199,  42,  71));
		tmp_3c.add(258.15, color(191,  35,  74));
		tmp_3c.add(261.15, color(183,  29,  77));
		tmp_3c.add(264.15, color(175,  22,  79));
		tmp_3c.add(267.15, color(167,  16,  82));
		tmp_3c.add(270.15, color(160,  10,  84));
		tmp_3c.add(273.15, color(160,   0,  84));
		tmp_3c.add(276.15, color(110,  10,  84));
		tmp_3c.add(279.15, color(102,  16,  82));
		tmp_3c.add(282.15, color( 94,  22,  79));
		tmp_3c.add(285.15, color( 86,  29,  77));
		tmp_3c.add(288.15, color( 78,  35,  74));
		tmp_3c.add(291.15, color( 70,  42,  71));
		tmp_3c.add(294.15, color( 62,  48,  69));
		tmp_3c.add(297.15, color( 55,  55,  65));
		tmp_3c.add(300.15, color( 47,  61,  62));
		tmp_3c.add(303.15, color( 39,  67,  58));
		tmp_3c.add(306.15, color( 31,  74,  54));
		tmp_3c.add(309.15, color( 23,  80,  50));
		tmp_3c.add(312.15, color( 15,  87,  44));
		tmp_3c.add(315.15, color(  7,  93,  38));
		tmp_3c.add(318.15, color(  0, 100,  29));
		colorMode(RGB,255);*/
		
		// RH : increments of 3 degrees C
		rh = new ColorMapf();
		colorMode(HSB, 360, 100, 100, 100);
		rh.add(   0, color(77,  49, 85,   0));
		rh.add(69.9999, color(77,  49, 70,   0));	
		rh.add(  70, color(77,  49, 85, 100));
		rh.add(  80, color(95,  45, 75, 100));
		rh.add(  90, color(129, 37, 55, 100));
		rh.add( 100, color(163, 29, 35, 100));
		colorMode(RGB,255);
		
		// WIND	
		wind = new ColorMapf();
		colorMode(HSB, 360, 100, 100, 100);
		wind.add(  0, color(180,  25,  29, 0));//color(110, 35, 29,0));
		wind.add(29.99999, color(180,  25,  29, 0));//color(110, 35, 29,0));
		wind.add( 30, color(180,  25,  29));//color(110, 35, 29));
		wind.add( 40, color(165,  29,  39));//color(100, 38, 39));
		wind.add( 50, color(150,  33,  46));//color( 91, 41, 46));
		wind.add( 60, color(135,  37,  52));//color( 82, 45, 52));
		wind.add( 70, color(120,  41,  57));//color( 73, 48, 57));
		wind.add( 80, color(105,  45,  61));//color( 64, 51, 61));
		wind.add( 90, color( 90,  50,  65));//color( 55, 55, 65));
		wind.add(100, color( 75,  50,  74));//color( 45, 58, 69));
		wind.add(110, color( 60,  50,  78));//color( 36, 61, 72));
		wind.add(120, color( 45,  62,  81));//color( 27, 65, 76));
		wind.add(130, color( 30,  66,  84));//color( 18, 68, 78));
		wind.add(140, color( 15,  70,  87));//color(  9, 71, 81));
		wind.add(150, color(  0,  75,  90));//color(  0, 75, 84));
		colorMode(RGB,255);		
		
		// ACPC
		apcp = new ColorMapf();
		colorMode(HSB, 360, 100, 100, 100);
		apcp.add(    4*25.4,  color(230,  65,  29, 100));
		apcp.add(    3*25.4,  color(223,  60,  41, 100));
		apcp.add(    2*25.4,  color(216,  55,  49, 100));
		apcp.add(    1*25.4,  color(209,  50,  55, 100));
		apcp.add( 0.75*25.4,  color(202,  45,  61, 100));
		apcp.add(  0.5*25.4,  color(195,  40,  65, 100));
		apcp.add( 0.25*25.4,  color(188,  35,  70, 100));
		apcp.add(  0.1*25.4,  color(181,  30,  74, 100));
		apcp.add( 0.05*25.4,  color(174,  20,  83, 100));//25, 77
		apcp.add( 0.01*25.4,  color(167,  10,  89, 100));//20, 81
		apcp.add(	 0.2539,  color(160,  15,  95,   0));
		apcp.add(         0,  color(160,  15,  95,   0));
		colorMode(RGB,255);
		apcp.convert_kgmm2in();
				
		haines = new ColorMapf();
		haines.add(1.5, color( 126, 200, 178 ));  //2
		haines.add(2.5, color( 126, 200, 178 ));  //2
		haines.add(3.5, color(  59, 164, 133 ));  //3
		haines.add(4.5, color( 217, 165,  49 ));  //4
		haines.add(5.5, color( 191,  69,  69 ));  //6
		haines.add(6.5, color( 145,  31,  31 ));  //7
		haines.convert_fakeHaines();
		haines.setCategorical(true);
		
		
		String base_model;
		base_model = "arw";//for old SREF chnage to "em"
		
		String hgt;
		hgt = "200mb";
		addDtrmRH(  dataDir, run_input, hgt, base_model, "ctl", 0);
		addDtrmWIND(dataDir, run_input, hgt, base_model, "ctl", 0);
		addDtrmHGT( dataDir, run_input, hgt, base_model, "ctl", 0);
		
		
		hgt = "300mb";
		addDtrmRH(  dataDir, run_input, hgt, base_model, "ctl", 1);
		addDtrmWIND(dataDir, run_input, hgt, base_model, "ctl", 1);
		addDtrmHGT( dataDir, run_input, hgt, base_model, "ctl", 1);
		
		
		hgt = "500mb";
		addDtrmRH(  dataDir, run_input, hgt, base_model, "ctl", 2);
		addDtrmWIND(dataDir, run_input, hgt, base_model, "ctl", 2);
		addDtrmHGT( dataDir, run_input, hgt, base_model, "ctl", 2);
		addDtrmTMP( dataDir, run_input, hgt, base_model, "ctl", 2);
		
		
		hgt = "700mb";
		addDtrmRH(  dataDir, run_input, hgt, base_model, "ctl", 3);
		addDtrmWIND(dataDir, run_input, hgt, base_model, "ctl", 3);
		addDtrmHGT( dataDir, run_input, hgt, base_model, "ctl", 3);
		addDtrmTMP( dataDir, run_input, hgt, base_model, "ctl", 3);
		
		
		hgt = "850mb";
		addDtrmRH(  dataDir, run_input, hgt, base_model, "ctl", 4);
		addDtrmWIND(dataDir, run_input, hgt, base_model, "ctl", 4);
		addDtrmHGT( dataDir, run_input, hgt, base_model, "ctl", 4);
		addDtrmTMP( dataDir, run_input, hgt, base_model, "ctl", 4);
		
		/*surface*/
		addDtrmTMP( dataDir, run_input, "2m", base_model, "ctl", 5);
		addDtrmRH( dataDir, run_input, "2m", base_model, "ctl", 5);
		addDtrmAPCP(dataDir, run_input, 3, base_model, "ctl", 5);
		addDtrmAPCP(dataDir, run_input, 6, base_model, "ctl", 5);
		addDtrmAPCP(dataDir, run_input, 12, base_model, "ctl", 5);
		addDtrmAPCP(dataDir, run_input, 24, base_model, "ctl", 5);
			
		
		addDtrmHaines(dataDir, run_input, "High", base_model, "ctl", 6);
		addDtrmHaines(dataDir, run_input,  "Med", base_model, "ctl", 6);
		addDtrmHaines(dataDir, run_input,  "Low", base_model, "ctl", 6);
		
	}
	
	private void addDtrmAPCP(String dataDir, int run_input, int interval, String model, String p, int libIndex){
		String var = "APCP";
		String hgt = "surface";
		String deriv = interval+"hr";
		String dir = dataDir + "/EnsembleFields/"+hgt+"_"+var+"/"+deriv+"/";
		PVector corner = new PVector(cornerx, cornery);
		String run = String.format("%02d", run_input);
		String grid = "212";
		
		loadDetails = "deterministic "+ hgt + " " + var;
		
		Field f;		
		ArrayList<Field> fields = new ArrayList<Field>();
		for (int k=0; k<=87; k+=3){
			if (k >= interval){
				String fhr = String.format("%02d", k);
				String file = dir + "sref_"+ model +".t" + run + "z.pgrb" + grid + "." + p + ".f" + fhr + ".txt";
				f = new Field(file, samplesx, samplesy, corner, samplesy*spacing, samplesx*spacing);
			}
			else f = new Field();
			fields.add(f);
		}
		
		ScalarEncoding encd = new ScalarEncoding(fields);
		encd.useBilinear(true);
		encd.useInterpolation(false);
		encd.setColorMap(apcp);
		encd.convert_kgmm2in();
		encd.addIsovalue(4*25.4);
		encd.addIsovalue(3*25.4);
		encd.addIsovalue(2*25.4);
		encd.addIsovalue(1*25.4);
		encd.addIsovalue(0.75*25.4);
		encd.addIsovalue( 0.5*25.4);
		encd.addIsovalue(0.25*25.4);
		encd.addIsovalue( 0.1*25.4);
		encd.addIsovalue(0.05*25.4);
		encd.addIsovalue(0.01*25.4);
		library.add(new StatSelect(tabw, tabh, encd, var, deriv, ""), libIndex);	
	}
		
	private void addDtrmTMP(String dataDir, int run_input, String hgt, String model, String p, int libIndex){
		String var = "TMP";
		String deriv = "";
		String dir = dataDir + "/EnsembleFields/"+hgt+"_"+var+"/";
		PVector corner = new PVector(cornerx, cornery);
		String run = String.format("%02d", run_input);
		String grid = "212";
		
		loadDetails = "deterministic "+ hgt + " " + var;
		
		Field f;		
		ArrayList<Field> fields = new ArrayList<Field>();
		for (int k=0; k<=87; k+=3){
			String fhr = String.format("%02d", k);
			String file = dir + "sref_"+ model +".t" + run + "z.pgrb" + grid + "." + p + ".f" + fhr + ".txt";
			f = new Field(file, samplesx, samplesy, corner, samplesy*spacing, samplesx*spacing);
			fields.add(f);
		}

		ScalarEncoding encd = new ScalarEncoding(fields);
		encd.useBilinear(true);
		encd.useInterpolation(false);
		encd.setColorMap(tmp_5c);
		encd.genIsovalues(273.15, 5);
		encd.convert_K2C();
		library.add(new StatSelect(tabw, tabh, encd, var, hgt, deriv), libIndex);		
	}
	
	private void addDtrmRH(String dataDir, int run_input, String hgt, String model, String p, int libIndex){
		String var = "RH";
		String deriv = "";
		String dir = dataDir + "/EnsembleFields/"+hgt+"_"+var+"/";
		PVector corner = new PVector(cornerx, cornery);
		String run = String.format("%02d", run_input);
		String grid = "212";
		
		loadDetails = "deterministic "+ hgt + " " + var;
		
		Field f;		
		ArrayList<Field> fields = new ArrayList<Field>();
		for (int k=0; k<=87; k+=3){
			String fhr = String.format("%02d", k);
			String file = dir + "sref_"+ model +".t" + run + "z.pgrb" + grid + "." + p + ".f" + fhr + ".txt";
			f = new Field(file, samplesx, samplesy, corner, samplesy*spacing, samplesx*spacing);
			fields.add(f);
		}

		ScalarEncoding encd = new ScalarEncoding(fields);
		encd.useBilinear(true);
		encd.useInterpolation(false);
		encd.setColorMap(rh);
		encd.genIsovalues(0, 10);
		library.add(new StatSelect(tabw, tabh, encd, var, hgt, deriv), libIndex);		
	}
	
	private void addDtrmHGT(String dataDir, int run_input, String hgt, String model, String p, int libIndex){
		String var = "HGT";
		String deriv = "";
		String dir = dataDir + "/EnsembleFields/"+hgt+"_"+var+"/";
		PVector corner = new PVector(cornerx, cornery);
		String run = String.format("%02d", run_input);
		String grid = "212";
		
		loadDetails = "deterministic "+ hgt + " " + var;
		
		Field f;		
		ArrayList<Field> fields = new ArrayList<Field>();
		for (int k=0; k<=87; k+=3){
			String fhr = String.format("%02d", k);
			String file = dir + "sref_"+ model +".t" + run + "z.pgrb" + grid + "." + p + ".f" + fhr + ".txt";
			f = new Field(file, samplesx, samplesy, corner, samplesy*spacing, samplesx*spacing);
			fields.add(f);
		}

		ContourEncoding encd = new ContourEncoding(fields);
		encd.useBilinear(true);
		encd.useInterpolation(false);
		encd.genIsovalues(0, 60);
		library.add(new ContourSelect(tabw, tabh, encd, var, hgt, deriv), libIndex);
	}
	
	private void addDtrmWIND(String dataDir, int run_input, String hgt, String model, String p, int libIndex){
		String var = "Wind";
		String deriv = "";
		String dir = dataDir + "/EnsembleFields/"+hgt+"_"+var+"/";
		PVector corner = new PVector(cornerx, cornery);
		String run = String.format("%02d", run_input);
		String grid = "212";
		
		loadDetails = "deterministic "+ hgt + " " + var;
		
		WindField wf;
		ArrayList<WindField> wfields = new ArrayList<WindField>();
		for (int k=0; k<=87; k+=3){
			String fhr = String.format("%02d", k);
			String file  = dir + "sref_"+ model +".t" + run + "z.pgrb" + grid + "." + p + ".f" + fhr + ".WSPD.txt";
			String file2 = dir + "sref_"+ model +".t" + run + "z.pgrb" + grid + "." + p + ".f" + fhr + ".WDIR.txt";
			wf = new WindField(file, file2, samplesx, samplesy, corner, samplesy*spacing, samplesx*spacing);
			wfields.add(wf);
		}
		
		WindEncoding w_encd = new WindEncoding(wfields, glyphs);
		w_encd.useBilinear(true);
		w_encd.useInterpolation(false);
		w_encd.setColorMap(wind);
		w_encd.genIsovalues(0, 10);
		library.add(new WindSelect(tabw,tabh, w_encd, hgt, deriv), libIndex);
		
	}
	
	private void addDtrmHaines(String dataDir, int run_input, String level, String model, String p, int libIndex){
		String var = "Haines";
		String deriv = "";
		String dir = dataDir + "/EnsembleFields/Haines/"+level+"/";
		PVector corner = new PVector(cornerx, cornery);
		String run = String.format("%02d", run_input);
		String grid = "212";
		
		loadDetails = "deterministic "+ var + " (" + level +")";
		
		Field f;		
		ArrayList<Field> fields = new ArrayList<Field>();
		for (int k=0; k<=87; k+=3){
			String fhr = String.format("%02d", k);
			String file = dir + "sref_"+ model +".t" + run + "z.pgrb" + grid + "." + p + ".f" + fhr + ".txt";
			f = new Field(file, samplesx, samplesy, corner, samplesy*spacing, samplesx*spacing);
			fields.add(f);
		}

		ScalarEncoding encd = new ScalarEncoding(fields);
		encd.useBilinear(true);
		encd.useInterpolation(false);
		encd.setColorMap(haines);
		/*encd.genIsovalues(0.5, 1);*/
		encd.convert_fakeHaines();
		encd.addIsovalue(1.5);
		encd.addIsovalue(2.5);
		encd.addIsovalue(3.5);
		encd.addIsovalue(4.5);
		encd.addIsovalue(5.5);
		library.add(new StatSelect(tabw, tabh, encd, var, level, deriv), libIndex);
	}	

}