class ProbabilityView extends View {
	ConditionTarget target0;
	
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
	
	Switch joint_switch;
	
	ProbabilityView(int sx, int sy, float ds, int cx, int cy, int tw, int th, int libsize){
		super(sx, sy, ds, cx, cy, tw, th, libsize);
		
		joint_switch = new Switch(cornerx+(samplesx*spacing)-120, cornery-tabh-10, 16, 14);
		joint_switch.setColors(color(170), color(110), color(70));
		joint_switch.setLabels("JOINT", "INDEPENDENT"); 
		
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
		
		
		ColorMapf test = new ColorMapf();
        test.add(  0, color(164, 206, 197, 0));
		test.add( 49.9999, color(164, 206, 197, 0));
		test.add( 50, color(164, 206, 197, 255));
		test.add( 70, color(92, 120, 162, 255));
		test.add( 90, color(127, 98, 149, 255));
		test.add(100, color(138, 78, 108, 255));
				
		ColorMapf test2 = new ColorMapf();
        test2.add(  0, color(164, 206, 197, 0));
		test2.add(29.9999, color(164, 206, 197, 0));
		test2.add( 30, color(164, 206, 197, 255));
		test2.add( 50, color(164, 206, 197, 255));
		test2.add( 70, color(92, 120, 162, 255));
		test2.add( 90, color(127, 98, 149, 255));
		test2.add(100, color(138, 78, 108, 255));
				
		// Initialize Targets		
		target0 = new ConditionTarget(cornerx+10,cornery-tabh-10,tabw,tabh,4,1);
		target0.linkImage(fill);
		target0.linkLegend(legend);
		target0.linkContours(contours);
		target0.linkQuadTree(cselect);
		target0.linkTimeControl(timer);
		target0.setLabel("CONDITIONS");
		target0.treatConditionsAsIndependent(false);
		target0.useBilinear(true);
		target0.useInterpolation(false);
		target0.linkLabels(labels);
		target0.genIsovalues(10.0, 20.0, 0.0, 100.0, false);
		target0.genIsovalues(10.0, 20.0, 0.0, 100.0, true);//alt
		target0.addIsovalue(5, true);//alt
		target0.setColorMap(test, test2);
		library.linkTarget(target0);
		targets.add(target0);
	}	
	
	void draw(){
		//update state if animating
		updateAnim();
		joint_switch.update();
		
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
		if (!target0.isHovering()){
			colorMode(HSB, 360, 100, 100, 100);
			stroke(0,0,15,100);
			strokeCap(SQUARE);
			drawContours(contours, color(0,0,0), 1.5);
			strokeCap(ROUND);
			colorMode(RGB,255);	
		}
		
		//labels
		for (StickyLabel l : labels){
			l.display();	
		}
		
		// draw controls
		library.display();
		legend.display();
		tracker.display();
		timer.display();
		joint_switch.display();
				
		errmsg = target0.getErrorMessage();
		if (!errmsg.isEmpty()){
			boolean fontsAvailable = (fReg != null) && (fErr != null);
			if (fontsAvailable){
				textFont(fErr);
				textSize(14);
			}
			else textSize(12);
			textAlign(CENTER, TOP);
			fill(120, 12, 12);
			text("Data for " + errmsg + " unavailable", cornerx+(samplesx*spacing/2), cornery+(samplesy*spacing)+5);
			if (fontsAvailable){
				textFont(fReg);
			}
		}
		else{ //Default Label
			textSize(11);
			textAlign(CENTER, TOP);
			fill(70);
			String full_label = (origin == null) ? "" : origin.getDateString(timer.getValue()); 
			text(full_label, cornerx+(samplesx*spacing/2), cornery+(samplesy*spacing)+5);
		}
		
		/*//frame rate for testing
		textSize(10);
		textAlign(RIGHT, BOTTOM);
		fill(70);
		text(frameRate, width-3, height-3);
		textSize(10);*/
		
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
	
	
	protected boolean press(int mx, int my, int clickCount){
		if (joint_switch.clicked(mx, my) || super.press(mx,my,clickCount)) return true;
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
			
	
	protected boolean move(int mx, int my){
		if (joint_switch.interact(mx, my) || super.move(mx,my)){
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
		if (joint_switch.interact(mx, my) || super.drag(mx,my)) return true;
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
	
	
	protected boolean release(){
		if(joint_switch.released()){
			target0.treatConditionsAsIndependent(joint_switch.isOn());
			target0.updateRenderContext();
			return true;
		}
		else if (super.release()) return true;
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
		/*if (key == 'p'){

		}
		*/
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
		
		addProbSelect( dataDir+"/Probabilities/2m_RH/", run_input,    "le.15",   "RH",  "2m",     "≤ 10%", 0);
		addProbSelect( dataDir+"/Probabilities/2m_RH/", run_input,    "ge.30",   "RH",  "2m",     "≥ 30%", 0);
		addProbSelect( dataDir+"/Probabilities/10m_WSPD/", run_input,    "ge.20", "WSPD", "10m",   "≥ 20mph", 0);
		
		addProbSelect( dataDir+"/Probabilities/Haines/High/", run_input, "ge.5", "Haines", "High", "5 or 6", 0);
		addProbSelect( dataDir+"/Probabilities/Haines/High/", run_input, "ge.3.le.4", "Haines", "High", "3 or 4", 0);
		
		addProbSelect( dataDir+"/Probabilities/12hr_APCP/", run_input, "le.0.254", 12, "APCP", "12hr", "≤ 0.01in", 0);
		
		/*ConditionEnsemble f;
		ConditionSelect c;
		PVector corner = new PVector(cornerx, cornery);*/
		
	
		/*// 2m_RH
		String dir = dataDir + "/Probabilities/2m_RH/";
		String run = String.format("%02d", run_input);
		String grid = "212";

		String deriv = "le.10";
		ArrayList<ConditionEnsemble> fields = new ArrayList<ConditionEnsemble>();
		for (int k=0; k<=87; k+=3){
			String fhr = String.format("%02d", k);
			String file = dir + "sref.t" + run + "z.pgrb" + grid + ".f" + fhr + "."+ deriv + ".txt";
			f = new ConditionEnsemble(file, samplesx, samplesy, 21, corner, samplesy*spacing, samplesx*spacing);
			fields.add(f);
		}
		c = new ConditionSelect(tabw,tabh,c2m, fields, "RH", "2m", "≤ 10%");
		c.setSingleCopy(true);
		library.add(c);

		deriv = "le.15";
		fields = new ArrayList<ConditionEnsemble>();
		for (int k=0; k<=87; k+=3){
			String fhr = String.format("%02d", k);
			String file = dir + "sref.t" + run + "z.pgrb" + grid + ".f" + fhr + "."+ deriv + ".txt";
			f = new ConditionEnsemble(file, samplesx, samplesy, 21, corner, samplesy*spacing, samplesx*spacing);
			fields.add(f);
		}
		c = new ConditionSelect(tabw,tabh,c2m, fields, "RH", "2m", "≤ 15%");
		c.setSingleCopy(true);
		library.add(c);

		deriv = "le.20";
		fields = new ArrayList<ConditionEnsemble>();
		for (int k=0; k<=87; k+=3){
			String fhr = String.format("%02d", k);
			String file = dir + "sref.t" + run + "z.pgrb" + grid + ".f" + fhr + "."+ deriv + ".txt";
			f = new ConditionEnsemble(file, samplesx, samplesy, 21, corner, samplesy*spacing, samplesx*spacing);
			fields.add(f);
		}
		c = new ConditionSelect(tabw,tabh,c2m, fields, "RH", "2m", "≤ 20%");
		c.setSingleCopy(true);
		library.add(c);

		deriv = "le.25";
		fields = new ArrayList<ConditionEnsemble>();
		for (int k=0; k<=87; k+=3){
			String fhr = String.format("%02d", k);
			String file = dir + "sref.t" + run + "z.pgrb" + grid + ".f" + fhr + "."+ deriv + ".txt";
			f = new ConditionEnsemble(file, samplesx, samplesy, 21, corner, samplesy*spacing, samplesx*spacing);
			fields.add(f);
		}
		c = new ConditionSelect(tabw,tabh,c2m, fields, "RH", "2m", "≤ 25%");
		c.setSingleCopy(true);
		library.add(c);

		deriv = "le.30";
		fields = new ArrayList<ConditionEnsemble>();
		for (int k=0; k<=87; k+=3){
			String fhr = String.format("%02d", k);
			String file = dir + "sref.t" + run + "z.pgrb" + grid + ".f" + fhr + "."+ deriv + ".txt";
			f = new ConditionEnsemble(file, samplesx, samplesy, 21, corner, samplesy*spacing, samplesx*spacing);
			fields.add(f);
		}
		c = new ConditionSelect(tabw,tabh,c2m, fields, "RH", "2m", "≤ 30%");
		c.setSingleCopy(true);
		library.add(c);


		// 2m_TMP
		dir = dataDir + "/Probabilities/2m_TMP/";

		deriv = "ge.288.706";
		fields = new ArrayList<ConditionEnsemble>();
		for (int k=0; k<=87; k+=3){
			String fhr = String.format("%02d", k);
			String file = dir + "sref.t" + run + "z.pgrb" + grid + ".f" + fhr + "."+ deriv + ".txt";
			f = new ConditionEnsemble(file, samplesx, samplesy, 21, corner, samplesy*spacing, samplesx*spacing);
			fields.add(f);
		}
		c = new ConditionSelect(tabw,tabh,c2m, fields, "TMP", "2m", "≥ 60F");
		c.setSingleCopy(true);
		library.add(c);


		// 10m_WSPD
		dir = dataDir + "/Probabilities/10m_WSPD/";

		deriv = "ge.10";
		fields = new ArrayList<ConditionEnsemble>();
		for (int k=0; k<=87; k+=3){
			String fhr = String.format("%02d", k);
			String file = dir + "sref.t" + run + "z.pgrb" + grid + ".f" + fhr + "."+ deriv + ".txt";
			f = new ConditionEnsemble(file, samplesx, samplesy, 21, corner, samplesy*spacing, samplesx*spacing);
			fields.add(f);
		}
		c = new ConditionSelect(tabw,tabh,c10m, fields, "WSPD", "10m", "≥ 10mph");
		c.setSingleCopy(true);
		library.add(c);


		deriv = "ge.15";
		fields = new ArrayList<ConditionEnsemble>();
		for (int k=0; k<=87; k+=3){
			String fhr = String.format("%02d", k);
			String file = dir + "sref.t" + run + "z.pgrb" + grid + ".f" + fhr + "."+ deriv + ".txt";
			f = new ConditionEnsemble(file, samplesx, samplesy, 21, corner, samplesy*spacing, samplesx*spacing);
			fields.add(f);
		}
		c = new ConditionSelect(tabw,tabh,c10m, fields, "WSPD", "10m", "≥ 15mph");
		c.setSingleCopy(true);
		library.add(c);


		deriv = "ge.20";
		fields = new ArrayList<ConditionEnsemble>();
		for (int k=0; k<=87; k+=3){
			String fhr = String.format("%02d", k);
			String file = dir + "sref.t" + run + "z.pgrb" + grid + ".f" + fhr + "."+ deriv + ".txt";
			f = new ConditionEnsemble(file, samplesx, samplesy, 21, corner, samplesy*spacing, samplesx*spacing);
			fields.add(f);
		}
		c = new ConditionSelect(tabw,tabh,c10m, fields, "WSPD", "10m", "≥ 20mph");
		c.setSingleCopy(true);
		library.add(c);

		deriv = "ge.30";
		fields = new ArrayList<ConditionEnsemble>();
		for (int k=0; k<=87; k+=3){
			String fhr = String.format("%02d", k);
			String file = dir + "sref.t" + run + "z.pgrb" + grid + ".f" + fhr + "."+ deriv + ".txt";
			f = new ConditionEnsemble(file, samplesx, samplesy, 21, corner, samplesy*spacing, samplesx*spacing);
			fields.add(f);
		}
		c = new ConditionSelect(tabw,tabh,c10m, fields, "WSPD", "10m", "≥ 30mph");
		c.setSingleCopy(true);
		library.add(c);


		// 3hr_APCP
		dir = dataDir + "/Probabilities/3hr_APCP/";

		deriv = "le.0.254";
		fields = new ArrayList<ConditionEnsemble>();
		for (int k=0; k<=87; k+=3){
			if (k >= 3){
				String fhr = String.format("%02d", k);
				String file = dir + "sref.t" + run + "z.pgrb" + grid + ".f" + fhr + "."+ deriv + ".txt";
				f = new ConditionEnsemble(file, samplesx, samplesy, 21, corner, samplesy*spacing, samplesx*spacing);
			}
			else f = new ConditionEnsemble();
			fields.add(f);
		}
		c = new ConditionSelect(tabw,tabh,cSurface, fields, "APCP", "3hr", "≤ 0.01in");
		c.setSingleCopy(true);
		library.add(c);


		deriv = "le.1.27";
		fields = new ArrayList<ConditionEnsemble>();
		for (int k=0; k<=87; k+=3){
			if (k >= 3){
				String fhr = String.format("%02d", k);
				String file = dir + "sref.t" + run + "z.pgrb" + grid + ".f" + fhr + "."+ deriv + ".txt";
				f = new ConditionEnsemble(file, samplesx, samplesy, 21, corner, samplesy*spacing, samplesx*spacing);
			}
			else f = new ConditionEnsemble();
			fields.add(f);
		}
		c = new ConditionSelect(tabw,tabh,cSurface, fields, "APCP", "3hr", "≤ 0.05in");
		c.setSingleCopy(true);
		library.add(c);


		deriv = "le.2.54";
		fields = new ArrayList<ConditionEnsemble>();
		for (int k=0; k<=87; k+=3){
			if (k >= 3){
				String fhr = String.format("%02d", k);
				String file = dir + "sref.t" + run + "z.pgrb" + grid + ".f" + fhr + "."+ deriv + ".txt";
				f = new ConditionEnsemble(file, samplesx, samplesy, 21, corner, samplesy*spacing, samplesx*spacing);
			}
			else f = new ConditionEnsemble();
			fields.add(f);
		}
		c = new ConditionSelect(tabw,tabh,cSurface, fields, "APCP", "3hr", "≤ 0.1in");
		c.setSingleCopy(true);
		library.add(c);

		//12hr_APCP
		dir = dataDir + "/Probabilities/12hr_APCP/";

		deriv = "le.0.254";
		fields = new ArrayList<ConditionEnsemble>();
		for (int k=0; k<=87; k+=3){
			if (k >= 12){
				String fhr = String.format("%02d", k);
				String file = dir + "sref.t" + run + "z.pgrb" + grid + ".f" + fhr + "."+ deriv + ".txt";
				f = new ConditionEnsemble(file, samplesx, samplesy, 21, corner, samplesy*spacing, samplesx*spacing);
			}
			else f = new ConditionEnsemble();
			fields.add(f);
		}
		c = new ConditionSelect(tabw,tabh,cSurface, fields, "APCP", "12hr", "≤ 0.01in");
		c.setSingleCopy(true);
		library.add(c);

		deriv = "le.2.54";
		fields = new ArrayList<ConditionEnsemble>();
		for (int k=0; k<=87; k+=3){
			if (k >= 12){
				String fhr = String.format("%02d", k);
				String file = dir + "sref.t" + run + "z.pgrb" + grid + ".f" + fhr + "."+ deriv + ".txt";
				f = new ConditionEnsemble(file, samplesx, samplesy, 21, corner, samplesy*spacing, samplesx*spacing);
			}
			else f = new ConditionEnsemble();
			fields.add(f);
		}
		c = new ConditionSelect(tabw,tabh,cSurface, fields, "APCP", "12hr", "≤ 0.1in");
		c.setSingleCopy(true);
		library.add(c);*/
		
		// //TEST
		// fields = new ArrayList<ConditionEnsemble>();
		// String file = dataDir + "/tmp/TestCond1.txt";
		// f = new ConditionEnsemble(file, samplesx, samplesy, 21, corner, samplesy*spacing, samplesx*spacing);
		// for (int k=0; k<=87; k+=3){
		// 	fields.add(f);
		// }
		// library.add(new ConditionSelect(tabw,tabh,c2m, fields, "TEST", "1", "COND"));
		// fields = new ArrayList<ConditionEnsemble>();
		// file = dataDir + "/tmp/TestCond2.txt";
		// f = new ConditionEnsemble(file, samplesx, samplesy, 21, corner, samplesy*spacing, samplesx*spacing);
		// for (int k=0; k<=87; k+=3){
		// 	fields.add(f);
		// }
		// library.add(new ConditionSelect(tabw,tabh,c2m, fields, "TEST", "2", "COND"));
		
	}
	
	private void addProbSelect(String dataDir, int run_input, String deriv, String vlabel, String hlabel, String dlabel, int libIndex){
		
		PVector corner = new PVector(cornerx, cornery);
		String run = String.format("%02d", run_input);
		String grid = "212";
		
		ConditionEnsemble f;
		ArrayList<ConditionEnsemble> fields = new ArrayList<ConditionEnsemble>();
		for (int k=0; k<=87; k+=3){
			String fhr = String.format("%02d", k);
			String file = dataDir + "sref.t" + run + "z.pgrb" + grid + ".f" + fhr + "."+ deriv + ".txt";
			f = new ConditionEnsemble(file, samplesx, samplesy, 21, corner, samplesy*spacing, samplesx*spacing);
			fields.add(f);
		}
		ConditionSelect c = new ConditionSelect(tabw, tabh, fields, vlabel, hlabel, dlabel);
		c.setSingleCopy(true);
		library.add(c,libIndex);
		
	}
	
	private void addProbSelect(String dataDir, int run_input, String deriv, int dne_below_fhr, String vlabel, String hlabel, String dlabel, int libIndex){
				
		PVector corner = new PVector(cornerx, cornery);
		String run = String.format("%02d", run_input);
		String grid = "212";
		
		ConditionEnsemble f;
		ArrayList<ConditionEnsemble> fields = new ArrayList<ConditionEnsemble>();
		for (int k=0; k<=87; k+=3){
			if (k < dne_below_fhr){
				f = new ConditionEnsemble();
			}
			else{
				String fhr = String.format("%02d", k);
				String file = dataDir + "sref.t" + run + "z.pgrb" + grid + ".f" + fhr + "."+ deriv + ".txt";
				f = new ConditionEnsemble(file, samplesx, samplesy, 21, corner, samplesy*spacing, samplesx*spacing);
			}
			fields.add(f);
		}
		ConditionSelect c = new ConditionSelect(tabw, tabh, fields, vlabel, hlabel, dlabel);
		c.setSingleCopy(true);
		library.add(c,libIndex);
	}
	
	

}