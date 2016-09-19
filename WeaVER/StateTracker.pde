class StateTracker {
	float x,y;
	CharButton plus, minus;
	ArrayList<State> states;
	int idxPrev, idxActive;
	String label;
	int textsize;
	int maxStates;
	boolean changed;
	
	StateTracker(float x0, float y0, String s){
	    x=x0;
		y=y0;
		
		minus = new CharButton(x,y-2,13,'-');
		minus.setCharSize(14);
		plus = new CharButton(x+15,y-2,13,'+');
		
		textsize = 10;
		label = s;
		
		maxStates = 8;
		states = new ArrayList<State>(maxStates);
		
		State state = new State(x+40, y-10, 17, "1");
		state.setActive(true);
		idxActive = 0;
		minus.setActive(false);
		states.add(state);
		
		idxPrev = idxActive;
	}
	
	boolean changed(){
		return idxPrev != idxActive;
	}
	
	void setTextSize(int s){
		textsize = s;
	}
	
	void display(){
		textAlign(CENTER,BOTTOM);
		textSize(textsize);
		fill(30);
		text(label, x+14, y-2);
		
		plus.display();
		minus.display();
		
		for (State s:states){
			s.display();
		}
	}
	
	boolean interact(int mx, int my) {
		
		boolean interacted = plus.interact(mx,my) || minus.interact(mx,my);
		
		for (int i=0; i < states.size(); i++){
			if (interacted) break;
			interacted = interacted || (states.get(i)).interact(mx,my);
		}
		
		return interacted;
	}
	
	boolean keyPress(char key, int code) {
		int i = -1;
	    switch (key) {
	      case '8':
	        i++;
	      case '7':
	        i++; 
	      case '6':
	        i++;     
  	      case '5':
  	        i++;     
  	      case '4':
  	        i++;     
  	      case '3':
  	        i++;     
  	      case '2':
  	        i++;;     
  	      case '1':
  	        i++;     
	      default:  
	        break;
	    }
		
		if((i > -1) && (i < states.size())){
			State s = states.get(i);
			(states.get(idxActive)).setActive(false);
			s.setActive(true);
			idxPrev = idxActive;
			idxActive = i;
			return true;
		}
		else return false;
	}
	
	boolean clicked(int mx, int my) {
		boolean retval = false;
		if (plus.clicked(mx,my)){
			int i = states.size();
			State state = new State(x+40+(20*i), y-10, 17, Integer.toString(i+1));
			states.add(state);
			retval = true;
		}
		else if (minus.clicked(mx,my)){
			int j = states.size()-1;
			states.remove(j);
			if (idxActive > j-1){
				idxPrev = idxActive;
				idxActive = j-1;
				(states.get(j-1)).setActive(true);
			}
			retval = true;
		}
		else{
			for (int i=0; i < states.size(); i++){
				State s = states.get(i);
				if (s.clicked(mx,my)){
					(states.get(idxActive)).setActive(false);
					s.setActive(true);
					idxPrev = idxActive;
					idxActive = i;
					retval = true;
					break;
				}
			} 
		}
		
		int i = states.size();
		plus.setActive(i < maxStates);
		minus.setActive(i > 1);
		
		return retval;
	}
		
	void update(ArrayList<TargetBase> targets){
		if (idxPrev < states.size()) (states.get(idxPrev)).saveState(targets);
		(states.get(idxActive)).restoreState(targets);
		
		Target tmp;
		for (Container c : targets){
			tmp = (Target) c;
			if (tmp != null) tmp.updateRenderContext();
		}
						
		idxPrev = idxActive;
	}
	
	
	boolean released() {
		return plus.released() || minus.released();
	}
		
}