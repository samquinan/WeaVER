import java.util.Iterator;
import java.util.Set;
import java.util.List;
import java.util.HashSet;
import java.util.Arrays;
import java.lang.StringBuilder;
import java.util.BitSet;
import java.text.DecimalFormat;

PFont plotFont;
PFont errFont;

MenuBar menu;
int mode;

DtrmView view_0;
StatView view_1;
MNSDView view_2;
EnsembleView view_3;
ProbabilityView view_4;

LoadAnimation spinner;

Thread loadThread;
ViewLoader loader;
boolean populated, triggered;

DatasetProperties prop_d;

private int mHeight;

void setup() {
  	/*size(displayWidth, displayHeight, P2D);*/
	smooth(8);
	
	prop_d = new DatasetProperties("../dataset.properties");
	
	// specify font
  	plotFont = createFont("Charter", 12);
	errFont = createFont("Charter-Bold", 14);
  	textFont(plotFont);
  	
	// menu bar
	mHeight = 14;
	menu = new MenuBar(0,0,width,mHeight);
	mode = menu.getMode();
	
	//spinner	
	spinner = new LoadAnimation(new PVector(width/2,height/2), 50.0, radians(120)/1000.0, 37);
	spinner.switchState();//on
	
	//load views in seperate thread
	populated = false;
	triggered = false;
	loader = new ViewLoader();
	loader.setFonts(plotFont, errFont);
	loadThread = new Thread(loader);
	loadThread.start();
	
}

public int sketchWidth() {
  return displayWidth;//1315;//displayWidth;
}

public int sketchHeight() {
  return displayHeight;//800;//displayHeight;
}

public String sketchRenderer() {
  return P2D; 
}

void draw(){
  	background(230);
	
	menu.display();
	noStroke();
	noFill();
	
	if (!populated){
		if (!triggered && loader.isComplete()){
			spinner.switchState();//off
			triggered = true;
		}
		if (spinner.isOff()) populate();	
	} 
	
	//display spinner
	spinner.update();
	spinner.display();
	
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
		case 4:
			view_4.draw();
			break;
		default:
	}
	
}

private void populate(){
	// pull in loaded views
	view_0 = loader.getDtrmView();
	view_1 = loader.getStatView();
	view_2 = loader.getMNSDView();
	view_3 = loader.getEnsembleView();
	view_4 = loader.getProbabilityView();
	
	menu.addItem("Deterministic");
	menu.addItem("Stat Field");
	menu.addItem("MNSD");
	menu.addItem("Direct Ensemble");
	menu.addItem("Probability");
	mode = menu.getMode();
	
	populated = true;
}

void mousePressed(){
	if (menu.clicked(mouseX, mouseY)) return;
	
	switch (mode){
		case 0:
			view_0.mousePress(mouseX, mouseY, mouseEvent.getClickCount());
			break;
		case 1:
			view_1.mousePress(mouseX, mouseY, mouseEvent.getClickCount());
			break;
		case 2:
			view_2.mousePress(mouseX, mouseY, mouseEvent.getClickCount());
			break;
		case 3:
			view_3.mousePress(mouseX, mouseY, mouseEvent.getClickCount());
			break;
		case 4:
			view_4.mousePress(mouseX, mouseY, mouseEvent.getClickCount());
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
		case 4:
			view_4.mouseMove(mouseX, mouseY);
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
		case 4:
			view_4.mouseDrag(mouseX, mouseY);
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
				case 4:
					view_4.haltAnim();
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
		case 4:
			view_4.mouseRelease();
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
		case 4:
			view_4.keyPress(key, keyCode);
			break;
		default:
	}
}


class ViewLoader implements Runnable{
	
	private PFont regular;
	private PFont error;
	
	private DtrmView view_0;
	private StatView view_1;
	private MNSDView view_2;
	private EnsembleView view_3;
	private ProbabilityView view_4;
	private boolean finished;
	
	public ViewLoader(){
		regular = null;
		error = null;
		view_0 = null;
		view_1 = null;
		view_2 = null;
		view_3 = null;
		view_4 = null;
		finished = false;
	}
	
	public void setFonts(PFont r, PFont e){
		regular = r;
		error = e;
	}
	
	
	public boolean isComplete(){
		return finished;
	}
	
	public DtrmView getDtrmView(){
		return view_0;
	}

	public StatView getStatView(){
		return view_1;
	}

	public MNSDView getMNSDView(){
		return view_2;
	}

	public EnsembleView getEnsembleView(){
		return view_3;
	}

	public ProbabilityView getProbabilityView(){
		return view_4;
	}
	
	public void run() {
		load();
	}
	
	private void load(){
		// generate barb glyphs
		BarbGlyphList glyphs = new BarbGlyphList();
	
	    // load map
	    PShape map = loadShape("roughUS.svg");
		map.disableStyle();
	
	    int samplesx = 185;
	    int samplesy = 129;
		
		int tabw = 90;
		int tabh = 22;
		
		int addY = 60 + tabh; //TODO  smarter solution than manual analysis of view controls
		int addX = 100 + 3*tabw; //TODO  smarter solution than manual analysis of view controls
		
	    int spacing = min(floor((sketchHeight()-mHeight-addY)/samplesy), floor((sketchWidth()-addX)/samplesx));
		int cornerx = 55 + (sketchWidth() - (samplesx*spacing + addX))/2;
		int cornery = mHeight + tabh + 26 + (sketchHeight()-mHeight - (samplesy*spacing + addY))/2;
		
	    /*int spacing =  5;
		int cornerx = 60;
		int cornery = 80;*/
		
		//TODO place into data structure with colormaps, projection, other user defined preferences from config file
		//		-- Need to determine what prefs we want to give users
		//TODO PROPER PROJECTION (!)
		String dir = "../datasets";
		int run = prop_d.getRun();
		String date_string = prop_d.getDate();
	 	DateTime cur_dt = (!date_string.isEmpty()) ? new DateTime(date_string, run) : null;
		
		// generate view_0
		view_0 = new DtrmView(samplesx, samplesy, spacing, cornerx, cornery, tabw, tabh, 3);
		view_0.setFonts(regular, error);
		view_0.setMap(map);
		view_0.setDateTimeOrigin(cur_dt);
		view_0.linkGlyphs(glyphs);
		view_0.loadData(dir, run);

		// generate view_1
		view_1 = new StatView(samplesx, samplesy, spacing, cornerx, cornery, tabw, tabh, 9);
		view_1.setFonts(regular, error);
		view_1.setMap(map);
		view_1.setDateTimeOrigin(cur_dt);
		view_1.linkGlyphs(glyphs);
		view_1.loadData(dir, run);

		// generate view_2
		view_2 = new MNSDView(samplesx, samplesy, spacing, cornerx, cornery, tabw, tabh, 3);
		view_2.setFonts(regular, error);
		view_2.setMap(map);
		view_2.setDateTimeOrigin(cur_dt);
		view_2.loadData(dir, run);

		// generate view_3
		view_3 = new EnsembleView(samplesx, samplesy, spacing, cornerx, cornery, tabw, tabh, 3);//12
		view_3.setFonts(regular, error);
		view_3.setMap(map);
		view_3.setDateTimeOrigin(cur_dt);
		long startTime = System.currentTimeMillis();
		view_3.loadData(dir, run);
		long endTime = System.currentTimeMillis();
		println("load: " + ((endTime-startTime)/1000.0) + " seconds");

		// generate view_4
		view_4 = new ProbabilityView(samplesx, samplesy, spacing, cornerx, cornery, tabw, tabh, 6);
		view_4.setFonts(regular, error);
		view_4.setMap(map);
		view_4.setDateTimeOrigin(cur_dt);
		view_4.loadData(dir, run);
		
		finished = true;				
	}	
}