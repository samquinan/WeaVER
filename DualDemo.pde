PFont plotFont;
PShape map;
BarbGlyphList glyphs;
StatView view_0;

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
}

void draw(){
  	background(230);	
	view_0.draw();
}


void mousePressed(){
	view_0.mousePress(mouseX, mouseY);
}

void mouseMoved(){
	view_0.mouseMove(mouseX, mouseY);
}

void mouseDragged(){
	view_0.mouseDrag(mouseX, mouseY);
}

void mouseReleased() {
	view_0.mouseRelease();
}

// class HardcodedDataLoad implements Runnable{
// 	public void run() {
// 		loadData();
// 	}
// 	
// 	void loadData(){				
// 	}	
// }