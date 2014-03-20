class QuadTree_Node<E extends QuadTreeElement> {
	private QuadTree_Node<E> tr, tl, br, bl;
	protected float maxAABBx, maxAABBy, minAABBx, minAABBy;
	int maxMembers;
	ArrayList<E> members;
	
	public QuadTree_Node( float minx, float miny, float maxx, float maxy, int k){
		
		tr = null;
		tl = null;
		br = null;
		bl = null;
		
		minAABBx = minx;
		minAABBy = miny;
		maxAABBx = maxx;
		maxAABBy = maxy;
		maxMembers = k;
		
		members = new ArrayList<E>(k);
	}
	
	public void clear(){
		tr = null;//no need for recursive clear -- exiting scope will trigger garbage collection
		tl = null;
		br = null;
		bl = null;
		
		members.clear();
	}
	
	public void add(E member){
		// test for / subdivide
		if (members.size() == maxMembers) subdivide();
		
		// add as approriate
		if (tr != null){ // node is not a leaf
			tr.add(member);
			tl.add(member);
			br.add(member);
			bl.add(member);
		} 
		else { // node is a leaf
			if (member.intersectsAABB(minAABBx, minAABBy, maxAABBx, maxAABBy)) members.add(member);
		}
	}
	
	public E select(float x, float y, float offset){
		
		E selection = null;
		if (tr != null){ // not leaf, recurse, recurse!
			float midx = (minAABBx + maxAABBx)/2.0;
			float midy = (minAABBy + maxAABBy)/2.0;
						
			if (x >= midx && x <= maxAABBx && y >= midy && y <= maxAABBy) selection = tr.select(x,y,offset);
			else if (x >= minAABBx && x < midx && y >= midy && y <= maxAABBy) selection = tl.select(x,y,offset);
			else if (x >= midx && x <= maxAABBx && y >= minAABBy && y < midy) selection = br.select(x,y,offset);
			else if (x >= minAABBx && x < midx && y >= minAABBy && y < midy) selection = bl.select(x,y,offset);
			// else, not in range, defaults to null
		}
		else{ // search leaf
			for (E m: members){
				if (m.intersectsAABB(x-offset, y-offset, x+offset, y+offset)){
					selection = m; // return first found
					break;
				}
			}
		}
		return selection;
	}
	
	
	
	protected boolean subdivide(){
		if (tr != null) return false; //already subdivided
		
		//create 4 sub-nodes
		float midx = (minAABBx + maxAABBx)/2.0;
		float midy = (minAABBy + maxAABBy)/2.0;
		
		tr = new QuadTree_Node<E>(midx, midy, maxAABBx, maxAABBy, maxMembers);
		tl = new QuadTree_Node<E>(minAABBx, midy, midx, maxAABBy, maxMembers);
		br = new QuadTree_Node<E>(midx, minAABBy, maxAABBx, midy, maxMembers);
		bl = new QuadTree_Node<E>(minAABBx, minAABBy, midx, midy, maxMembers);
		
		//transfer members to sub-nodes
		for(E m : members){
			tr.add(m);
			tl.add(m);
			br.add(m);
			bl.add(m);
		}
		
		return true;
	}
}
