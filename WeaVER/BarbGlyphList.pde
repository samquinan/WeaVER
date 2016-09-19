class BarbGlyphList {
	private ArrayList<PShape> barbs;
	
	BarbGlyphList(){
		barbs = new ArrayList<PShape>(30);
		
		// GENERATE ALL BARBS for 0-150
		PShape barb;
	
		float ls = 5;
		float l = 8;
	
		float s = 5;
		barb = createShape(GROUP);
		barb.disableStyle();
		barb.addChild(createShape(ELLIPSE, -s/2, -s/2, s, s));
		barbs.add(barb);
	
		// barb 5
		barb = createShape(GROUP);
		barb.disableStyle();
		barb.addChild(createShape(LINE, 0, 12, 0, -15));//shaft
		barb.addChild(createShape(LINE, -ls,  15-(9/8),   0,  12));
		barbs.add(barb);
	
		// barb 10
		barb = createShape(GROUP);
		barb.disableStyle();
		barb.addChild(createShape(LINE,   0,  12,   0, -15)); //shaft
		barb.addChild(createShape(LINE,  -l,  15,   0,  12));
		barbs.add(barb);
	
		// barb 15
		barb = createShape(GROUP);
		barb.disableStyle();
		barb.addChild(createShape(LINE,   0,  12,   0, -15)); //shaft
		barb.addChild(createShape(LINE,  -l,  15,   0,  12));
		barb.addChild(createShape(LINE, -ls,  12-(9/8),   0,  9));
		barbs.add(barb);
	
		// barb 20
		barb = createShape(GROUP);
		barb.disableStyle();
		barb.addChild(createShape(LINE,   0,  12,   0, -15)); //shaft
		barb.addChild(createShape(LINE,  -l,  15,   0,  12));
		barb.addChild(createShape(LINE,  -l,  12,   0,   9));
		barbs.add(barb);
	
		// barb 25
		barb = createShape(GROUP);
		barb.disableStyle();
		barb.addChild(createShape(LINE,   0,  12,   0, -15)); //shaft
		barb.addChild(createShape(LINE,  -l,  15,   0,  12));
		barb.addChild(createShape(LINE,  -l,  12,   0,   9));
		barb.addChild(createShape(LINE, -ls,   9-(9/8),   0,   6));
		barbs.add(barb);
	
		// barb 30
		barb = createShape(GROUP);
		barb.disableStyle();
		barb.addChild(createShape(LINE,   0,  12,   0, -15)); //shaft
		barb.addChild(createShape(LINE,  -l,  15,   0,  12));
		barb.addChild(createShape(LINE,  -l,  12,   0,   9));
		barb.addChild(createShape(LINE,  -l,   9,   0,   6));
		barbs.add(barb);
	
		// barb 35
		barb = createShape(GROUP);
		barb.disableStyle();
		barb.addChild(createShape(LINE,   0,  12,   0, -15)); //shaft
		barb.addChild(createShape(LINE,  -l,  15,   0,  12));
		barb.addChild(createShape(LINE,  -l,  12,   0,   9));
		barb.addChild(createShape(LINE,  -l,   9,   0,   6));
		barb.addChild(createShape(LINE, -ls,   6-(9/8),   0,   3));
		barbs.add(barb);
	
		// barb 40
		barb = createShape(GROUP);
		barb.disableStyle();
		barb.addChild(createShape(LINE,   0,  12,   0, -15)); //shaft
		barb.addChild(createShape(LINE,  -l,  15,   0,  12));
		barb.addChild(createShape(LINE,  -l,  12,   0,   9));
		barb.addChild(createShape(LINE,  -l,   9,   0,   6));
		barb.addChild(createShape(LINE,  -l,   6,   0,   3));
		barbs.add(barb);
	
		// barb 45
		barb = createShape(GROUP);
		barb.disableStyle();
		barb.addChild(createShape(LINE,   0,  12,   0, -15)); //shaft
		barb.addChild(createShape(LINE,  -l,  15,   0,  12));
		barb.addChild(createShape(LINE,  -l,  12,   0,   9));
		barb.addChild(createShape(LINE,  -l,   9,   0,   6));
		barb.addChild(createShape(LINE,  -l,   6,   0,   3));
		barb.addChild(createShape(LINE, -ls,   3-(9/8),   0,   0));
		barbs.add(barb);
	
		// barb 50
		barb = createShape(GROUP);
		barb.disableStyle();
		barb.addChild(createShape(LINE,   0,  12,   0, -15)); //shaft
		barb.addChild(createShape(TRIANGLE, 0, 12, -(l-1),  12,   0,   9));
		barbs.add(barb);
	
		// barb 55
		barb = createShape(GROUP);
		barb.disableStyle();
		barb.addChild(createShape(LINE,   0,  12,   0, -15)); //shaft
		barb.addChild(createShape(TRIANGLE, 0, 12, -(l-1),  12,   0,   9));
		barb.addChild(createShape(LINE, -ls,   9-(9/8),   0,   6));
		barbs.add(barb);
	
		// barb 60
		barb = createShape(GROUP);
		barb.disableStyle();
		barb.addChild(createShape(LINE,   0,  12,   0, -15)); //shaft
		barb.addChild(createShape(TRIANGLE, 0, 12, -(l-1),  12,   0,   9));
		barb.addChild(createShape(LINE,  -l,   9,   0,   6));
		barbs.add(barb);
	
		// barb 65
		barb = createShape(GROUP);
		barb.disableStyle();
		barb.addChild(createShape(LINE,   0,  12,   0, -15)); //shaft
		barb.addChild(createShape(TRIANGLE, 0, 12, -(l-1),  12,   0,   9));
		barb.addChild(createShape(LINE,  -l,   9,   0,   6));
		barb.addChild(createShape(LINE, -ls,   6-(9/8),   0,   3));
		barbs.add(barb);
	
		// barb 70
		barb = createShape(GROUP);
		barb.disableStyle();
		barb.addChild(createShape(LINE,   0,  12,   0, -15)); //shaft
		barb.addChild(createShape(TRIANGLE, 0, 12, -(l-1),  12,   0,   9));
		barb.addChild(createShape(LINE,  -l,   9,   0,   6));
		barb.addChild(createShape(LINE,  -l,   6,   0,   3));
		barbs.add(barb);
	
		// barb 75
		barb = createShape(GROUP);
		barb.disableStyle();
		barb.addChild(createShape(LINE,   0,  12,   0, -15)); //shaft
		barb.addChild(createShape(TRIANGLE, 0, 12, -(l-1),  12,   0,   9));
		barb.addChild(createShape(LINE,  -l,   9,   0,   6));
		barb.addChild(createShape(LINE,  -l,   6,   0,   3));
		barb.addChild(createShape(LINE, -ls,   3-(9/8),   0,   0));
		barbs.add(barb);
	
		// barb 80
		barb = createShape(GROUP);
		barb.disableStyle();
		barb.addChild(createShape(LINE,   0,  12,   0, -15)); //shaft
		barb.addChild(createShape(TRIANGLE, 0, 12, -(l-1),  12,   0,   9));
		barb.addChild(createShape(LINE,  -l,   9,   0,   6));
		barb.addChild(createShape(LINE,  -l,   6,   0,   3));
		barb.addChild(createShape(LINE,  -l,   3,   0,   0));
		barbs.add(barb);
	
		// barb 85
		barb = createShape(GROUP);
		barb.disableStyle();
		barb.addChild(createShape(LINE,   0,  12,   0, -15)); //shaft
		barb.addChild(createShape(TRIANGLE, 0, 12, -(l-1),  12,   0,   9));
		barb.addChild(createShape(LINE,  -l,   9,   0,   6));
		barb.addChild(createShape(LINE,  -l,   6,   0,   3));
		barb.addChild(createShape(LINE,  -l,   3,   0,   0));
		barb.addChild(createShape(LINE, -ls,   0-(9/8),   0,   -3));
		barbs.add(barb);
	
		// barb 90
		barb = createShape(GROUP);
		barb.disableStyle();
		barb.addChild(createShape(LINE,   0,  12,   0, -15)); //shaft
		barb.addChild(createShape(TRIANGLE, 0, 12, -(l-1),  12,   0,   9));
		barb.addChild(createShape(LINE,  -l,   9,   0,   6));
		barb.addChild(createShape(LINE,  -l,   6,   0,   3));
		barb.addChild(createShape(LINE,  -l,   3,   0,   0));
		barb.addChild(createShape(LINE,  -l,   0,   0,  -3));
		barbs.add(barb);
	
		// barb 90
		barb = createShape(GROUP);
		barb.disableStyle();
		barb.addChild(createShape(LINE,   0,  12,   0, -15)); //shaft
		barb.addChild(createShape(TRIANGLE, 0, 12, -(l-1),  12,   0,   9));
		barb.addChild(createShape(LINE,  -l,   9,   0,   6));
		barb.addChild(createShape(LINE,  -l,   6,   0,   3));
		barb.addChild(createShape(LINE,  -l,   3,   0,   0));
		barb.addChild(createShape(LINE,  -l,   0,   0,  -3));
		barb.addChild(createShape(LINE, -ls,   -3-(9/8),   0,   -6));
		barbs.add(barb);
	
		// barb 100
		barb = createShape(GROUP);
		barb.disableStyle();
		barb.addChild(createShape(LINE, 0, 12, 0, -15));
		barb.addChild(createShape(TRIANGLE, 0, 12, 	-7,  12,   0,   9));
		barb.addChild(createShape(TRIANGLE, 0, 	6,  -7,   6,   0,   3));	
		barbs.add(barb);
	
	
		// barb 105
		barb = createShape(GROUP);
		barb.disableStyle();
		barb.addChild(createShape(LINE, 0, 12, 0, -15));
		barb.addChild(createShape(TRIANGLE, 0, 12, 	-7,  12,   0,   9));
		barb.addChild(createShape(TRIANGLE, 0, 	6,  -7,   6,   0,   3));
		barb.addChild(createShape(LINE, -ls,   3-(9/8),   0,   0));	
		barbs.add(barb);
	
		// barb 110
		barb = createShape(GROUP);
		barb.disableStyle();
		barb.addChild(createShape(LINE, 0, 12, 0, -15));
		barb.addChild(createShape(TRIANGLE, 0, 12, 	-7,  12,   0,   9));
		barb.addChild(createShape(TRIANGLE, 0, 	6,  -7,   6,   0,   3));
		barb.addChild(createShape(LINE,  -l,   3,   0,  0));	
		barbs.add(barb);
	
		// barb 115
		barb = createShape(GROUP);
		barb.disableStyle();
		barb.addChild(createShape(LINE,   0,  12,   0, -15)); //shaft
		barb.addChild(createShape(TRIANGLE, 0, 12, -(l-1),  12,   0,   9));
		barb.addChild(createShape(TRIANGLE, 0, 	6,  -7,   6,   0,   3));
		barb.addChild(createShape(LINE,  -l,   3,   0,   0));
		barb.addChild(createShape(LINE, -ls,   0-(9/8),   0,   -3));
		barbs.add(barb);
	
		// barb 120
		barb = createShape(GROUP);
		barb.disableStyle();
		barb.addChild(createShape(LINE,   0,  12,   0, -15)); //shaft
		barb.addChild(createShape(TRIANGLE, 0, 12, -(l-1),  12,   0,   9));
		barb.addChild(createShape(TRIANGLE, 0, 	6,  -7,   6,   0,   3));
		barb.addChild(createShape(LINE,  -l,   3,   0,   0));
		barb.addChild(createShape(LINE,  -l,   0,   0,  -3));
		barbs.add(barb);
	
		// barb 125
		barb = createShape(GROUP);
		barb.disableStyle();
		barb.addChild(createShape(LINE,   0,  12,   0, -15)); //shaft
		barb.addChild(createShape(TRIANGLE, 0, 12, -(l-1),  12,   0,   9));
		barb.addChild(createShape(TRIANGLE, 0, 	6,  -7,   6,   0,   3));
		barb.addChild(createShape(LINE,  -l,   3,   0,   0));
		barb.addChild(createShape(LINE,  -l,   0,   0,  -3));
		barb.addChild(createShape(LINE, -ls,   -3-(9/8),   0,   -6));
		barbs.add(barb);
	
		// barb 130
		barb = createShape(GROUP);
		barb.disableStyle();
		barb.addChild(createShape(LINE,   0,  12,   0, -15)); //shaft
		barb.addChild(createShape(TRIANGLE, 0, 12, -(l-1),  12,   0,   9));
		barb.addChild(createShape(TRIANGLE, 0, 	6,  -7,   6,   0,   3));
		barb.addChild(createShape(LINE,  -l,   3,   0,   0));
		barb.addChild(createShape(LINE,  -l,   0,   0,  -3));
		barb.addChild(createShape(LINE,  -l,  -3,   0,  -6));
		barbs.add(barb);
	
		// barb 135
		barb = createShape(GROUP);
		barb.disableStyle();
		barb.addChild(createShape(LINE,   0,  12,   0, -15)); //shaft
		barb.addChild(createShape(TRIANGLE, 0, 12, -(l-1),  12,   0,   9));
		barb.addChild(createShape(TRIANGLE, 0, 	6,  -7,   6,   0,   3));
		barb.addChild(createShape(LINE,  -l,   3,   0,   0));
		barb.addChild(createShape(LINE,  -l,   0,   0,  -3));
		barb.addChild(createShape(LINE,  -l,  -3,   0,  -6));
		barb.addChild(createShape(LINE, -ls,  -6-(9/8),   0,   -9));
		barbs.add(barb);
	
		// barb 140
		barb = createShape(GROUP);
		barb.disableStyle();
		barb.addChild(createShape(LINE,   0,  12,   0, -15)); //shaft
		barb.addChild(createShape(TRIANGLE, 0, 12, -(l-1),  12,   0,   9));
		barb.addChild(createShape(TRIANGLE, 0, 	6,  -7,   6,   0,   3));
		barb.addChild(createShape(LINE,  -l,   3,   0,   0));
		barb.addChild(createShape(LINE,  -l,   0,   0,  -3));
		barb.addChild(createShape(LINE,  -l,  -3,   0,  -6));
		barb.addChild(createShape(LINE,  -l,  -6,   0,  -9));
		barbs.add(barb);
	
		// barb 145
		barb = createShape(GROUP);
		barb.disableStyle();
		barb.addChild(createShape(LINE,   0,  12,   0, -15)); //shaft
		barb.addChild(createShape(TRIANGLE, 0, 12, -(l-1),  12,   0,   9));
		barb.addChild(createShape(TRIANGLE, 0, 	6,  -7,   6,   0,   3));
		barb.addChild(createShape(LINE,  -l,   3,   0,   0));
		barb.addChild(createShape(LINE,  -l,   0,   0,  -3));
		barb.addChild(createShape(LINE,  -l,  -3,   0,  -6));
		barb.addChild(createShape(LINE,  -l,  -6,   0,  -9));
		barb.addChild(createShape(LINE, -ls,  -9-(9/8),   0,  -12));
		barbs.add(barb);
	
		//barb 150
		barb = createShape(GROUP);
		barb.disableStyle();
		barb.addChild(createShape(LINE, 0, 12, 0, -15));
		barb.addChild(createShape(TRIANGLE, 0, 	0,  -7,   0,   0,  -3));	
		barb.addChild(createShape(TRIANGLE, 0, 	6,  -7,   6,   0,   3));	
		barb.addChild(createShape(TRIANGLE, 0, 12, 	-7,  12,   0,   9));	
		barbs.add(barb);	
	}
	
	PShape getBarbGlyph(float x){
		float tmp = min(max(0,x),150);
		return barbs.get(round(tmp/5));
	}
	
}