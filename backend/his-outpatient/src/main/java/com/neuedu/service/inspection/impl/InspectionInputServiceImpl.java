package com.neuedu.service.inspection.impl;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.neuedu.bean.RestBean;
import com.neuedu.mapper.InspectionRequestMapper;
import com.neuedu.service.inspection.InspectionInputService;
@Service
public class InspectionInputServiceImpl implements InspectionInputService {
	@Autowired
	private InspectionRequestMapper inspectionRequestMapper;
	@Override
	public RestBean getFinishInspection(String case_number, String real_name, Integer nowPageNumber, Integer pageSize) {
		RestBean rest = new RestBean();
		//完成检查患者信息
		List<Map<String,Object>> list = inspectionRequestMapper.getFinishCheck(case_number,real_name,nowPageNumber,pageSize);
		rest.setList(list);
		//完成检查的患者数量		
		Integer count = inspectionRequestMapper.getFinishCheckCountNumber(case_number,real_name);
		rest.setTotalCount(count);
		return rest;
	}

	@Override
	public List<Map<String, Object>> getFinishInspectionByRegistid(String id) {
		List<Map<String,Object>> list = inspectionRequestMapper.getFinishCheckByRegistid(id);
		SimpleDateFormat smf = new SimpleDateFormat("YYYY-MM-dd hh:mm:ss");
		for(Map<String,Object> m : list) {
			Object ct = m.get("check_time");
			if(ct!=null) {
				Timestamp date = (Timestamp)ct;
				String s = smf.format(date);
				m.put("check_time", s);
			}
		}
		return list;
	}

	@Override
	public RestBean updateInspectionInput(String id, String employee_id, String inspection_result) {
		RestBean rest = new RestBean();
		inspectionRequestMapper.updateCheckInput(id,employee_id,inspection_result);
		rest.setMsg("添加成功");
		return rest;
	}

}
