PFont plotFont;

MenuBar menu;
int mode;

DtrmView view_0;
StatView view_1;
MNSDView view_2;
EnsembleView view_3;

LoadAnimation spinner;

void setup() {
  	size(1225, 815, P2D);
	smooth(8);
	
	// specify font
  	plotFont = createFont("Georgia", 12);
  	textFont(plotFont);
  	
	// generate barb glyphs
	BarbGlyphList glyphs = new BarbGlyphList();
	
    // load map
    PShape map = loadShape("roughUS.svg");
	map.disableStyle();
	
	// generate view_0
    int spacing =    5;
    int samplesx = 185;
    int samplesy = 129;
	
	int cornerx = 60;
	int cornery = 80;
	int tabw = 90;
	int tabh = 22;
	
	menu = new MenuBar(0,0,width,12);
	mode = menu.getMode();
	
	view_0 = new DtrmView(samplesx, samplesy, spacing, cornerx, cornery, tabw, tabh, 32);
	view_0.setMap(map);
	view_0.linkGlyphs(glyphs);
	view_0.loadData();
	
	view_1 = new StatView(samplesx, samplesy, spacing, cornerx, cornery, tabw, tabh, 32);
	view_1.setMap(map);
	view_1.linkGlyphs(glyphs);
	view_1.loadData();
	
	view_2 = new MNSDView(samplesx, samplesy, spacing, cornerx, cornery, tabw, tabh, 12);
	view_2.setMap(map);
	view_2.loadData();
	
	view_3 = new EnsembleView(samplesx, samplesy, spacing, cornerx, cornery, tabw, tabh, 12);
	view_3.setMap(map);
	view_3.loadData();
	
	spinner = new LoadAnimation(new PVector(width/2,height/2), 25.0, radians(120)/1000.0, 37);
	spinner.switchState();
	
	menu.addItem("Deterministic");
	menu.addItem("Stat Field");
	menu.addItem("MNSD");
	menu.addItem("Direct Ensemble");
	// menu.addItem("Probability");
	mode = menu.getMode();	
}

void draw(){
  	background(230);
	
	menu.display();	
	
	switch (mode){
		case 0:
			view_0.draw();
			break;
		case 1:
			view_1.draw();
			break;
		case 2:
			view_2.draw();
			break;
		case 3:
			view_3.draw();
			break;
		default:
			spinner.update();
			spinner.display();
	}
}


void mousePressed(){
	if (menu.clicked(mouseX, mouseY)) return;
	
	switch (mode){
		case 0:
			view_0.mousePress(mouseX, mouseY); 
			break;
		case 1:
			view_1.mousePress(mouseX, mouseY); 
			break;
		case 2:
			view_2.mousePress(mouseX, mouseY); 
			break;
		case 3:
			view_3.mousePress(mouseX, mouseY); 
			break;		
		default:
	}
	
}

void mouseMoved(){
	if (menu.interact(mouseX, mouseY)) return;
	
	switch (mode){
		case 0:
			view_0.mouseMove(mouseX, mouseY); 
			break;	
		case 1:
			view_1.mouseMove(mouseX, mouseY); 
			break;
		case 2:
			view_2.mouseMove(mouseX, mouseY); 
			break;
		case 3:
			view_3.mouseMove(mouseX, mouseY); 
			break;
		default:
	}
		
}

void mouseDragged(){
	if (menu.interact(mouseX, mouseY)) return;
	
	switch (mode){
		case 0:
			view_0.mouseDrag(mouseX, mouseY); 
			break;	
		case 1:
			view_1.mouseDrag(mouseX, mouseY); 
			break;
		case 2:
			view_2.mouseDrag(mouseX, mouseY); 
			break;
		case 3:
			view_3.mouseDrag(mouseX, mouseY); 
			break;
		default:
	}
		
}

void mouseReleased() {
	if(menu.released()){
		//halt current if animating
		int cur = menu.getMode();
		if (cur != mode){
			switch (mode){
				case 0:
					view_0.haltAnim(); 
					break;	
				case 1:
					view_1.haltAnim(); 
					break;
				case 2:
					view_2.haltAnim(); 
					break;
				case 3:
					view_3.haltAnim(); 
					break;				
				default:
			}
			//swap
			mode = cur;
		}
		return;
	}
	
	switch (mode){
		case 0:
			view_0.mouseRelease(); 
			break;	
		case 1:
			view_1.mouseRelease(); 
			break;
		case 2:
			view_2.mouseRelease(); 
			break;
		case 3:
			view_3.mouseRelease(); 
			break;
		default:
	}
}

void keyPressed() {
	switch (mode){
		case 0:
			view_0.keyPress(key, keyCode); 
			break;	
		case 1:
			view_1.keyPress(key, keyCode); 
			break;
		case 2:
			view_2.keyPress(key, keyCode); 
			break;
		case 3:
			view_3.keyPress(key, keyCode); 
			break;
		default:
	}
}


// class LoadViews implements Runnable{
// 	
// 	DtrmView view_0;
// 	StatView view_1;
// 	MNSDView view_2;
// 	EnsembleView view_3;
// 	
// 	boolean finished;
// 	
// 	LoadViews(){
// 		view_0 = null;
// 		view_1 = null;
// 		view_2 = null;
// 		view_3 = null;
// 		finished = false;
// 	}
// 	
// 	
// 	public void run() {
// 		load();
// 	}
// 	
// 	void load(){
// 						
// 	}	
// }