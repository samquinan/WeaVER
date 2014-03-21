class Segment2D implements QuadTreeElement {
  public PVector p0, p1;
  private Contour2D parent;
  
  Segment2D(PVector a, PVector b){
    p0 = a;
    p1 = b;
    parent = null;
  }
  
  boolean hasSrcContour(){
    return parent != null;
  }
  
  void setSrcContour(Contour2D c){
    parent = c;
  }
  
  Contour2D getSrcContour(){
    return parent;
  }
  
  void drawSegment(){
    line(p0.x, p0.y, p1.x, p1.y);
  }
  
  void makeVetexCalls(){
    vertex(p0.x, p0.y);
	vertex(p1.x, p1.y);
  }
  
  void makeVetexCalls(PShape s){
	 s.vertex(p0.x, p0.y);
	 s.vertex(p1.x, p1.y);
  } 
  
  boolean intersectsAABB(float minx, float miny, float maxx, float maxy){
    //handle degenerate case p1 = p0
    if (p1.x == p0.x && p1.y == p0.y) //TODO switch to epsilon test?
    {
      if (p0.x > minx && p0.y > miny && p0.x < maxx && p0.y < maxy) return true;
    }
    
    // test for no interesction on 3 possible seperating axes: x, y, and the line perpendicular to p1-p0
    if (max(p0.x,p1.x) <= minx || min(p0.x,p1.x) >= maxx) return false;
    if (max(p0.y,p1.y) <= miny || min(p0.y,p1.y) >= maxy) return false;
    
    // zero centered line perpendicular to p1-p0 -- TODO more efficient calculation?
    PVector O = new PVector(p0.y - p1.y, p1.x - p0.x);
    O.normalize();
    float projO, maxO, minO;
    
    projO =  minx*O.x + miny*O.y; 
    maxO = projO;
    minO = projO;
    
    projO =  maxx*O.x + miny*O.y; 
    maxO = max(maxO, projO);
    minO = min(minO, projO);
    
    projO =  minx*O.x + maxy*O.y; 
    maxO = max(maxO, projO);
    minO = min(minO, projO);
    
    projO =  maxx*O.x + maxy*O.y; 
    maxO = max(maxO, projO);
    minO = min(minO, projO);
    
    projO =  p1.x*O.x + p1.y*O.y; // note: p0.dot(O) = p1.dot(O)
    if (projO <= minO || projO >= maxO) return false;    
    
    return true;
  }
}
