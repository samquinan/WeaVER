import java.util.Date;
import java.text.SimpleDateFormat;

class DateTime {
	public static final long HOUR = 3600*1000;
	private static SimpleDateFormat inputFmt = new SimpleDateFormat("yyyyMMdd HH");
	private static SimpleDateFormat outputFmt = new SimpleDateFormat("EEEE  HH:mm'Z'  dd-MMM-yy");
	private static SimpleDateFormat startFmt = new SimpleDateFormat("MM/dd/yy  't'HH");
	public long start_time;
	private Date start_d;
	
	public DateTime(String date, String run){
		String tmp = date+" "+run;
		try {
			start_d = inputFmt.parse(tmp);
			start_time = start_d.getTime();
		}
		catch (Exception e){
			System.out.println(e.getMessage());
		}
	} 
	
	public DateTime(String date, int run){
		String tmp = date+" "+run;
		try {
			start_d = inputFmt.parse(tmp);
			start_time = start_d.getTime();
		}
		catch (Exception e){
			System.out.println(e.getMessage());
		}
	}
	
	public String getDateString(int h){
		String fhr = String.format("%02d", h);
		return (startFmt.format(start_d)+"  "+fhr + "HR  --  " + outputFmt.format(new Date(start_time + h*HOUR)));
	}
	
	
}