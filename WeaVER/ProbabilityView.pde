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
		
		library.addCollection(3,4);
		library.addCollection(3,7);
		library.addCollection(3,3);
		
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
        test.add(  0,      color(179, 215, 207, 0));
		test.add( 49.9999, color(179, 215, 207, 0));
		test.add( 50,      color(179, 215, 207, 255));
		test.add( 70,      color(150, 170, 204, 255));
		test.add( 90,      color(140, 111, 160, 255));
		test.add(100,      color(139,  84, 112, 255));
				
		ColorMapf test2 = new ColorMapf();
        test2.add(  0, 		color(179, 215, 207, 0));
		test2.add(29.9999, 	color(179, 215, 207, 0));
		test2.add( 30, 		color(179, 215, 207, 255));
		test2.add( 50, 		color(179, 215, 207, 255));
		test2.add( 70, 		color(150, 170, 204, 255));
		test2.add( 90, 		color(140, 111, 160, 255));
		test2.add(100, 		color(139,  84, 112, 255));
				
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
			text("Data for " + errmsg + " unavailable", cornerx+(samplesx*spacing/2), cornery+(samplesy*spacing)+20);
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
		
		addProbSelect( dataDir+"/Probabilities/10m_WSPD/kts/", run_input, "ge.18", "WSPD", "10m", "≥ 18kts", 0);
		addProbSelect( dataDir+"/Probabilities/10m_WSPD/mph/", run_input, "ge.10", "WSPD", "10m", "≥ 10mph", 0);
		addProbSelect( dataDir+"/Probabilities/10m_WSPD/mph/", run_input, "ge.15", "WSPD", "10m", "≥ 15mph", 0);
		addProbSelect( dataDir+"/Probabilities/10m_WSPD/mph/", run_input, "ge.20", "WSPD", "10m", "≥ 20mph", 0);
		addProbSelect( dataDir+"/Probabilities/10m_WSPD/mph/", run_input, "ge.30", "WSPD", "10m", "≥ 30mph", 0);
		
		addProbSelect( dataDir+"/Probabilities/2m_TMP/" , run_input, "ge.288.706", "TMP",  "2m", "≥ 60F", 1);
		addProbSelect( dataDir+"/Probabilities/2m_RH/",   run_input, "le.10",      "RH",   "2m", "≤ 10%", 1);
		addProbSelect( dataDir+"/Probabilities/2m_RH/",   run_input, "le.15",      "RH",   "2m", "≤ 15%", 1);
		addProbSelect( dataDir+"/Probabilities/2m_RH/",   run_input, "le.20",      "RH",   "2m", "≤ 20%", 1);
		addProbSelect( dataDir+"/Probabilities/2m_RH/",   run_input, "le.25",      "RH",   "2m", "≤ 25%", 1);
		addProbSelect( dataDir+"/Probabilities/2m_RH/",   run_input, "le.30",      "RH",   "2m", "≤ 30%", 1);
		addProbSelect( dataDir+"/Probabilities/2m_RH/",   run_input, "le.35",      "RH",   "2m", "≤ 35%", 1);
		addProbSelect( dataDir+"/Probabilities/2m_RH/",   run_input, "ge.20",      "RH",   "2m", "≥ 20%", 1);
		addProbSelect( dataDir+"/Probabilities/2m_RH/",   run_input, "ge.25",      "RH",   "2m", "≥ 25%", 1);
		addProbSelect( dataDir+"/Probabilities/2m_RH/",   run_input, "ge.30",      "RH",   "2m", "≥ 30%", 1);
		addProbSelect( dataDir+"/Probabilities/2m_RH/",   run_input, "ge.40",      "RH",   "2m", "≥ 40%", 1);
		
		addProbSelect( dataDir+"/Probabilities/3hr_APCP/", run_input, "ge.0.254",   3, "APCP", "3hr", "≤ 0.01in", 2);
		addProbSelect( dataDir+"/Probabilities/3hr_APCP/", run_input, "ge.1.27",    3, "APCP", "3hr", "≤ 0.05in", 2);
		addProbSelect( dataDir+"/Probabilities/3hr_APCP/", run_input, "ge.2.54",    3, "APCP", "3hr",  "≤ 0.1in", 2);
		addProbSelect( dataDir+"/Probabilities/3hr_APCP/", run_input, "ge.6.35",    3, "APCP", "3hr", "≤ 0.25in", 2);
		addProbSelect( dataDir+"/Probabilities/3hr_APCP/", run_input, "ge.12.7",    3, "APCP", "3hr",  "≤ 0.5in", 2);
		
		addProbSelect( dataDir+"/Probabilities/6hr_APCP/", run_input, "ge.0.254",   6, "APCP", "6hr", "≤ 0.01in", 2);
		addProbSelect( dataDir+"/Probabilities/6hr_APCP/", run_input, "ge.1.27",    6, "APCP", "6hr", "≤ 0.05in", 2);
		addProbSelect( dataDir+"/Probabilities/6hr_APCP/", run_input, "ge.2.54",    6, "APCP", "6hr",  "≤ 0.1in", 2);
		addProbSelect( dataDir+"/Probabilities/6hr_APCP/", run_input, "ge.6.35",    6, "APCP", "6hr", "≤ 0.25in", 2);
		addProbSelect( dataDir+"/Probabilities/6hr_APCP/", run_input, "ge.12.7",    6, "APCP", "6hr",  "≤ 0.5in", 2);
		
		addProbSelect( dataDir+"/Probabilities/12hr_APCP/", run_input, "ge.0.254", 12, "APCP", "12hr", "≤ 0.01in", 2);
		addProbSelect( dataDir+"/Probabilities/12hr_APCP/", run_input, "ge.1.27",  12, "APCP", "12hr", "≤ 0.05in", 2);
		addProbSelect( dataDir+"/Probabilities/12hr_APCP/", run_input, "ge.2.54",  12, "APCP", "12hr",  "≤ 0.1in", 2);
		addProbSelect( dataDir+"/Probabilities/12hr_APCP/", run_input, "ge.6.35",  12, "APCP", "12hr", "≤ 0.25in", 2);
		addProbSelect( dataDir+"/Probabilities/12hr_APCP/", run_input, "ge.12.7",  12, "APCP", "12hr",  "≤ 0.5in", 2);
		
		addProbSelect( dataDir+"/Probabilities/24hr_APCP/", run_input, "ge.0.254", 24, "APCP", "24hr", "≤ 0.01in", 2);
		addProbSelect( dataDir+"/Probabilities/24hr_APCP/", run_input, "ge.1.27",  24, "APCP", "24hr", "≤ 0.05in", 2);
		addProbSelect( dataDir+"/Probabilities/24hr_APCP/", run_input, "ge.2.54",  24, "APCP", "24hr",  "≤ 0.1in", 2);
		addProbSelect( dataDir+"/Probabilities/24hr_APCP/", run_input, "ge.6.35",  24, "APCP", "24hr", "≤ 0.25in", 2);
		addProbSelect( dataDir+"/Probabilities/24hr_APCP/", run_input, "ge.12.7",  24, "APCP", "24hr",  "≤ 0.5in", 2);
		
		addProbSelect( dataDir+"/Probabilities/Haines/High/", run_input, "le.4", "Haines", "High", "≤ 4", 3);
		addProbSelect( dataDir+"/Probabilities/Haines/High/", run_input, "ge.5", "Haines", "High", "≥ 5", 3);
		addProbSelect( dataDir+"/Probabilities/Haines/High/", run_input, "ge.6", "Haines", "High", "≥ 6", 3);
		addProbSelect( dataDir+"/Probabilities/Haines/Med/", run_input, "le.4", "Haines", "Med", "≤ 4", 3);
		addProbSelect( dataDir+"/Probabilities/Haines/Med/", run_input, "ge.5", "Haines", "Med", "≥ 5", 3);
		addProbSelect( dataDir+"/Probabilities/Haines/Med/", run_input, "ge.6", "Haines", "Med", "≥ 6", 3);
		addProbSelect( dataDir+"/Probabilities/Haines/Low/", run_input, "le.4", "Haines", "Low", "≤ 4", 3);
		addProbSelect( dataDir+"/Probabilities/Haines/Low/", run_input, "ge.5", "Haines", "Low", "≥ 5", 3);
		addProbSelect( dataDir+"/Probabilities/Haines/Low/", run_input, "ge.6", "Haines", "Low", "≥ 6", 3);				
	}
	
	private void addProbSelect(String dataDir, int run_input, String deriv, String vlabel, String hlabel, String dlabel, int libIndex){
		
		PVector corner = new PVector(cornerx, cornery);
		String run = String.format("%02d", run_input);
		String grid = "212";
		
		loadDetails = "probability "+ hlabel + " " + vlabel + " " + dlabel;
		
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
		
		loadDetails = "probability "+ hlabel + " " + vlabel + " " + dlabel;
		
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