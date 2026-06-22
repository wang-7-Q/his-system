package com.neuedu.util;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Map;

public class TimestampUtil {

	//将List中map项目的Timestamp格式化
	public static void formatTimestamp(List<Map<String,Object>> list,String name) {
		SimpleDateFormat smf = new SimpleDateFormat("YYYY-MM-dd hh:mm:ss");
		for(Map<String,Object> m : list) {
			Object ct = m.get(name);
			if(ct!=null) {
				Timestamp date = (Timestamp)ct;
				String s = smf.format(date);
				m.put(name, s);
			}
		}
	}
}
