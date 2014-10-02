class ConditionEnsemble {
	private IntList data;
	private int dimx;
	private int dimy;
	private int memberCount;
	boolean dataAvailable;
	
	// needed in order to generate probability field 
    PVector viewZero;
    float maxViewHeight, maxViewWidth;
	
	ConditionEnsemble(String file, int dx, int dy, int m, PVector offset, float maxh, float maxw){
		if (m > 32){ 
			println("ERROR: ConditionEnsemble's current implementation based on 32-bit 'int' -- more than 32 members invalid");
			dimx = 0;
			dimy = 0;
			data = new IntList();
			memberCount = 0;
			dataAvailable = false;
			
			viewZero = offset;
			maxViewHeight = maxh;
			maxViewWidth = maxw;
		}
		else {
			dimx = dx;
		    dimy = dy;
			data = new IntList();
			memberCount = m;
			
			viewZero = offset;
			maxViewHeight = maxh;
			maxViewWidth = maxw;
			
		    String[] lines;
			dataAvailable = true;
			try{
			    // read data from file
			    lines = loadStrings(file);
				for(String line: lines)
			    {
			      int val = int(line.trim());
			      data.append(val);
			    } 
			}
			catch(Exception e){
				dataAvailable = false;
			}
			
		    if (data.size() != dimx * dimy){
				println("ERROR creating ConditionEnsemble: number of entries in file does not match provided dimensions");
				dataAvailable = false;
			}
		}
	  
	}
	
	ConditionEnsemble(IntList d, int dx, int dy, int m, PVector offset, float maxh, float maxw){ 
		if (m > 32){ 
			println("ERROR: ConditionEnsemble's current implementation based on 32-bit 'int' -- more than 32 members invalid");
			dimx = 0;
			dimy = 0;
			data = new IntList();
			memberCount = 0;
			dataAvailable = false;
			
			viewZero = offset;
			maxViewHeight = maxh;
			maxViewWidth = maxw;
		}
		else {
			dataAvailable = true;
			dimx = dx;
		    dimy = dy;
		    data = d;
			memberCount = m;
			
			viewZero = offset;
			maxViewHeight = maxh;
			maxViewWidth = maxw;
		
		    if (data.size() != dimx * dimy){
				println("ERROR creating ConditionEnsemble: number of entries in provided IntList does not match provided dimensions");
				dataAvailable = false;
			}
		}
	}
	
	ConditionEnsemble(){
		dimx = 0;
		dimy = 0;
		data = new IntList();
		memberCount = 0;
		dataAvailable = false;
		viewZero = new PVector(0,0);;
		maxViewHeight = 0;
		maxViewWidth = 0;
	}
	
	ConditionEnsemble getCopy(){
		return (new ConditionEnsemble(data.copy(), dimx, dimy, memberCount, viewZero, maxViewHeight, maxViewWidth));
	}
	
	boolean dataIsAvailable(){	  
		return dataAvailable;  
	}
	
	void makeJointWith(ConditionEnsemble condition){ // NOTE: is cannibalistic
		if ((dimx != condition.dimx) || (dimy != condition.dimy) || (memberCount != condition.memberCount) || (data.size() != (condition.data).size())){
			println("makeJointWith FAILED: conditions not compatible -- either dimensions or member counts off");
			return;
		}
		
		for (int i = 0; i < data.size(); i++){
			int a = data.get(i);
			int b = (condition.data).get(i);
			data.set(i, (a & b));
		}
	}
	
	Field genProbabilityField(){
		
		FloatList probData = new FloatList(data.size());
		for (int i = 0; i < data.size(); i++){
			probData.append(float(Integer.bitCount(data.get(i)))*100/memberCount);
		}
		
		return (new Field(probData, 100.0, 0.0, dimx, dimy, viewZero, maxViewHeight, maxViewWidth));
	}
	
	private int getIndex(int x, int y, int N)
	{
	   int idx = (y*N)+x;
	   return idx;
	}
	  
}
