class Converter{
	Converter(){}
	
	public float K_to_C(float val){ return (val-273.15); }
	public float K_to_F(float val){ return ((val-273.15)*1.8 + 32.0); }
	
	public float mps_to_mph(float val){ return (val*(3600.0/1609.344)); }
	public float mps_to_kt(float val){ return (val*3.6/1.852); }
	public float fakeHaines(float val){ return (val+0.5); }
	
	/*public Field K_to_C(Field f){
		FloatList new_data

	}*/
	
}