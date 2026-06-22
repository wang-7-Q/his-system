package com.neuedu.service.physician.impl;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.neuedu.mapper.CheckRequestMapper;
import com.neuedu.service.physician.CheckResultsService;
@Service
public class CheckResultsServiceImpl implements CheckResultsService {
	@Autowired
	private CheckRequestMapper checkRequestMapper;

	@Override
	public List<Map<String, Object>> getCheckPatientTableByRegist(String registid) {
		List<Map<String ,Object>> list = checkRequestMapper.getCheckPatientTableByRegist(registid);
		SimpleDateFormat smf = new SimpleDateFormat("YYYY-MM-dd HH:mm:ss");
		for(Map<String,Object> m : list) {
			Timestamp t1 = (Timestamp)m.get("creation_time");
			if(t1!=null) {
				String s1 = smf.format(t1);
				m.put("creation_time", s1);
			}
			Timestamp t2 = (Timestamp)m.get("check_time");
			if(t2!=null) {
				String s2 = smf.format(t2);
				m.put("check_time", s2);
			}
		}
		
		return list;
	}

}
