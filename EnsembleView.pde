class EnsembleView extends View {
	
	Switch cbp_switch;
		
	EnsembleTarget target0; //TODO deal with same selectable in multiple targets? 
	// EnsembleTarget target1;
	// EnsembleTarget target2;
	
	ArrayList<Contour2D> contours_0;
	// ArrayList<Contour2D> contours_1;
	// ArrayList<Contour2D> contours_2;
	
	QuadTree_Node<Segment2D> cselect_0;
	// QuadTree_Node<Segment2D> cselect_1;
	// QuadTree_Node<Segment2D> cselect_2;
	
	Contour2D highlight;
	
	EnsembleView(int sx, int sy, float ds, int cx, int cy, int tw, int th, int libsize){
		super(sx, sy, ds, cx, cy, tw, th, ceil(libsize/2.0));
		
		int ensbMembCount = 21;// TODO shouldn't be hardcoded
		
		// Controls
		cbp_switch = new Switch(cornerx+(samplesx*spacing)-60, cornery-tabh-10, 16, 14);
		cbp_switch.setColors(color(170), color(110), color(70));
		cbp_switch.setLabels("SP", "CBP"); 
		
		
		// Initialize Render State				
		//Contours
		contours_0 = new ArrayList<Contour2D>();
		// contours_1 = new ArrayList<Contour2D>();
		// contours_2 = new ArrayList<Contour2D>();
		
		cselect_0 = new QuadTree_Node<Segment2D>(cornerx, cornery, cornerx+samplesx*spacing, cornery+samplesy*spacing, ensbMembCount);
		// cselect_1 = new QuadTree_Node<Segment2D>(cornerx, cornery, cornerx+samplesx*spacing, cornery+samplesy*spacing, ensbMembCount);
		// cselect_2 = new QuadTree_Node<Segment2D>(cornerx, cornery, cornerx+samplesx*spacing, cornery+samplesy*spacing, ensbMembCount);
		
		highlight = null;
				
		// Initialize Targets
		target0 = new EnsembleTarget(cornerx+10,cornery-tabh-10,tabw,tabh);
		target0.linkSPContours(contours_0);
		target0.linkSPQuadTree(cselect_0);
		target0.linkTimeControl(timer);
		target0.linkSwitch(cbp_switch);
		target0.setLabel("CONTOURS  [PURPLE]");
		library.linkTarget(target0);
		targets.add(target0);
	}
	
	void draw(){
		//update state if animating
		updateAnim();
		cbp_switch.update();
		
		//draw map bg
		fill(255);
		noStroke();
		rect(cornerx, cornery, samplesx*spacing, samplesy*spacing, 0);
	
		//draw map
		if (map != null){
			strokeWeight(2);
			stroke(255,255,255,255);//stroke(85,46,27,255);
			fill(210);//fill(247,241,230);
			shape(map, cornerx+(39*spacing), cornery+(35*spacing), 123*spacing, 75*spacing);
		}
		
		// TODO COLOR FILL or CONDENSE ^|v (?)
		
		// draw outline
		if (map != null){
			strokeWeight(2);
			stroke(255,255,255,255);//stroke(85,46,27,255);
			noFill();
			shape(map, cornerx+(39*spacing), cornery+(35*spacing), 123*spacing, 75*spacing);
		}	
	
		if (cbp_switch.isOn())
		{
		
		
		}
		else {
			// contours
			int s_1 = 27;
			int s_2 = 44;
			int b_1 = 80;
			int b_2 = 40;
			int a = 80;
			
			//draw contours
			colorMode(HSB, 360, 100, 100, 100);
			stroke(0,0,15,100);
			strokeCap(SQUARE);
			drawContours(contours_0, 239, s_1, s_2, b_1, b_2, a, color(239,40,21,100), (target0.isHovering() ? 2.0 : 1.0), 2.0);
			strokeCap(ROUND);
			colorMode(RGB,255);	
		}
				
		// draw controls
		library.display();
		tracker.display();
		timer.display();
		cbp_switch.display();
	
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
	
	protected void drawContours(ArrayList<Contour2D> contours, int h, int s_min, int s_max, int b_min, int b_max, int a, color select, float weight, float weight2)
	{
		noFill();
		strokeWeight(weight);
	
		int n = int(contours.size());
	
		//draw all but selection
		Contour2D c;
		for (int i=0; i<n; i++){
			int s = int(map(i, 0, n-1, s_min, s_max));
			int b = int(map(i, 0, n-1, b_min, b_max));
			stroke(h,s,b,a);
			c = contours.get(i);
			if (c == highlight) continue;
			c.drawContour();
		}

		//draw selection
		if ((highlight != null)){
			strokeWeight(weight2);
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
	
	protected boolean press(int mx, int my){
		return cbp_switch.clicked(mx, my) || super.press(mx,my);
	}
		
	protected boolean move(int mx, int my){
		if (cbp_switch.interact(mx, my) || super.move(mx,my)){
			return true;
		}
		else {
			Segment2D selection = cselect_0.select(mouseX, mouseY, 4);
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
	
	protected boolean drag(int mx, int my){
		return cbp_switch.interact(mx, my) || super.drag(mx,my);
	}
	
	protected boolean release(){
		return cbp_switch.released() || super.release();
	}
	
			
	
	void loadData(){
		
		
		Field f;
		EnsembleEncoding encd;
		PVector corner = new PVector(cornerx, cornery);
		
		color c700mb, c500mb;
		c500mb = color(83,30,175);
		c700mb = color(0,116,162);
		
		// 700mb tmp
		String dir = "./datasets/EnsembleFields/500mb_TMP/";
		String run = "21";
		String grid = "212";
		String[] models = {"em", "nmm", "nmb"};
		String[] perturbations = {"ctl", "n1", "n2", "n3", "p1", "p2", "p3"};
		
		int initCapacity = models.length*perturbations.length;
		ArrayList<String> member_labels = new ArrayList<String>(initCapacity);
		ArrayList< ArrayList<Field> > ensemble = new ArrayList< ArrayList<Field> >(initCapacity);
		
		for (int i=0; i < models.length; i++){
			for (int j=0; j < perturbations.length; j++){
				
				ArrayList<Field> member = new ArrayList<Field>(30);
				for (int k=0; k<=87; k+=3){
					String fhr = String.format("%02d", k);
					String file = dir + "sref_"+ models[i] +".t" + run + "z.pgrb" + grid +"." + perturbations[j] + ".f" + fhr + ".txt";
					f = new Field(file, samplesx, samplesy, corner, samplesy*spacing, samplesx*spacing);
					member.add(f);
				}
				ensemble.add(member);
				member_labels.add( " "+ models[i] + " " + perturbations[j] + " ");
			}
		}
		
		// Create Selectables
		encd = new EnsembleEncoding(ensemble);
		encd.setMemberLabels(member_labels);
		encd.setIsovalue(258.15);//-15 C
		library.add(new EnsembleSelect(tabw,tabh,c700mb, encd, "TMP", "500mb", "258.15˚ K"));
		
		encd = new EnsembleEncoding(ensemble);
		encd.setMemberLabels(member_labels);
		encd.setIsovalue(253.15);//-20 C
		library.add(new EnsembleSelect(tabw,tabh,c700mb, encd, "TMP", "500mb", "253.15˚ K"));
		
		encd = new EnsembleEncoding(ensemble);
		encd.setMemberLabels(member_labels);
		encd.setIsovalue(248.15);//-25 C
		library.add(new EnsembleSelect(tabw,tabh,c700mb, encd, "TMP", "500mb", "248.15˚ K"));
		
	}

}