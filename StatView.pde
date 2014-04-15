class StatView extends View {
	BarbGlyphList glyphs;
	
	ScalarTarget t_cmap, t_contour;
	WindTarget t_barbs;
	
	PImage fill;
	ArrayList<Contour2D> contours;
	Legend legend;
	QuadTree_Node<Segment2D> cselect;
	Contour2D highlight;
	ArrayList<Barb> barbs;
	
	StatView(int sx, int sy, int ds, int cx, int cy, int tw, int th, int libsize){
		super(sx, sy, ds, cx, cy, tw, th, ceil(libsize/2.0));
		glyphs = null;
		
		// Initialize Render State
			//Color Map
		fill = createImage(int(samplesx*spacing), int(samplesy*spacing), ARGB);
		legend = new Legend(cornerx-22,cornery+1,12,(samplesy*spacing)-2);
		
			//Contours
		contours = new ArrayList<Contour2D>();
		cselect = new QuadTree_Node<Segment2D>(cornerx, cornery, cornerx+samplesx*spacing, cornery+samplesy*spacing, 21);
		highlight = null;
		
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
		drawContours(contours, color(0,0,0), 2.0);
		strokeCap(ROUND);
		colorMode(RGB,255);	
	
		// barbs
		strokeWeight(1.3);
		color clr = color(60);
		fill(clr);
		stroke(clr);
		for(Barb barb : barbs){
			barb.draw();
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
		boolean trigger = false;
	
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
			rect(mouseX - (s.length()/2)*6, mouseY-17, s.length()*6, 12);
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
				return true;
			}
			else{
				highlight = null;
				return false;
			}
		}
	}		
	
	void loadData(){
	
		// TMP : increments of 5 degrees C
		ColorMapf tmp_5c = new ColorMapf();
		colorMode(HSB, 360, 100, 100, 100);
		tmp_5c.add(228.15, color(270, 100,  29) );
		tmp_5c.add(233.15, color(256,  88,  43) );
		tmp_5c.add(238.15, color(242,  77,  52) ); 
		tmp_5c.add(243.15, color(228,  66,  59) ); 
		tmp_5c.add(248.15, color(215,  55,  65) ); 
		tmp_5c.add(253.15, color(201,  43,  71) ); 
		tmp_5c.add(258.15, color(187,  32,  76) ); 
		tmp_5c.add(263.15, color(173,  21,  80) ); 
		tmp_5c.add(268.15, color(160,  10,  84) );
		tmp_5c.add(273.15, color(145,   0,  84) );
		tmp_5c.add(278.15, color(110,  10,  84) );
		tmp_5c.add(283.15, color( 96,  21,  80) );
		tmp_5c.add(288.15, color( 82,  32,  76) );
		tmp_5c.add(293.15, color( 68,  43,  71) );
		tmp_5c.add(298.15, color( 55,  55,  65) );
		tmp_5c.add(303.15, color( 41,  66,  59) );
		tmp_5c.add(308.15, color( 27,  77,  52) );
		tmp_5c.add(313.15, color( 13,  88,  43) );
		tmp_5c.add(318.15, color(  0, 100,  29) );
		colorMode(RGB,255);

		// TMP : increments of 3 degrees C
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
		colorMode(RGB,255);

		// RH : increments of 3 degrees C
		ColorMapf rh = new ColorMapf();
	    rh.add(0, color(255, 255, 255, 0));
	    rh.add(69, color(255, 255, 255, 0));
	    rh.add(70, color(93, 180, 80, 255));
	    rh.add(80, color(93, 180, 80, 255));
	    rh.add(90, color(41, 98, 33, 255));
	    rh.add(100, color(9, 49, 3, 255));
	
		// testing wind isotachs
		ColorMapf test = new ColorMapf();
		colorMode(HSB, 360, 100, 100, 100);	
	    test.add( 0, color(  0,   0, 100,   0));
	    test.add(49.9, color(	 0,   0, 100, 0));
		test.add(50, color( 96,  21,  80, 100));
		test.add(60, color( 96,  21,  80, 100));
		test.add(70, color( 68,  43,  71, 100));
		test.add(80, color( 41,  66,  59, 100));
		test.add(90, color( 13,  88,  43, 100));
		colorMode(RGB,255);

		Field f;
		ScalarEncoding encd;
		StatSelect entry;
		PVector corner = new PVector(cornerx, cornery);
	
		// LOAD MEAN
		ArrayList<Field> fields = new ArrayList<Field>();
		String dir = "./datasets/700mb/";
		String run = "15";
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
		encd.setColorMap(tmp_3c);
		encd.genIsovalues(273.15, 2);
		entry = new StatSelect(tabw,tabh,color(0,116,162), encd, "TMP", "700mb", "mean");
		library.add(entry);
	
		// LOAD WIND
		WindField wf;
		WindEncoding w_encd;
		ArrayList<WindField> wfields = new ArrayList<WindField>();
		dir = "./datasets/500mb/";
		deriv = "mean";
		for (int k=0; k<=87; k+=3){
			String fhr = String.format("%02d", k);
			String file  = dir + "sref.t" + run + "z.pgrb" + grid + ".f" + fhr + ".WSPD."+ deriv + ".txt";
			String file2 = dir + "sref.t" + run + "z.pgrb" + grid + ".f" + fhr + ".WDIR."+ deriv + ".txt";
			wf = new WindField(file, file2, samplesx, samplesy, corner, samplesy*spacing, samplesx*spacing);
			wfields.add(wf);
		}
	
		w_encd = new WindEncoding(wfields, glyphs);
		w_encd.useBilinear(true);
		w_encd.useInterpolation(false);
		w_encd.setColorMap(test);
		w_encd.genIsovalues(0, 10);
		library.add(new WindSelect(tabw,tabh,color(162,60,0), w_encd, "500mb", "mean"));
		
	}

}