import java.io.FilenameFilter;

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
	
	WrappedContour2D median0;
	WrappedContour2D median1;
	WrappedContour2D median2;
	
	PImage bands0, bands1, bands2;
	
	ArrayList<Contour2D> outliers0;
	ArrayList<Contour2D> outliers1;
	ArrayList<Contour2D> outliers2;
	
	Contour2D highlight;
	int target_index;
	int member_index;
	QuadTree_Node<Segment2D> ctooltip;
	PVector tooltipPos;
	
	EnsembleView(int sx, int sy, float ds, int cx, int cy, int tw, int th, int libsize){
		super(sx, sy, ds, cx, cy, tw, th, libsize);
		
		//add collections to library
		//library.addCollection(2,2);
		
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
		ctooltip = new QuadTree_Node<Segment2D>(cornerx, cornery, cornerx+samplesx*spacing, cornery+samplesy*spacing, 7);
		tooltipPos = null;
				
		c0 = color(64, 56, 118, 200);
		c1 = color(47, 110, 53, 200);
		c2 = color(110, 47, 47, 200);
		
		median0 = new WrappedContour2D();
		median1 = new WrappedContour2D();
		median2 = new WrappedContour2D();
		
		bands0 = new PImage(int(samplesx*spacing), int(samplesy*spacing), ARGB);
		bands1 = new PImage(int(samplesx*spacing), int(samplesy*spacing), ARGB);
		bands2 = new PImage(int(samplesx*spacing), int(samplesy*spacing), ARGB);
		
		outliers0 = new ArrayList<Contour2D>();
		outliers1 = new ArrayList<Contour2D>();
		outliers2 = new ArrayList<Contour2D>();
				
		// Initialize Targets
		target0 = new EnsembleTarget(cornerx+10,cornery-tabh-10,tabw,tabh);
		target0.linkSPContours(contours_0);
		target0.linkSPQuadTree(cselect_0);
		target0.linkCBPMedian(median0);
		target0.linkCBPOutliers(outliers0);
		target0.linkCBPBands(bands0);
		target0.setBandColors(color(136,136,187), color(187,187,255));
		target0.linkTimeControl(timer);
		target0.linkSwitch(cbp_switch);
		target0.linkSPHoverables(member_select0, (library.getMinXY()).x+55, (library.getMaxXY()).y + 45);
		target0.setLabel("CONTOURS");
		target0.setColor(c0);
		library.linkTarget(target0);
		targets.add(target0);
					
		target1 = new EnsembleTarget(cornerx+10+(1*(tabw+4)),cornery-tabh-10,tabw,tabh);
		target1.linkSPContours(contours_1);
		target1.linkSPQuadTree(cselect_1);
		target1.linkCBPMedian(median1);
		target1.linkCBPOutliers(outliers1);
		target1.linkCBPBands(bands1);
		target1.setBandColors(color(136,187,136), color(187,255,187));
		target1.linkTimeControl(timer);
		target1.linkSwitch(cbp_switch);
		target1.linkSPHoverables(member_select1, (library.getMinXY()).x+125, (library.getMaxXY()).y + 45);
		target1.setLabel("CONTOURS");
		target1.setColor(c1);
		library.linkTarget(target1);
		targets.add(target1);
		
		target2 = new EnsembleTarget(cornerx+10+(2*(tabw+4)),cornery-tabh-10,tabw,tabh);
		target2.linkSPContours(contours_2);
		target2.linkSPQuadTree(cselect_2);
		target2.linkCBPMedian(median2);
		target2.linkCBPOutliers(outliers2);
		target2.linkCBPBands(bands2);
		target2.setBandColors(color(187,136,136), color(255,187,187));
		target2.linkTimeControl(timer);
		target2.linkSwitch(cbp_switch);
		target2.linkSPHoverables(member_select2, (library.getMinXY()).x+195, (library.getMaxXY()).y + 45);
		target2.setLabel("CONTOURS");
		target2.setColor(c2);
		library.linkTarget(target2);
		targets.add(target2);
		
		selectFromContour = false;
		lastHoverable = null;
	}
	
	void updateAnim(){
		super.updateAnim();
		updateHighlight();
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
		
		// if (key == 'p') println(cbp_switch.isOn());
		
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
				ctooltip = null;
				tooltipPos = null;
								
				tracker.update(targets);
				changed = true;
			}
		}
		return changed;
	}		
	
	private void updateHighlight(){
		try{
			if (highlight != null){
				switch (target_index){
					case 0:
						highlight = (member_index < contours_0.size()) ? contours_0.get(member_index) : null;
						break;
					case 1:
						highlight = (member_index < contours_1.size()) ? contours_1.get(member_index) : null;
						break;
					case 2:
						highlight = (member_index < contours_2.size()) ? contours_2.get(member_index) : null;
						break;
					default:
				}
				if ((tooltipPos != null)&&(highlight != null)){
					ctooltip.clear();
					highlight.addAllSegmentsToQuadTree(ctooltip);
					tooltipPos = ctooltip.getClosestPoint(tooltipPos.x,tooltipPos.y);
				}
			}
		}
		catch(NullPointerException e){
			e.printStackTrace(System.out);
			if (contours_0 == null) println("contours_0 is null");
			if (contours_1 == null) println("contours_1 is null");
			if (contours_2 == null) println("contours_2 is null");
			if (tooltipPos == null) println("tooltipPos is null");
			if (highlight == null) println("highlight is null -- acceptable state");
			if (ctooltip == null) println("ctooltip is null");	
			exit();		
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
			shape(map, cornerx+(38*spacing), cornery+(34*spacing), 120*spacing, 74*spacing);
		}
		
		// TODO COLOR FILL or CONDENSE ^|v (?)
		
		// draw outline
		if (map != null){
			strokeWeight(2);
			stroke(255,255,255,255);//stroke(85,46,27,255);
			noFill();
			shape(map, cornerx+(38*spacing), cornery+(34*spacing), 120*spacing, 74*spacing);
		}	
	
		if (cbp_switch.isOn())
		{
			colorMode(RGB, 255, 255, 255, 100);
			
			boolean someHovering = target2.isHovering() | target1.isHovering() | target0.isHovering();
			int a;
			
			// Target 0
			if (!target0.isHovering()){
				
				if (someHovering){ //grey out
					a = 40;
				}
				else{ //default draw
					a = 75;
				}
				
				tint(255, a);
				image(bands0, cornerx, cornery);
				noTint();
			
				colorMode(HSB, 360, 100, 100, 100);
				drawContours(outliers0, 0, 100, 100, 90, 60, a, 1);
				colorMode(RGB, 255, 255, 255, 100);
			
				strokeWeight(2);
				stroke(color(40, 40, 121, a));
				median0.drawContour();
			}
						
			if (!target1.isHovering()){
				
				if (someHovering){ //grey out
					a = 40;
				}
				else{ //default draw
					a = 75;
				}
				
				tint(255, a);
				image(bands1, cornerx, cornery);
				noTint();
			
				colorMode(HSB, 360, 100, 100, 100);
				drawContours(outliers1, 200, 100, 100, 90, 60, a, 1);
				colorMode(RGB, 255, 255, 255, 100);
			
				strokeWeight(2);
				stroke(color(32, 109, 32, a));
				median1.drawContour();
			}
			
			if (!target2.isHovering()){
				
				if (someHovering){ //grey out
					a = 40;
				}
				else{ //default draw
					a = 75;
				}
				
				tint(255, a);
				image(bands2, cornerx, cornery);
				noTint();

				colorMode(HSB, 360, 100, 100, 100);
				drawContours(outliers2, 33, 60, 40, 55, 40, a, 1);
				colorMode(RGB, 255, 255, 255, 100);

				strokeWeight(2);
				stroke(color(121, 40, 40, a));
				median2.drawContour();
			}
			
			if (someHovering){
				a = 100;
				
				if(target0.isHovering()){
					tint(255, a);
					image(bands0, cornerx, cornery);
					noTint();
			
					colorMode(HSB, 360, 100, 100, 100);
					drawContours(outliers0, 0, 100, 100, 90, 60, a, 1);
					colorMode(RGB, 255, 255, 255, 100);
			
					strokeWeight(2);
					stroke(color(40, 40, 121,a));
					median0.drawContour();
				}
				else if(target1.isHovering()){
					tint(255, a);
					image(bands1, cornerx, cornery);
					noTint();
			
					colorMode(HSB, 360, 100, 100, 100);
					drawContours(outliers1, 200, 100, 100, 90, 60, a, 1);
					colorMode(RGB, 255, 255, 255, 100);
			
					strokeWeight(2);
					stroke(color(32, 109, 32,a));
					median1.drawContour();
					
				}
				else{
					tint(255, a);
					image(bands2, cornerx, cornery);
					noTint();

					colorMode(HSB, 360, 100, 100, 100);
					drawContours(outliers2, 33, 60, 40, 55, 40, a, 1);
					colorMode(RGB, 255, 255, 255, 100);

					strokeWeight(2);
					stroke(color(121, 40, 40, a));
					median2.drawContour();	
				}
					
			}
			
			colorMode(RGB, 255);
		}
		else {
			
			boolean someHovering = target2.isHovering() | target1.isHovering() | target0.isHovering();
			int s_1, s_2, b_1, b_2, a;
			
			//draw contours
			colorMode(HSB, 360, 100, 100, 100);
			stroke(0,0,15,100);
			strokeCap(SQUARE);
			
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
				drawContours(contours_0, 239, s_1, s_2, b_1, b_2, a, 1.5);
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
				drawContours(contours_1, 119, s_1, s_2, b_1, b_2, a, 1.5);
			}
			
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
				drawContours(contours_2,   0, s_1, s_2, b_1, b_2, a, 1.5);
			}
			
			// Hover over Top
			if (someHovering){
				s_1 = 27;
				s_2 = 44;
				b_1 = 80;
				b_2 = 40;
				a = 100;
				if(target2.isHovering()) drawContours(contours_2,   0, s_1, s_2, b_1, b_2, a, 1.5);
				else if(target1.isHovering()) drawContours(contours_1, 119, s_1, s_2, b_1, b_2, a, 1.5);
				else drawContours(contours_0, 239, s_1, s_2, b_1, b_2, a, 1.5);
			}
			
			strokeCap(ROUND);
			colorMode(RGB,255);
				
		}
		
		//draw highlight in either SP or CBP mode
		colorMode(HSB, 360, 100, 100, 100);
		color hcolor; 
		switch(target_index){
			case 0:
				hcolor = color(239,50,37,100);
				break;
			case 1:
				hcolor = color(119,50,32,100);
				break;
			case 2:
				hcolor = color(0,50,32,100);
				break;
			default:
				hcolor = color(0,0);
		}
		drawHighlight(hcolor, 2.5);
		colorMode(RGB,255);
				
		// draw controls
		library.display();
		tracker.display();
		timer.display();
		cbp_switch.display();
		
		if (target0.hasSelectable()){
			// group label
			float tmpx, tmpy;
			tmpx = (library.getMinXY()).x + 55;
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
			tmpx = (library.getMinXY()).x + 125;
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
			tmpx = (library.getMinXY()).x + 195;
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
		
		//Default Label TODO add graceful error handling/message
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
		if (selectFromContour) drawToolTip();
	}
		
	protected void drawContours(ArrayList<Contour2D> contours, int h, int s_min, int s_max, int b_min, int b_max, int a, float weight){
		noFill();
		strokeWeight(weight);
	
		int n = int(contours.size());
	
		//draw all but selection
		// boolean trigger = false;
		Contour2D c;
		for (int i=0; i<n; i++){
			int s = int(map(i, 0, n-1, s_min, s_max));
			int b = int(map(i, 0, n-1, b_min, b_max));
			stroke(h,s,b,a);
			c = contours.get(i);
			if (c == highlight){
				// trigger = true;
				continue;
			} 
			c.drawContour();
		}
	}
	
	protected void drawHighlight(color select, float weight){
		if (highlight != null){
			strokeWeight(weight);
			stroke(select);
			highlight.drawContour();
		}
			
	}
	
	protected void drawToolTip(){
		if ((highlight != null)){// && trigger){		
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
		/*if (highlight != null){
			String s = highlight.getID();
			int i = highlight.getMemberCount();
			println(s + ": " + i + " segments");
		}*/
		if (cbp_switch.clicked(mx, my) || super.press(mx,my,clickCount)) return true;
		else if (highlight != null){
			ctooltip.clear();
			highlight.addAllSegmentsToQuadTree(ctooltip);
			tooltipPos = ctooltip.getClosestPoint(mx,my);
			return true;
		}
		return false;
	}
		
	protected boolean move(int mx, int my){
		if (cbp_switch.interact(mx, my) || super.move(mx,my)){
			return true;
		}
		else {
			if (cbp_switch.isOn()){
				//CBP
				return selectFromHoverables();											
			}
			else {
				return selectHighlight();
			}
		}
	}
	
	protected boolean drag(int mx, int my){
		if (cbp_switch.interact(mx, my) || super.drag(mx,my)) return true;
		else if (highlight != null){
			tooltipPos = ctooltip.getClosestPoint(mx,my);
			if (tooltipPos == null) highlight = null;
			return true;
		}		
		return false;	
		
	}
	
	protected boolean release(){
		if(cbp_switch.released()){
			if (!cbp_switch.isOn()){
				target0.cacheRenderContext();  //only caches if valid
				target1.cacheRenderContext();  //only caches if valid
				target2.cacheRenderContext();  //only caches if valid
				}
			else{
				target0.updateRenderContext();
				target1.updateRenderContext();
				target2.updateRenderContext();
			}
			return true;
		}
		else if (super.release()) return true;
		else if (tooltipPos != null){
			//end tool-tip
			tooltipPos = null;
			return true;
		}
		return false;
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
					//attempt select
					return selectFromHoverables();
				}
			}
		}
	}
	
	private boolean selectFromHoverables(){
		
		highlight = null;
		target_index = -1;
		member_index = -2;
		selectFromContour = false;
		if (lastHoverable != null){
			lastHoverable.rollover = false;
			lastHoverable = null;
		}
		
		boolean rval = false;
		
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
			
	
	void loadData(String dataDir, int run_input){
		
		String[] models = {"em", "nmb", "nmm"};
		String[] perturbations = {"ctl", "n1", "n2", "n3", "p1", "p2", "p3"};
		
		ArrayList<String> member_labels = genMemberLabels(models,perturbations);
		ArrayList< ArrayList<Field> > ensemble = getEnsemble(dataDir + "/EnsembleFields/500mb_HGT/", run_input, models, perturbations);
		boolean skipLowRes = false;//low res: if false and no cache
		boolean cacheMe = false;//if true, always uses high-res cache
		
		println("HGT"); 
		addEnsembleSelect(ensemble, member_labels, getCBP(dataDir+"/CBP/500mb_HGT/5100/", run_input, skipLowRes), cacheMe, 5100, "HGT", "500mb", "5100", 0);
		addEnsembleSelect(ensemble, member_labels, getCBP(dataDir+"/CBP/500mb_HGT/5160/", run_input, skipLowRes), cacheMe, 5160, "HGT", "500mb", "5160", 0);
		addEnsembleSelect(ensemble, member_labels, getCBP(dataDir+"/CBP/500mb_HGT/5220/", run_input, skipLowRes), cacheMe, 5220, "HGT", "500mb", "5220", 0);
		addEnsembleSelect(ensemble, member_labels, getCBP(dataDir+"/CBP/500mb_HGT/5280/", run_input, skipLowRes), cacheMe, 5280, "HGT", "500mb", "5280", 0);
		addEnsembleSelect(ensemble, member_labels, getCBP(dataDir+"/CBP/500mb_HGT/5340/", run_input, skipLowRes), cacheMe, 5340, "HGT", "500mb", "5340", 0);
		addEnsembleSelect(ensemble, member_labels, getCBP(dataDir+"/CBP/500mb_HGT/5400/", run_input, skipLowRes), cacheMe, 5400, "HGT", "500mb", "5400", 0);
		addEnsembleSelect(ensemble, member_labels, getCBP(dataDir+"/CBP/500mb_HGT/5520/", run_input, skipLowRes), cacheMe, 5520, "HGT", "500mb", "5520", 0);
		addEnsembleSelect(ensemble, member_labels, getCBP(dataDir+"/CBP/500mb_HGT/5580/", run_input, skipLowRes), cacheMe, 5580, "HGT", "500mb", "5580", 0);
		addEnsembleSelect(ensemble, member_labels, getCBP(dataDir+"/CBP/500mb_HGT/5640/", run_input, skipLowRes), cacheMe, 5640, "HGT", "500mb", "5640", 0);
		addEnsembleSelect(ensemble, member_labels, getCBP(dataDir+"/CBP/500mb_HGT/5700/", run_input, skipLowRes), cacheMe, 5700, "HGT", "500mb", "5700", 0);
		addEnsembleSelect(ensemble, member_labels, getCBP(dataDir+"/CBP/500mb_HGT/5760/", run_input, skipLowRes), cacheMe, 5760, "HGT", "500mb", "5760", 0);
		addEnsembleSelect(ensemble, member_labels, getCBP(dataDir+"/CBP/500mb_HGT/5820/", run_input, skipLowRes), cacheMe, 5820, "HGT", "500mb", "5820", 0);
		addEnsembleSelect(ensemble, member_labels, getCBP(dataDir+"/CBP/500mb_HGT/5820/", run_input, skipLowRes), cacheMe, 5820, "HGT", "500mb", "5820", 0);
		
		println("WIND");
		ensemble = getEnsemble(dataDir + "/EnsembleFields/500mb_WIND/ensemble/", run_input, models, perturbations);
		addEnsembleSelect(ensemble, member_labels, getCBP(dataDir+"/CBP/500mb_WIND/50/", run_input, skipLowRes), cacheMe, 50, "WIND", "500mb", "50", 0);
		addEnsembleSelect(ensemble, member_labels, getCBP(dataDir+"/CBP/500mb_WIND/60/", run_input, skipLowRes), cacheMe, 60, "WIND", "500mb", "60", 0);
		addEnsembleSelect(ensemble, member_labels, getCBP(dataDir+"/CBP/500mb_WIND/70/", run_input, skipLowRes), cacheMe, 70, "WIND", "500mb", "70", 0);
		
		println("TMP");
		ensemble = getEnsemble(dataDir + "/EnsembleFields/500mb_TMP/", run_input, models, perturbations);
		addEnsembleSelect(ensemble, member_labels, getCBP(dataDir+"/CBP/500mb_TMP/258_15/", run_input, skipLowRes), cacheMe, 258.15, "TMP", "500mb", "-15", 0);
		addEnsembleSelect(ensemble, member_labels, getCBP(dataDir+"/CBP/500mb_TMP/253_15/", run_input, skipLowRes), cacheMe, 253.15, "TMP", "500mb", "-20", 0);
		addEnsembleSelect(ensemble, member_labels, getCBP(dataDir+"/CBP/500mb_TMP/248_15/", run_input, skipLowRes), cacheMe, 248.15, "TMP", "500mb", "-25", 0);
		addEnsembleSelect(ensemble, member_labels, getCBP(dataDir+"/CBP/500mb_TMP/238_15/", run_input, skipLowRes), cacheMe, 238.15, "TMP", "500mb", "-35", 0);
		
		
		
		
		
		/*Field f;
		EnsembleEncoding encd;
		EnsembleSelect select;
		PVector corner = new PVector(cornerx, cornery);

		color c700mb, c500mb;
		c500mb = color(90, 54, 153);
		c700mb = color(0, 116, 162);

		String fhr;
		String dir = dataDir + "/EnsembleFields/500mb_TMP/";
		String run = String.format("%02d", run_input);
		String grid = "212";
		String[] models = {"em", "nmb", "nmm"};
		String[] perturbations = {"ctl", "n1", "n2", "n3", "p1", "p2", "p3"};

		int initCapacity = models.length*perturbations.length;
		ArrayList<String> member_labels = new ArrayList<String>(initCapacity);

		FilenameFilter outlierFilter = new FilenameFilter() {
		  public boolean accept(File dir, String name) {
		    return name.toLowerCase().contains("outlier");
		  }
		};


		ArrayList < Field > build_bands;
		ArrayList < Field > build_envelop;

		ArrayList< Integer > ordering;
		ArrayList< ArrayList<String> > outlier_filenames;

		ArrayList < Contour2D > build_median;
		ArrayList < ArrayList < Contour2D > > build_outliers;

		ContourBoxPlot cbp;

		//500mb TMP
		ArrayList< ArrayList<Field> > ensemble = new ArrayList< ArrayList<Field> >(initCapacity);

		for (int i=0; i < models.length; i++){
			for (int j=0; j < perturbations.length; j++){
				ArrayList<Field> member = new ArrayList<Field>(30);
				for (int k=0; k<=87; k+=3){
					fhr = String.format("%02d", k);
					String file = dir + "sref_"+ models[i] +".t" + run + "z.pgrb" + grid +"." + perturbations[j] + ".f" + fhr + ".txt";
					f = new Field(file, samplesx, samplesy, corner, samplesy*spacing, samplesx*spacing);
					member.add(f);
				}
				ensemble.add(member);
				member_labels.add( models[i] + " " + perturbations[j] );
			}
		}

		//CBP -- 258.15
		dir = dataDir + "/CBP/500mb_TMP/258_15/"+run+"/";

		//get ordering
		ordering = new ArrayList<Integer>(21);
		getAnalysisOrder(dir+"analysis.txt", ordering);
		if (ordering.size() != 21){
			println("ERROR getting CBP ordering data"); //TODO proper error handling
		}

		// load CBP data
		build_bands = new ArrayList<Field>();
		build_envelop = new ArrayList<Field>();

		for (int i=0; i < 30; i++){
			fhr = "f"+String.format("%02d", i*3);

			String file;
			Field tmp_src;
			Contour2D tmp_contour;

			//bands
			file = dir + "band"+"_gridRes_"+grid+"_"+fhr+".csv";
			tmp_src = new Field(file, samplesx, samplesy, corner, samplesy*spacing, samplesx*spacing);
			build_bands.add(tmp_src);

			//envelope
			file = dir + "envelop"+"_gridRes_"+grid+"_"+fhr+".csv";
			tmp_src = new Field(file, samplesx, samplesy, corner, samplesy*spacing, samplesx*spacing);
			build_envelop.add(tmp_src);

		}

		//ContourBoxPlot cbp = new ContourBoxPlot(build_median, build_bands, build_envelop, build_outliers);
		cbp = new ContourBoxPlot(build_bands, build_envelop, ordering);

			// Create Selectables
		encd = new EnsembleEncoding(ensemble, cbp);
		encd.setMemberLabels(member_labels);
		encd.setIsovalue(258.15);//-15 C
		// encd.setCachingSP(true);
		select = new EnsembleSelect(tabw,tabh,c500mb, encd, "TMP", "500mb", "258.15˚ K");
		select.setSingleCopy(true);
		library.add(select);


		//CBP -- 253.15
		dir = dataDir + "/CBP/500mb_TMP/253_15/"+run+"/";

		//get ordering
		ordering = new ArrayList<Integer>(21);
		getAnalysisOrder(dir+"analysis.txt", ordering);
		if (ordering.size() != 21){
			println("ERROR getting CBP ordering data"); //TODO proper error handling
		}

		// load CBP data
		build_bands = new ArrayList<Field>();
		build_envelop = new ArrayList<Field>();

		for (int i=0; i < 30; i++){
			fhr = "f"+String.format("%02d", i*3);

			String file;
			Field tmp_src;
			Contour2D tmp_contour;

			//bands
			file = dir + "band"+"_gridRes_"+grid+"_"+fhr+".csv";
			tmp_src = new Field(file, samplesx, samplesy, corner, samplesy*spacing, samplesx*spacing);
			build_bands.add(tmp_src);

			//envelope
			file = dir + "envelop"+"_gridRes_"+grid+"_"+fhr+".csv";
			tmp_src = new Field(file, samplesx, samplesy, corner, samplesy*spacing, samplesx*spacing);
			build_envelop.add(tmp_src);

		}

		//ContourBoxPlot cbp = new ContourBoxPlot(build_median, build_bands, build_envelop, build_outliers);
		cbp = new ContourBoxPlot(build_bands, build_envelop, ordering);

		encd = new EnsembleEncoding(ensemble, cbp);
		encd.setMemberLabels(member_labels);
		encd.setIsovalue(253.15);//-15 C
		// encd.setCachingSP(true);
		select = new EnsembleSelect(tabw,tabh,c500mb, encd, "TMP", "500mb", "253.15˚ K");
		select.setSingleCopy(true);
		library.add(select);


		// //CBP -- 253.15
		// dir = dataDir + "/CBP/500mb_TMP/253_15/"+run+"/";
		//
		// 	// initialize for variable number of outliers
		// outlier_filenames = new ArrayList< ArrayList<String> >(30);
		// for (int i=0; i < 30; i++){
		// 	ArrayList<String> list = new ArrayList<String>();
		// 	outlier_filenames.add(list);
		// }
		//
		// 	// get outlier file names
		// folder = sketchFile(dir);
		// contents = folder.list(outlierFilter);
		// if (contents != null){
		// 	for (int i = 0; i < contents.length; i++) {
		// 		String filename = contents[i];
		// 		int idx = Integer.parseInt(filename.substring(filename.length()-6,filename.length()-4))/3;
		// 		ArrayList<String> list = outlier_filenames.get(idx);
		// 		list.add(filename);
		// 	}
		// }
		// else {
		// 	println("Error: null result from list() for contents of " + dir);
		// }
		//
		// 	// load CBP data
		// build_median = new ArrayList<Contour2D>();
		// build_bands = new ArrayList<Field>();
		// build_envelop = new ArrayList<Field>();
		// 	    build_outliers = new ArrayList<ArrayList<Contour2D>>();
		//
		// for (int i=0; i < 30; i++){
		// 	fhr = "f"+String.format("%02d", i*3);
		//
		// 	String file;
		// 	Field tmp_src;
		// 	Contour2D tmp_contour;
		//
		// 	//median
		// 	file = dir + "median"+"_gridRes_"+grid+"_"+fhr+".csv";
		// 	tmp_src = new Field(file, samplesx, samplesy, corner, samplesy*spacing, samplesx*spacing);
		// 	tmp_contour = new Contour2D(2*tmp_src.dimy);
		// 	tmp_src.genIsocontour(0.5, tmp_contour);
		// 	build_median.add(tmp_contour);
		//
		// 	//bands
		// 	file = dir + "band"+"_gridRes_"+grid+"_"+fhr+".csv";
		// 	tmp_src = new Field(file, samplesx, samplesy, corner, samplesy*spacing, samplesx*spacing);
		// 	build_bands.add(tmp_src);
		//
		// 	//envelope
		// 	file = dir + "envelop"+"_gridRes_"+grid+"_"+fhr+".csv";
		// 	tmp_src = new Field(file, samplesx, samplesy, corner, samplesy*spacing, samplesx*spacing);
		// 	build_envelop.add(tmp_src);
		//
		// 	//outliers
		// 	ArrayList < Contour2D > build_outliers_fhr = new ArrayList < Contour2D >();
		// 	ArrayList<String> list = outlier_filenames.get(i);
		// 	for (String s: list){
		// 		file = dir + s;
		// 		tmp_src = new Field(file, samplesx, samplesy, corner, samplesy*spacing, samplesx*spacing);
		// 		tmp_contour = new Contour2D(2*tmp_src.dimy);
		// 		tmp_src.genIsocontour(0.5, tmp_contour);
		// 		build_outliers_fhr.add(tmp_contour);
		// 	}
		// 	build_outliers.add(build_outliers_fhr);
		//
		// }
		//
		// cbp = new ContourBoxPlot(build_median, build_bands, build_envelop, build_outliers);
		//
		// encd = new EnsembleEncoding(ensemble, cbp);
		// encd.setMemberLabels(member_labels);
		// encd.setIsovalue(253.15);//-15 C
		// // encd.setCachingSP(true);
		// select = new EnsembleSelect(tabw,tabh,c500mb, encd, "TMP", "500mb", "253.15˚ K");
		// select.setSingleCopy(true);
		// library.add(select);
		//


		//CBP -- 248.15
		dir = dataDir + "/CBP/500mb_TMP/248_15/"+run+"/";

		//get ordering
		ordering = new ArrayList<Integer>(21);
		getAnalysisOrder(dir+"analysis.txt", ordering);
		if (ordering.size() != 21){
			println("ERROR getting CBP ordering data"); //TODO proper error handling
		}

		// load CBP data
		build_bands = new ArrayList<Field>();
		build_envelop = new ArrayList<Field>();

		for (int i=0; i < 30; i++){
			fhr = "f"+String.format("%02d", i*3);

			String file;
			Field tmp_src;
			Contour2D tmp_contour;

			//bands
			file = dir + "band"+"_gridRes_"+grid+"_"+fhr+".csv";
			tmp_src = new Field(file, samplesx, samplesy, corner, samplesy*spacing, samplesx*spacing);
			build_bands.add(tmp_src);

			//envelope
			file = dir + "envelop"+"_gridRes_"+grid+"_"+fhr+".csv";
			tmp_src = new Field(file, samplesx, samplesy, corner, samplesy*spacing, samplesx*spacing);
			build_envelop.add(tmp_src);

		}

		cbp = new ContourBoxPlot(build_bands, build_envelop, ordering);

		encd = new EnsembleEncoding(ensemble, cbp);
		encd.setMemberLabels(member_labels);
		encd.setIsovalue(248.15);//-15 C
		// encd.setCachingSP(true);
		select = new EnsembleSelect(tabw,tabh,c500mb, encd, "TMP", "500mb", "248.15˚ K");
		select.setSingleCopy(true);
		library.add(select);


		//700mb TMP

		dir = dataDir + "/EnsembleFields/700mb_TMP/";
		ensemble = new ArrayList< ArrayList<Field> >(initCapacity);

		for (int i=0; i < models.length; i++){
			for (int j=0; j < perturbations.length; j++){
				ArrayList<Field> member = new ArrayList<Field>(30);
				for (int k=0; k<=87; k+=3){
					fhr = String.format("%02d", k);
					String file = dir + "sref_"+ models[i] +".t" + run + "z.pgrb" + grid +"." + perturbations[j] + ".f" + fhr + ".txt";
					f = new Field(file, samplesx, samplesy, corner, samplesy*spacing, samplesx*spacing);
					member.add(f);
				}
				ensemble.add(member);
			}
		}

		//CBP -- 283.15
		dir = dataDir + "/CBP/700mb_TMP/283_15/"+run+"/";

		//get ordering
		ordering = new ArrayList<Integer>(21);
		getAnalysisOrder(dir+"analysis.txt", ordering);
		if (ordering.size() != 21){
			println("ERROR getting CBP ordering data"); //TODO proper error handling
		}

		// load CBP data
		build_bands = new ArrayList<Field>();
		build_envelop = new ArrayList<Field>();

		for (int i=0; i < 30; i++){
			fhr = "f"+String.format("%02d", i*3);

			String file;
			Field tmp_src;
			Contour2D tmp_contour;

			//bands
			file = dir + "band"+"_gridRes_"+grid+"_"+fhr+".csv";
			tmp_src = new Field(file, samplesx, samplesy, corner, samplesy*spacing, samplesx*spacing);
			build_bands.add(tmp_src);

			//envelope
			file = dir + "envelop"+"_gridRes_"+grid+"_"+fhr+".csv";
			tmp_src = new Field(file, samplesx, samplesy, corner, samplesy*spacing, samplesx*spacing);
			build_envelop.add(tmp_src);

		}

		cbp = new ContourBoxPlot(build_bands, build_envelop, ordering);

		encd = new EnsembleEncoding(ensemble, cbp);
		encd.setMemberLabels(member_labels);
		encd.setIsovalue(283.15);//10 C
		// encd.setCachingSP(true);
		select = new EnsembleSelect(tabw,tabh,c700mb, encd, "TMP", "700mb", "283.15˚ K");
		select.setSingleCopy(true);
		library.add(select);

		//CBP -- 288.15
		dir = dataDir + "/CBP/700mb_TMP/288_15/"+run+"/";

		//get ordering
		ordering = new ArrayList<Integer>(21);
		getAnalysisOrder(dir+"analysis.txt", ordering);
		if (ordering.size() != 21){
			println("ERROR getting CBP ordering data"); //TODO proper error handling
		}

		// load CBP data
		build_bands = new ArrayList<Field>();
		build_envelop = new ArrayList<Field>();

		for (int i=0; i < 30; i++){
			fhr = "f"+String.format("%02d", i*3);

			String file;
			Field tmp_src;
			Contour2D tmp_contour;

			//bands
			file = dir + "band"+"_gridRes_"+grid+"_"+fhr+".csv";
			tmp_src = new Field(file, samplesx, samplesy, corner, samplesy*spacing, samplesx*spacing);
			build_bands.add(tmp_src);

			//envelope
			file = dir + "envelop"+"_gridRes_"+grid+"_"+fhr+".csv";
			tmp_src = new Field(file, samplesx, samplesy, corner, samplesy*spacing, samplesx*spacing);
			build_envelop.add(tmp_src);

		}

		cbp = new ContourBoxPlot(build_bands, build_envelop, ordering);

		encd = new EnsembleEncoding(ensemble, cbp);
		encd.setMemberLabels(member_labels);
		encd.setIsovalue(288.15);//15 C
		// encd.setCachingSP(true);
		select = new EnsembleSelect(tabw,tabh,c700mb, encd, "TMP", "700mb", "288.15˚ K");
		select.setSingleCopy(true);
		library.add(select);*/
				
	}
	
	
	private ArrayList< ArrayList<Field> > getEnsemble(String dir, int run_input, String[] models, String[] perturbations){
		String run = String.format("%02d", run_input);
		String grid = "212";
		PVector corner = new PVector(cornerx, cornery);
		
		ArrayList< ArrayList<Field> > ensemble = new ArrayList< ArrayList<Field> >(models.length*perturbations.length);
		for (int i=0; i < models.length; i++){
			for (int j=0; j < perturbations.length; j++){
				ArrayList<Field> member = new ArrayList<Field>(30);
				for (int k=0; k<=87; k+=3){
					String fhr = String.format("%02d", k);
					String file = dir + "sref_"+ models[i] +".t" + run + "z.pgrb" + grid +"." + perturbations[j] + ".f" + fhr + ".txt";
					Field f = new Field(file, samplesx, samplesy, corner, samplesy*spacing, samplesx*spacing);
					member.add(f);
				}
				ensemble.add(member);
			}
		}
		
		return ensemble;
	}
	
	private ContourBoxPlot getCBP(String dir, int run_input){
		String run = String.format("%02d", run_input);
		String grid = "212";
		PVector corner = new PVector(cornerx, cornery);
		
		//get ordering
		ArrayList<Integer> ordering = new ArrayList<Integer>(21);
		getAnalysisOrder(dir+"analysis.txt", ordering);
		if (ordering.size() != 21){//TODO proper error handling
			println("ERROR getting CBP ordering data"); 
		}

		// load CBP data
		ArrayList<Field> build_bands = new ArrayList<Field>();
		ArrayList<Field> build_envelop = new ArrayList<Field>();

		for (int i=0; i < 30; i++){
			String fhr = "f"+String.format("%02d", i*3);

			String file;
			Field tmp_src;

			//bands
			file = dir + "band"+"_gridRes_"+grid+"_"+fhr+".csv";
			tmp_src = new Field(file, samplesx, samplesy, corner, samplesy*spacing, samplesx*spacing);
			build_bands.add(tmp_src);

			//envelope
			file = dir + "envelop"+"_gridRes_"+grid+"_"+fhr+".csv";
			tmp_src = new Field(file, samplesx, samplesy, corner, samplesy*spacing, samplesx*spacing);
			build_envelop.add(tmp_src);
			
		}

		ContourBoxPlot cbp = new ContourBoxPlot(build_bands, build_envelop, ordering);
		return cbp;
		
	}
	
	private ContourBoxPlot getCBP(String dir, int run_input, boolean orderOnly){
		
		//get ordering
		ArrayList<Integer> ordering = new ArrayList<Integer>(21);
		getAnalysisOrder(dir+"analysis.txt", ordering);
		if (ordering.size() != 21){//TODO proper error handling
			println("ERROR getting CBP ordering data"); 
		}
		
		ContourBoxPlot cbp;
		if (orderOnly){
			cbp = new ContourBoxPlot(ordering);
		}
		else{
			String run = String.format("%02d", run_input);
			String grid = "212";
			PVector corner = new PVector(cornerx, cornery);

			// load CBP data
			ArrayList<Field> build_bands = new ArrayList<Field>();
			ArrayList<Field> build_envelop = new ArrayList<Field>();

			for (int i=0; i < 30; i++){
				String fhr = "f"+String.format("%02d", i*3);

				String file;
				Field tmp_src;

				//bands
				file = dir + "band"+"_gridRes_"+grid+"_"+fhr+".csv";
				tmp_src = new Field(file, samplesx, samplesy, corner, samplesy*spacing, samplesx*spacing);
				build_bands.add(tmp_src);

				//envelope
				file = dir + "envelop"+"_gridRes_"+grid+"_"+fhr+".csv";
				tmp_src = new Field(file, samplesx, samplesy, corner, samplesy*spacing, samplesx*spacing);
				build_envelop.add(tmp_src);
			
			}
			cbp = new ContourBoxPlot(build_bands, build_envelop, ordering);
		}
		
		return cbp;
		
	}
	
	
	private ArrayList<String> genMemberLabels(String[] models, String[] perturbations){
		ArrayList<String> member_labels = new ArrayList<String>(models.length*perturbations.length);
		for (int i=0; i < models.length; i++){
			for (int j=0; j < perturbations.length; j++){
				member_labels.add( models[i] + " " + perturbations[j] );
			}
		}
		return member_labels;
	}
	
	private void addEnsembleSelect(ArrayList< ArrayList<Field> > ensemble, ArrayList<String> member_labels, ContourBoxPlot cbp, float iso, String vlabel, String hlabel, String dlabel, int libIndex){
		EnsembleEncoding encd = new EnsembleEncoding(ensemble, cbp);
		encd.setMemberLabels(member_labels);
		encd.setIsovalue(iso);//15 C
		/*encd.cacheCBPbands(int(samplesx*spacing), int(samplesy*spacing));*/
		// encd.setCachingSP(true);
		EnsembleSelect select = new EnsembleSelect(tabw,tabh, encd, vlabel, hlabel, dlabel);
		select.setSingleCopy(true);
		library.add(select, libIndex);
	}
	
	private void addEnsembleSelect(ArrayList< ArrayList<Field> > ensemble, ArrayList<String> member_labels, ContourBoxPlot cbp, boolean cache, float iso, String vlabel, String hlabel, String dlabel, int libIndex){
		EnsembleEncoding encd = new EnsembleEncoding(ensemble, cbp);
		encd.setMemberLabels(member_labels);
		encd.setIsovalue(iso);//15 C
		if (cache){
			encd.cacheCBPbands(int(samplesx*spacing), int(samplesy*spacing));
			// encd.setCachingSP(true);
		}
		EnsembleSelect select = new EnsembleSelect(tabw,tabh, encd, vlabel, hlabel, dlabel);
		select.setSingleCopy(true);
		library.add(select, libIndex);
	}
	
	
	private void getAnalysisOrder(String filename, ArrayList<Integer> ordering){
	    String[] lines;	
		try{
			lines = loadStrings(filename);
		    for(String line: lines)
		    {
			  String[] tokens = line.split("\\t");
		      int idx = int(tokens[1]);
			  ordering.add(idx);
		    }
		}
		catch(Exception e){
			println("ERROR reading ordering from " + filename);
		}
	}

}