import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.Properties;


public class DatasetProperties {
	int run = -1;
	String date = "";
	
	DatasetProperties(String relative_path){
		
		Properties prop = new Properties();
		InputStream input = null;
 
		try {
 
			input = new FileInputStream(sketchPath(relative_path));
 
			// load the properties file
			prop.load(input);
 
			// get the property values
			String value;
			value = prop.getProperty("run");
			if (value != null) run = Integer.parseInt(value);
			
			value = prop.getProperty("date");
			if (value != null) date = value;
 
		} catch (IOException ex) {
			ex.printStackTrace();
		} finally {
			if (input != null) {
				try {
					input.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
		
	}
	
	int getRun(){
		return run;
	}
	
	String getDate(){
		return date;
	}
	
}
