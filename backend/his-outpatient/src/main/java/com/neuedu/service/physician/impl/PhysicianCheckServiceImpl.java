package com.neuedu.service.physician.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.neuedu.bean.RestBean;
import com.neuedu.mapper.CheckRequestMapper;
import com.neuedu.mapper.InspectionRequestMapper;
import com.neuedu.mapper.MedicalTechnologyMapper;
import com.neuedu.service.physician.PhysicianCheckService;
@Service
public class PhysicianCheckServiceImpl implements PhysicianCheckService {
	@Autowired
	private MedicalTechnologyMapper medicalTechnologyMapper;
	@Autowired
	private CheckRequestMapper checkRequestMapper;
	
	@Override
	public List<Map<String, Object>> getCheck(Map<String, Object> map) {

		return medicalTechnologyMapper.getPhysicianCheckSearch(map);
	}
	@Override
	public RestBean addCheckRequest(String register_id, String[] medical_technology_ids, String check_info,
			String check_position, String check_remark) {
		for(String medical_technology_id:medical_technology_ids) {
			medical_technology_id = medical_technology_id.replace("[", "");
			medical_technology_id = medical_technology_id.replace("]", "");
			checkRequestMapper.addCheckRequest(register_id,medical_technology_id,check_info,check_position,check_remark);
		}
		RestBean rest = new RestBean();
		rest.setMsg("保存成功");
		return rest;
	}

}
