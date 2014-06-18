class EnsembleView extends View {
	
	Switch cbp_switch;
		
	EnsembleTarget target0; //TODO deal with same selectable in multiple targets? 
	EnsembleTarget target1;
	EnsembleTarget target2;
	
	ArrayList<Contour2D> contours_0;
	ArrayList<Contour2D> contours_1;
	ArrayList<Contour2D> contours_2;
	
	ArrayList<TextHoverable> member_select0;
	ArrayList<TextHoverable> member_select1;
	ArrayList<TextHoverable> member_select2;
	TextHoverable lastHoverable;
	
	color c0, c1, c2;
	
	boolean selectFromContour;
	
	QuadTree_Node<Segment2D> cselect_0;
	QuadTree_Node<Segment2D> cselect_1;
	QuadTree_Node<Segment2D> cselect_2;
	
	Contour2D highlight;
	int target_index;
	int member_index;
	
	EnsembleView(int sx, int sy, float ds, int cx, int cy, int tw, int th, int libsize){
		super(sx, sy, ds, cx, cy, tw, th, ceil(libsize/2.0));
		
		int n = 50;
		
		// Controls
		cbp_switch = new Switch(cornerx+(samplesx*spacing)-60, cornery-tabh-10, 16, 14);
		cbp_switch.setColors(color(170), color(110), color(70));
		cbp_switch.setLabels("SP", "CBP"); 
		
		// Initialize Render State				
		//Contours
		contours_0 = new ArrayList<Contour2D>();
		contours_1 = new ArrayList<Contour2D>();
		contours_2 = new ArrayList<Contour2D>();
		
		member_select0 = new ArrayList<TextHoverable>();
		member_select1 = new ArrayList<TextHoverable>();
		member_select2 = new ArrayList<TextHoverable>();
		
		cselect_0 = new QuadTree_Node<Segment2D>(cornerx, cornery, cornerx+samplesx*spacing, cornery+samplesy*spacing, n);
		cselect_1 = new QuadTree_Node<Segment2D>(cornerx, cornery, cornerx+samplesx*spacing, cornery+samplesy*spacing, n);
		cselect_2 = new QuadTree_Node<Segment2D>(cornerx, cornery, cornerx+samplesx*spacing, cornery+samplesy*spacing, n);
		
		highlight = null;
		target_index = -1;
		member_index = -2;
				
		c0 = color(64, 56, 118, 200);
		c1 = color(47, 110, 53, 200);
		c2 = color(110, 47, 47, 200);
				
		// Initialize Targets
		target0 = new EnsembleTarget(cornerx+10,cornery-tabh-10,tabw,tabh);
		target0.linkSPContours(contours_0);
		target0.linkSPQuadTree(cselect_0);
		target0.linkTimeControl(timer);
		target0.linkSwitch(cbp_switch);
		target0.linkSPHoverables(member_select0, (library.getMinXY()).x+15, (library.getMaxXY()).y + 45);
		target0.setLabel("CONTOURS");
		target0.setColor(c0);
		library.linkTarget(target0);
		targets.add(target0);
					
		target1 = new EnsembleTarget(cornerx+10+(1*(tabw+4)),cornery-tabh-10,tabw,tabh);
		target1.linkSPContours(contours_1);
		target1.linkSPQuadTree(cselect_1);
		target1.linkTimeControl(timer);
		target1.linkSwitch(cbp_switch);
		target1.linkSPHoverables(member_select1, (library.getMinXY()).x+75, (library.getMaxXY()).y + 45);
		target1.setLabel("CONTOURS");
		target1.setColor(c1);
		library.linkTarget(target1);
		targets.add(target1);
		
		target2 = new EnsembleTarget(cornerx+10+(2*(tabw+4)),cornery-tabh-10,tabw,tabh);
		target2.linkSPContours(contours_2);
		target2.linkSPQuadTree(cselect_2);
		target2.linkTimeControl(timer);
		target2.linkSwitch(cbp_switch);
		target2.linkSPHoverables(member_select2, (library.getMinXY()).x+135, (library.getMaxXY()).y + 45);
		target2.setLabel("CONTOURS");
		target2.setColor(c2);
		library.linkTarget(target2);
		targets.add(target2);
		
		selectFromContour = false;
		lastHoverable = null;
	}
	
	void updateAnim(){
		super.updateAnim();
		if (highlight != null && !selectFromContour){
			switch (target_index){
				case 0:
					highlight = contours_0.get(member_index);
					break;
				case 1:
					highlight = contours_1.get(member_index);
					break;
				case 2:
					highlight = contours_2.get(member_index);
					break;
				default:
			}
		}
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
			
			boolean someHovering = target2.isHovering() | target1.isHovering() | target0.isHovering();
			int s_1, s_2, b_1, b_2, a;
			
			//draw contours
			colorMode(HSB, 360, 100, 100, 100);
			stroke(0,0,15,100);
			strokeCap(SQUARE);
			
			// Target 2
			if (!target2.isHovering()){
				if (someHovering){ //grey out
					s_1 = 0;
					s_2 = 12;
					b_1 = 90;
					b_2 = 50;
					a = 70;
				}
				else{ //default draw
					s_1 = 22;
					s_2 = 34;
					b_1 = 90;
					b_2 = 50;
					a = 100;
				}
				drawContours(contours_2,   0, s_1, s_2, b_1, b_2, a, color(0,50,27,100), 1.5, 2.5);
			}
			
			// Target 1
			if (!target1.isHovering()){
				if (someHovering){ //grey out
					s_1 = 0;
					s_2 = 12;
					b_1 = 90;
					b_2 = 50;
					a = 70;
				}
				else{ //default draw
					s_1 = 22;
					s_2 = 34;
					b_1 = 90;
					b_2 = 50;
					a = 100;
				}
				drawContours(contours_1, 119, s_1, s_2, b_1, b_2, a, color(119,50,27,100), 1.5, 2.5);
			}
			
			// Target 0
			if (!target0.isHovering()){
				if (someHovering){ //grey out
					s_1 = 0;
					s_2 = 12;
					b_1 = 90;
					b_2 = 50;
					a = 70;
				}
				else{ //default draw
					s_1 = 22;
					s_2 = 34;
					b_1 = 90;
					b_2 = 50;
					a = 100;
				}
				drawContours(contours_0, 239, s_1, s_2, b_1, b_2, a, color(239,50,27,100), 1.5, 2.5);
			}
			
			// Hover over Top
			if (someHovering){
				s_1 = 27;
				s_2 = 44;
				b_1 = 80;
				b_2 = 40;
				a = 100;
				if(target2.isHovering()) drawContours(contours_2,   0, s_1, s_2, b_1, b_2, a, color(0,50,27,100), 1.5, 2.5);
				else if(target1.isHovering()) drawContours(contours_1, 119, s_1, s_2, b_1, b_2, a, color(119,50,27,100), 1.5, 2.5);
				else drawContours(contours_0, 239, s_1, s_2, b_1, b_2, a, color(239,50,27,100), 1.5, 2.5);
			}
			
			strokeCap(ROUND);
			colorMode(RGB,255);
			
				
		}
				
		// draw controls
		library.display();
		tracker.display();
		timer.display();
		cbp_switch.display();
		
		if (target0.hasSelectable()){
			// group label
			float tmpx, tmpy;
			tmpx = (library.getMinXY()).x + 15;
			tmpy = (library.getMaxXY()).y + 42;
			
			textSize(8);
			textAlign(LEFT, BOTTOM);
			fill(70);
			String label = "MEMBERS";			
			text(label, tmpx, tmpy);
			stroke(170);
			strokeWeight(1);
			fill(c0);
			rect(tmpx-11, tmpy-textAscent()-textDescent(), 9, 9);
			noStroke();
			noFill();
			
			// member labels
			for (int i=0; i < member_select0.size(); i++){
				TextHoverable h = member_select0.get(i);
				if (selectFromContour && (target_index == 0)) h.rollover = (i == member_index);
				h.display();
			}
		}
		
		if (target1.hasSelectable()){
			// group label
			float tmpx, tmpy;
			tmpx = (library.getMinXY()).x + 75;
			tmpy = (library.getMaxXY()).y + 42;
			
			textSize(8);
			textAlign(LEFT, BOTTOM);
			fill(70);
			String label = "MEMBERS";			
			text(label, tmpx, tmpy);
			stroke(170);
			strokeWeight(1);
			fill(c1);
			rect(tmpx-11, tmpy-textAscent()-textDescent(), 9, 9);
			noStroke();
			noFill();
			
			// member labels
			for (int i=0; i < member_select1.size(); i++){
				TextHoverable h = member_select1.get(i);
				if (selectFromContour && (target_index == 1)) h.rollover = (i == member_index);
				h.display();
			}
		}
		
		if (target2.hasSelectable()){
			// group label
			float tmpx, tmpy;
			tmpx = (library.getMinXY()).x + 135;
			tmpy = (library.getMaxXY()).y + 42;
			
			textSize(8);
			textAlign(LEFT, BOTTOM);
			fill(70);
			String label = "MEMBERS";			
			text(label, tmpx, tmpy);
			stroke(170);
			strokeWeight(1);
			fill(c2);
			rect(tmpx-11, tmpy-textAscent()-textDescent(), 9, 9);
			noStroke();
			noFill();
			
			// member labels
			for (int i=0; i < member_select2.size(); i++){
				TextHoverable h = member_select2.get(i);
				if (selectFromContour && (target_index == 2)) h.rollover = (i == member_index);
				h.display();
			}
		}
		
		//frame rate for testing
		textSize(10);
		textAlign(RIGHT, BOTTOM);
		fill(70);
		text(frameRate, width-3, height-3);
		textSize(10);
		
		//selection tooltip
		if (selectFromContour) drawToolTip();
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
				trigger = true;
				continue;
			}
			c.drawContour();
		}
	
		//draw selection
		if ((highlight != null) && trigger){
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
		boolean trigger = false;
		Contour2D c;
		for (int i=0; i<n; i++){
			int s = int(map(i, 0, n-1, s_min, s_max));
			int b = int(map(i, 0, n-1, b_min, b_max));
			stroke(h,s,b,a);
			c = contours.get(i);
			if (c == highlight){
				trigger = true;
				continue;
			} 
			c.drawContour();
		}

		//draw selection
		if ((highlight != null) && trigger){
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
			rect(mouseX - textWidth(s)/2 -2, mouseY-textAscent()-textDescent()-5, textWidth(s)+4, textAscent()+textDescent());
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
			if (cbp_switch.isOn()){
				//CBP
				return false;											
			}
			else {
				return selectHighlight();
			}
		}
	}
	
	protected boolean drag(int mx, int my){
		return cbp_switch.interact(mx, my) || super.drag(mx,my);
	}
	
	protected boolean release(){
		return cbp_switch.released() || super.release();
	}
	
	private boolean selectHighlight(){
		//Spaghetti Plots                                           //TODO better solution than nested if statements?
		Segment2D selection = cselect_0.select(mouseX, mouseY, 2);			
		if (selection != null){
			highlight = selection.getSrcContour();
			target_index = 0;
			member_index = contours_0.indexOf(highlight);
			selectFromContour = true;
			return true;
		}
		else{
			selection = cselect_1.select(mouseX, mouseY, 2);
			if (selection != null){
				highlight = selection.getSrcContour();
				target_index = 1;
				member_index = contours_1.indexOf(highlight);
				selectFromContour = true;
				return true;
			}
			else{
				selection = cselect_2.select(mouseX, mouseY, 2);
				if (selection != null){
					highlight = selection.getSrcContour();
					target_index = 2;
					member_index = contours_2.indexOf(highlight);
					selectFromContour = true;
					return true;
				}
				else{
					boolean rval = false;
					highlight = null;
					target_index = -1;
					member_index = -2;
					selectFromContour = false;
					if (lastHoverable != null){
						lastHoverable.rollover = false;
						lastHoverable = null;
					}
					
					if(target0.hasSelectable()){
						for (int i=0; i < member_select0.size(); i++){
							TextHoverable tmp = member_select0.get(i);
							if (tmp.interact(mouseX,mouseY)){
								target_index = 0;
								member_index = i;
								highlight = contours_0.get(i);
								lastHoverable = tmp;
								rval=true;
								break; 
							}
						}
					}
					
					if(rval != true && target1.hasSelectable()){
						for (int i=0; i < member_select1.size(); i++){
							TextHoverable tmp = member_select1.get(i);
							if (tmp.interact(mouseX,mouseY)){
								target_index = 1;
								member_index = i;
								highlight = contours_1.get(i);
								lastHoverable = tmp;
								rval=true;
								break; 
							}
						}
					}
					
					if(rval != true && target2.hasSelectable()){
						for (int i=0; i < member_select2.size(); i++){
							TextHoverable tmp = member_select2.get(i);
							if (tmp.interact(mouseX,mouseY)){
								target_index = 2;
								member_index = i;
								highlight = contours_2.get(i);
								lastHoverable = tmp;
								rval=true;
								break; 
							}
						}
					}
					
					return rval;
				}
			}
		}
	}
			
	
	void loadData(){
		
		
		Field f;
		EnsembleEncoding encd;
		EnsembleSelect select;
		PVector corner = new PVector(cornerx, cornery);
		
		color c700mb, c500mb;
		c500mb = color(83,30,175);
		c700mb = color(0,116,162);
		
		String dir = "./datasets/EnsembleFields/500mb_TMP/";
		String run = "21";
		String grid = "212";
		String[] models = {"em", "nmm", "nmb"};
		String[] perturbations = {"ctl", "n1", "n2", "n3", "p1", "p2", "p3"};
		
		int initCapacity = models.length*perturbations.length;
		ArrayList<String> member_labels = new ArrayList<String>(initCapacity);
		
		//500mb TMP
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
				member_labels.add( models[i] + " " + perturbations[j] );
			}
		}
		
		// Create Selectables
		encd = new EnsembleEncoding(ensemble);
		encd.setMemberLabels(member_labels);
		encd.setIsovalue(258.15);//-15 C
		select = new EnsembleSelect(tabw,tabh,c500mb, encd, "TMP", "500mb", "258.15˚ K");
		select.setSingleCopy(true);
		library.add(select);
		
		encd = new EnsembleEncoding(ensemble);
		encd.setMemberLabels(member_labels);
		encd.setIsovalue(253.15);//-20 C
		select = new EnsembleSelect(tabw,tabh,c500mb, encd, "TMP", "500mb", "253.15˚ K");
		select.setSingleCopy(true);
		library.add(select);
		
		encd = new EnsembleEncoding(ensemble);
		encd.setMemberLabels(member_labels);
		encd.setIsovalue(248.15);//-25 C
		select = new EnsembleSelect(tabw,tabh,c500mb, encd, "TMP", "500mb", "248.15˚ K");
		select.setSingleCopy(true);
		library.add(select);
		
		
		//700mb TMP
		dir = "./datasets/EnsembleFields/700mb_TMP/";
		ensemble = new ArrayList< ArrayList<Field> >(initCapacity);
		
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
			}
		}
		
		encd = new EnsembleEncoding(ensemble);
		encd.setMemberLabels(member_labels);
		encd.setIsovalue(283.15);//10 C
		select = new EnsembleSelect(tabw,tabh,c700mb, encd, "TMP", "700mb", "283.15˚ K");
		select.setSingleCopy(true);
		library.add(select);
		
		
		encd = new EnsembleEncoding(ensemble);
		encd.setMemberLabels(member_labels);
		encd.setIsovalue(288.15);//15 C
		select = new EnsembleSelect(tabw,tabh,c700mb, encd, "TMP", "700mb", "288.15˚ K");
		select.setSingleCopy(true);
		library.add(select);
		
	}

}