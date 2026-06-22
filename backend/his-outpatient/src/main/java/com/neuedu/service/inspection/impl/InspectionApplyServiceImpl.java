package com.neuedu.service.inspection.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.neuedu.bean.RestBean;
import com.neuedu.mapper.InspectionRequestMapper;
import com.neuedu.service.inspection.InspectionApplyService;
@Service
public class InspectionApplyServiceImpl implements InspectionApplyService {
	@Autowired
	private InspectionRequestMapper inspectionRequestMapper;
	@Override
	public Integer getFinishInspectionCount() {
		return inspectionRequestMapper.getFinishInspectionCount();
	}

	@Override
	public Integer getWaitInspectionCount() {
		return inspectionRequestMapper.getWaitInspectionCount("","");
	}

	@Override
	public RestBean getWaitInspection(String case_number, String real_name, Integer nowPageNumber, Integer pageSize) {
		RestBean rest = new RestBean();
		//患者信息
		List<Map<String,Object>> list = inspectionRequestMapper.getWaitInspection(case_number,real_name,nowPageNumber,pageSize);
		rest.setList(list);
		//患者总数
		Integer count = inspectionRequestMapper.getWaitInspectionCount(case_number,real_name);
		rest.setTotalCount(count);
		return rest;
	}

}
