PFont plotFont;
PShape map;
BarbGlyphList glyphs;

MenuBar menu;
int mode;

StatView view_1;
MNSDView view_2;

LoadAnimation spinner;

void setup() {
  	size(1225, 815, P2D);
	smooth(8);
	
	// specify font
  	plotFont = createFont("Georgia", 12);
  	textFont(plotFont);
  	
	// generate barb glyphs
	glyphs = new BarbGlyphList();
	
    // load map
    map = loadShape("roughUS.svg");
	map.disableStyle();
	
	// generate view_0
    int spacing = 5;
    int samplesx = 185;
    int samplesy = 129;
	
	int cornerx = 60;
	int cornery = 80;
	int tabw = 90;
	int tabh = 22;
	
	menu = new MenuBar(0,0,width,12);
	menu.addItem("Deterministic");
	menu.addItem("Stat Field");
	menu.addItem("MNSD");
	menu.addItem("Probability");
	menu.addItem("Direct Ensemble");
	
	mode = menu.getMode();
	
	view_1 = new StatView(samplesx, samplesy, spacing, cornerx, cornery, tabw, tabh, 32);
	view_1.setMap(map);
	view_1.linkGlyphs(glyphs);
	view_1.loadData();
	
	view_2 = new MNSDView(samplesx, samplesy, spacing, cornerx, cornery, tabw, tabh, 12);
	view_2.setMap(map);
	view_2.loadData();
	
	spinner = new LoadAnimation(new PVector(width/2,height/2), 25.0, radians(120)/1000.0, 37);
	spinner.switchState();
	
}

void draw(){
  	background(230);
	
	menu.display();	
	
	switch (mode){
		case 1:
			view_1.draw();
			break;
		case 2:
			view_2.draw();
			break;
		default:
			spinner.update();
			spinner.display();
	}
}


void mousePressed(){
	if (menu.clicked(mouseX, mouseY)) return;
	
	switch (mode){	
		case 1:
			view_1.mousePress(mouseX, mouseY); 
			break;
		case 2:
			view_2.mousePress(mouseX, mouseY); 
			break;
		default:
	}
	
}

void mouseMoved(){
	if (menu.interact(mouseX, mouseY)) return;
	
	switch (mode){	
		case 1:
			view_1.mouseMove(mouseX, mouseY); 
			break;
		case 2:
			view_2.mouseMove(mouseX, mouseY); 
			break;
		default:
	}
		
}

void mouseDragged(){
	if (menu.interact(mouseX, mouseY)) return;
	
	switch (mode){	
		case 1:
			view_1.mouseDrag(mouseX, mouseY); 
			break;
		case 2:
			view_2.mouseDrag(mouseX, mouseY); 
			break;
		default:
	}
		
}

void mouseReleased() {
	if(menu.released()){
		mode = menu.getMode();
		return;
	}
	
	switch (mode){	
		case 1:
			view_1.mouseRelease(); 
			break;
		case 2:
			view_2.mouseRelease(); 
			break;
		default:
	}
}

// class HardcodedDataLoad implements Runnable{
// 	public void run() {
// 		loadData();
// 	}
// 	
// 	void loadData(){				
// 	}	
// }