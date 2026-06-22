package com.neuedu.util;

import java.util.Map;

public class PageUtil {
	/**
	 * 将分页提交map请求中，将nowPageNumber和pageSize转换为Integer
	 */
	public static Map<String,Object> objectToInt(Map<String,Object> map) {
		map.put("nowPageNumber", new Integer(map.get("nowPageNumber").toString()));
		map.put("pageSize", new Integer(map.get("pageSize").toString()));
		return map;
	}
}
