package com.neuedu.util;

public class ParamUtil {
	/**
	 * 判断字符串是否能够转换为整形，如果不可以，赋值为默认值，返回String
	 */
	public static String stringToInt(String str , int def) {
		if(str == null || str.trim().length()==0) {
			str = def + "";
		}else {
			try {
				Integer.parseInt(str);
			}catch(Exception e) {
				str = def + "";
			}
		}
		return str;
	}
	/**
	 * 判断字符串是否能够转换为整形，如果不可以，赋值为默认值，返回Integer
	 */
	public static Integer strToInt(String str,int def) {
		String s = stringToInt(str,def);
		return Integer.parseInt(s);
	}
}
