import java.io.FilenameFilter;

class EnsembleView extends View {
	
	private boolean demo_min = false; // if true, only loads 4 ensembles of features
	private boolean cacheMe = true; // setting false offloads countour boxplot band /envelope generation to the display loop -- shorter load time, but less responsive
	
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
		library.addCollection(3,2);
		library.addCollection(3,1);
		/*library.addCollection(3,1);*/
		
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
			boolean dimForMember = lastHoverable != null && member_index > -1 && !selectFromContour;
			boolean someHovering = target2.isHovering() | target1.isHovering() | target0.isHovering() | dimForMember;
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
				else if(target2.isHovering()){
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
			boolean dimForMember = lastHoverable != null && member_index > -1 && !selectFromContour;
			boolean someHovering = target2.isHovering() | target1.isHovering() | target0.isHovering() | dimForMember;
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
				else if(target0.isHovering()) drawContours(contours_0, 239, s_1, s_2, b_1, b_2, a, 1.5);
			}
			
			strokeCap(ROUND);
			colorMode(RGB,255);
				
		}
		
		//draw highlight in either SP or CBP mode
		colorMode(HSB, 360, 100, 100, 100);
		drawHighlight( color(239,50,42,100), color(119,50,32,100), color(0,50,42,100), 2.5, target_index);
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
				h.rollover = (((selectFromContour && target_index == 0) || lastHoverable != null) && i == member_index);
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
				h.rollover = (((selectFromContour && target_index == 1) || lastHoverable != null) && i == member_index);
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
				h.rollover = (((selectFromContour && target_index == 2) || lastHoverable != null) && i == member_index);
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
	
	protected void drawHighlight(color select0, color select1, color select2, float weight, int target){
		
		strokeWeight(weight);
		// draw all except actual highlight if comes from hoverables
		Contour2D h_tmp;
		if (lastHoverable != null && member_index > -1 && !selectFromContour){
			if (target != 0 && target0.hasSelectable()){
				h_tmp = contours_0.get(member_index);
				if (h_tmp != null){
					stroke(select0);
					h_tmp.drawContour();	
				}
			} 
				
			if (target != 1 && target1.hasSelectable()){
				h_tmp = contours_1.get(member_index);
				if (h_tmp != null){
					stroke(select1);
					h_tmp.drawContour();	
				}
			} 
			
			if (target != 2 && target2.hasSelectable()){
				h_tmp = contours_2.get(member_index);
				if (h_tmp != null){
					stroke(select2);
					h_tmp.drawContour();	
				}
			} 
		}
		
		//draw actual highlight always		
		color tmp;
		switch(target){
			case 0:
				tmp = select0;
				break;
			case 1:
				tmp = select1;
				break;
			case 2:
				tmp = select2;
				break;
			default:
				tmp = color(0,0);
		}
		
		if (highlight != null){
			stroke(tmp);
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
			return selectHighlight();
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
		Segment2D selection = cselect_2.select(mouseX, mouseY, 2);			
		if (selection != null){
			highlight = selection.getSrcContour();
			target_index = 2;
			member_index = contours_2.indexOf(highlight);
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
				selection = cselect_0.select(mouseX, mouseY, 2);
				if (selection != null){
					highlight = selection.getSrcContour();
					target_index = 0;
					member_index = contours_0.indexOf(highlight);
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
		
		// OLD SREF
		// String[] models = {"em", "nmb", "nmm"};
		// String[] perturbations = {"ctl", "n1", "n2", "n3", "p1", "p2", "p3"};
		
		String[] models = {"arw", "nmb"};
		String[] perturbations = {"ctl", "n1", "n2", "n3", "n4", "n5", "n6", "p1", "p2", "p3", "p4", "p5", "p6"};
		
		ArrayList<String> member_labels = genMemberLabels(models,perturbations);
		
		
		// 500 mb HGT
		loadDetails = "ensemble 500mb HGT";
		ArrayList< ArrayList<Field> > ensemble = getEnsemble(dataDir + "/EnsembleFields/500mb_HGT/", run_input, models, perturbations);
		boolean skipLowRes = true;// DEPRECATED -- pre-processed low-res not currently generated by data processing routines
		// boolean cacheMe = true;//setting false offloads countour boxplot envelope generation to the display loop -- shorter load time, but less responsive
		if (!demo_min){ // full demo
			loadDetails = "generating 500mb HGT contour boxplot at 5400";
			addEnsembleSelect(ensemble, member_labels, getCBP(dataDir+"/CBP/500mb_HGT/5400/", run_input, skipLowRes), cacheMe, 5400, "HGT", "500mb", "5400", 0); // 1
			loadDetails = "generating 500mb HGT contour boxplot at 5580";
			addEnsembleSelect(ensemble, member_labels, getCBP(dataDir+"/CBP/500mb_HGT/5580/", run_input, skipLowRes), cacheMe, 5580, "HGT", "500mb", "5580", 0); // 2
			loadDetails = "generating 500mb HGT contour boxplot at 5700";
			addEnsembleSelect(ensemble, member_labels, getCBP(dataDir+"/CBP/500mb_HGT/5700/", run_input, skipLowRes), cacheMe, 5700, "HGT", "500mb", "5700", 0); // 3
			loadDetails = "generating 500mb HGT contour boxplot at 5820";
			addEnsembleSelect(ensemble, member_labels, getCBP(dataDir+"/CBP/500mb_HGT/5820/", run_input, skipLowRes), cacheMe, 5820, "HGT", "500mb", "5820", 0);		
		}
		else {
			loadDetails = "generating 500mb HGT contour boxplot at 5700";
			addEnsembleSelect(ensemble, member_labels, getCBP(dataDir+"/CBP/500mb_HGT/5700/", run_input, skipLowRes), cacheMe, 5700, "HGT", "500mb", "5700", 0); // 3
		}
				
		// 10m WIND
		loadDetails = "ensemble 10m Wind Speed";
		ensemble = getEnsemble(dataDir + "/EnsembleFields/10m_Wind/", run_input, models, perturbations);
		loadDetails = "generating 10m Wind Speed contour boxplot at 18 kts";
		addEnsembleSelect(ensemble, member_labels, getCBP(dataDir+"/CBP/10m_WSPD/18kts/", run_input, skipLowRes), cacheMe, 18, "WSPD", "10m", "18kts", 1);
		
		// 2m TMP
		loadDetails = "ensemble 2m TMP";
		ensemble = getEnsemble(dataDir + "/EnsembleFields/2m_TMP/", run_input, models, perturbations);
		if (!demo_min){	 // only load on full demo	
			loadDetails = "generating 2m TMP contour boxplot at 32F";
			addEnsembleSelect(ensemble, member_labels, getCBP(dataDir+"/CBP/2m_TMP/32F/", run_input, skipLowRes), cacheMe, 273.15, "TMP", "2m", "32F", 1);
		}
		loadDetails = "generating 2m TMP contour boxplot at 60F";
		addEnsembleSelect(ensemble, member_labels, getCBP(dataDir+"/CBP/2m_TMP/60F/", run_input, skipLowRes), cacheMe, 288.706, "TMP", "2m", "60F", 1); //4
		
		// 2m RH
		loadDetails = "ensemble 2m RH";
		ensemble = getEnsemble(dataDir + "/EnsembleFields/2m_RH/", run_input, models, perturbations);
		if (!demo_min){ // only load on full demo
			loadDetails = "generating 2m RH contour boxplot at 10%";
			addEnsembleSelect(ensemble, member_labels, getCBP(dataDir+"/CBP/2m_RH/10/", run_input, skipLowRes), cacheMe, 10, "RH", "2m", "10%", 1);
			loadDetails = "generating 2m RH contour boxplot at 20%";
			addEnsembleSelect(ensemble, member_labels, getCBP(dataDir+"/CBP/2m_RH/20/", run_input, skipLowRes), cacheMe, 20, "RH", "2m", "20%", 1); //5		
		}
		loadDetails = "generating 2m RH contour boxplot at 30%";
		addEnsembleSelect(ensemble, member_labels, getCBP(dataDir+"/CBP/2m_RH/30/", run_input, skipLowRes), cacheMe, 30, "RH", "2m", "30%", 1);
		
		// Haines				
		if (!demo_min){ // only load on full demo	
			loadDetails = "ensemble Haines (High)";
			ensemble = getEnsemble(dataDir + "/EnsembleFields/Haines/High/", run_input, models, perturbations);
			loadDetails = "generating Haines (High) contour boxplot at 5";
			addEnsembleSelect(ensemble, member_labels, getCBP(dataDir+"/CBP/Haines/High/5/", run_input, skipLowRes), cacheMe, 4.5, "Haines", "High", "5", 2);	
		}			
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
		ArrayList<Integer> ordering = new ArrayList<Integer>(26);//old 21
		getAnalysisOrder(dir+"analysis.txt", ordering);
		if (ordering.size() != 26){//TODO proper error handling //old 21
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
		ArrayList<Integer> ordering = new ArrayList<Integer>(26);//old 21
		getAnalysisOrder(dir+"analysis.txt", ordering);
		if (ordering.size() != 26){//TODO proper error handling //old 21
			println("ERROR getting CBP ordering data"); 
		}
		
		ContourBoxPlot cbp;
		if (orderOnly){
			cbp = new ContourBoxPlot(ordering);
		}
		else{
			/*println("loading low res");*/
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
			encd.setCachingSP(true);
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