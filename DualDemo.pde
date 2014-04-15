PFont plotFont;
PShape map;
BarbGlyphList glyphs;
StatView view_0;
MNSDView view_1;

TextButton modeSwap;
boolean mode = true;

// int samplesx, samplesy, spacing;
// int cornerx, cornery;
// int tabw, tabh;

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
	
	view_0 = new StatView(samplesx, samplesy, spacing, cornerx, cornery, tabw, tabh, 32);
	view_0.setMap(map);
	view_0.linkGlyphs(glyphs);
	view_0.loadData();
	
	view_1 = new MNSDView(samplesx, samplesy, spacing, cornerx, cornery, tabw, tabh, 12);
	view_1.setMap(map);
	view_1.loadData();
	
	modeSwap = new TextButton(cornerx + 20, height - 20, "SWAP");
}

void draw(){
  	background(230);
	
	if (mode) view_0.draw();
	else view_1.draw();
	
	modeSwap.display();
}


void mousePressed(){	
	if (mode) view_0.mousePress(mouseX, mouseY);
	else view_1.mousePress(mouseX, mouseY);
	
	if (modeSwap.clicked(mouseX, mouseY)){
		mode = !mode;
	}
}

void mouseMoved(){
	if (mode) view_0.mouseMove(mouseX, mouseY);
	else view_1.mouseMove(mouseX, mouseY);
	
	modeSwap.interact(mouseX, mouseY);
}

void mouseDragged(){
	if (mode) view_0.mouseDrag(mouseX, mouseY);
	else view_1.mouseDrag(mouseX, mouseY);
	
	modeSwap.interact(mouseX, mouseY);
}

void mouseReleased() {
	if (mode) view_0.mouseRelease();
	else view_1.mouseRelease();
	
	modeSwap.released();
}

// class HardcodedDataLoad implements Runnable{
// 	public void run() {
// 		loadData();
// 	}
// 	
// 	void loadData(){				
// 	}	
// }