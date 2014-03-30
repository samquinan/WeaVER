class DropTarget extends Container {
	PImage layer0;//Separate into seperate subclasses
	Legend legend;
	ArrayList<Contour2D> layer1;
	QuadTree_Node<Segment2D> qtree;
	TimeControl timer;
	String label;
	
	DropTarget(float ix, float iy, float dx, float dy) {
		super(ix, iy, dx, dy, 1, 1);
		
		layer0 = null;
		layer1 = null;
		legend = null;
		qtree = null;
		label = "";
	}
	
	void setLabel(String s){
		label = s;
	}
	
	void linkImage(PImage img){
		layer0 = img;
	}
	
	void linkContours(ArrayList<Contour2D> contours){ 
		layer1 = contours;
	}
	
	void linkQuadTree(QuadTree_Node<Segment2D> q){
		qtree = q;
	}
	
	void linkLegend(Legend l){ 
		legend = l;
	}
	
	void linkTimeControl(TimeControl t){
		timer = t;
	}
	
  	void display() {
		textSize(8);
		textAlign(LEFT, BOTTOM);
		fill(70);
		text(label,x+2,y-1);
		super.display();
		// noStroke();
		// if (highlight){
		// 	strokeWeight(2);
		// 	stroke(110,110,140);
		// }
		// fill(170);
		// rect(x-1,y-1,w+2,h+2);
		// 
		// for (Selectable s: entries){ // display everything except current interacting
		// 	if (s != interacting) s.display();
		// }
   	}
	
	void remove(Selectable s){
		super.remove(s);
		updateRenderContext();	
	}
	
	void updateRenderContext(){ //defaults to cached update
		int n = entries.size();
		switch(n){
			case 0:
				clearRenderContext();
				break;
			case 1:
			default:
				noCacheUpdate();
				cacheCurrent();
				break;
		}
	}
	
	void updateRenderContext(boolean cache){
		int n = entries.size();
		switch(n){
			case 0:
				clearRenderContext();
				break;
			case 1:
			default:
				noCacheUpdate();
				if (cache) cacheCurrent();
				break;
		}
	}
	
	void cacheRenderContext(){
		int n = entries.size();
		switch(n){
			case 0:
				break;
			case 1:
			default:
				cacheCurrent();
				break;
		}
	}
	
	private void clearRenderContext(){
		if (layer0 != null){
			//clear image
			layer0.loadPixels();
			int dim = layer0.width * layer0.height;
			for (int i=0; i < dim; i++){
				layer0.pixels[i] = color(0,0,0,0);
			}
			layer0.updatePixels();
		}
		if (legend != null) legend.setColorMap(null);
		if (layer1 != null) layer1.clear();
		if (qtree != null) qtree.clear();
	}
		
	private void noCacheUpdate(){
		int fhr = timer.getIndex();
		//fill
		if (layer0 != null){
			Selectable s = entries.get(0);
			s.genFill(layer0, fhr);
		//legend
			if (s instanceof StatSelect && legend != null){
				legend.setColorMap(((StatSelect) s).getColorMap());
			}
		}
		//contours
		if (layer1 != null){
			layer1.clear();
			(entries.get(0)).genContours(layer1, fhr);
			//quadtree
			if (qtree != null){
				qtree.clear();
			}
		}
	}
	
	private void cacheCurrent(){
		//contours
		if (layer1 != null){
			//quadtree
			if (qtree != null){
				qtree.clear();
				for (Contour2D c: layer1){
					c.addAllSegmentsToQuadTree(qtree);
				}
			}
			//cache contours
			for (Contour2D c: layer1){
				c.genPShape();
			}
		}
	}
	
	
	
		
}
