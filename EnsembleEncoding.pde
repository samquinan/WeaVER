class EnsembleEncoding implements EncodesSP, EncodesCBP {
	
	// SP
	ArrayList< ArrayList<Field> > members;
	ArrayList<String> labels;
	float isovalue;
	
	// CBP
	// ColorMapf cmap;
	
	EnsembleEncoding(ArrayList< ArrayList<Field> > fields){
		members = fields;
		genMemberLabels();	
	}
	
	EnsembleEncoding(ArrayList< ArrayList<Field> > fields, ArrayList<String> member_labels){
		members = fields;
		if (members.size() != member_labels.size()){
			println("ERROR: Number of labels for EnsembleEncoding does not match number of members");
			genMemberLabels();
		}
		else labels = member_labels;
	}
	
	private void genMemberLabels(){
		labels = new ArrayList<String>();
		for (int idx = 0; idx < members.size(); idx++){
			String id = "member " + Integer.toString(idx);
			labels.add(id);
		}
	}
	
	boolean setMemberLabels(ArrayList<String> member_labels){
		if (members.size() != member_labels.size()){
			println("ERROR: Number of labels for EnsembleEncoding does not match number of members");
			return false;
		}
		else {
			labels = member_labels;
			return true;
		}
	}
	
	ArrayList<String> getMemberLabels(){
		return labels;
	}
	
	void setIsovalue(float iso){
		isovalue = iso;
	}
	
	void genSPContours(ArrayList<Contour2D> contours){
		Contour2D c;
		ArrayList<Field> member;
		for (int i = 0; i < members.size(); i++){
			member = members.get(i);
			Field f = member.get(0);
			c = new Contour2D(2*f.dimy);
			f.genIsocontour(isovalue, c);
			c.setID(labels.get(i));
			contours.add(c);
		}
	}
	
	void genSPContours(ArrayList<Contour2D> contours, int idx){
		Contour2D c;
		ArrayList<Field> member;
		for (int i = 0; i < members.size(); i++){
			member = members.get(i);
			Field f = member.get(idx);
			c = new Contour2D(2*f.dimy);
			f.genIsocontour(isovalue, c);
			c.setID(labels.get(i));
			contours.add(c);
		}
	}
		
}