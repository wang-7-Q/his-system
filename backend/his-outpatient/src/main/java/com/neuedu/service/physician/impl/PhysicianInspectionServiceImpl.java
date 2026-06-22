package com.neuedu.service.physician.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.neuedu.bean.RestBean;
import com.neuedu.mapper.InspectionRequestMapper;
import com.neuedu.mapper.MedicalTechnologyMapper;
import com.neuedu.service.physician.PhysicianInspectionService;
@Service
public class PhysicianInspectionServiceImpl implements PhysicianInspectionService {
	@Autowired
	private MedicalTechnologyMapper medicalTechnologyMapper;
	@Autowired
	private InspectionRequestMapper inspectionRequestMapper;
	
	@Override
	public List<Map<String, Object>> getInspection(Map<String, Object> map) {
		return medicalTechnologyMapper.getPhysicianInspectionSearch(map);
	}

	@Override
	public RestBean addInspectionRequest(String register_id, String[] medical_technology_ids,
			String inspection_info, String inspection_position, String inspection_remark) {
		for(String medical_technology_id:medical_technology_ids) {
			medical_technology_id = medical_technology_id.replace("[", "");
			medical_technology_id = medical_technology_id.replace("]", "");
			inspectionRequestMapper.addInspectionRequest(
					register_id, medical_technology_id, 
					inspection_info, inspection_position, 
					inspection_remark);
		}
		RestBean rest = new RestBean();
		rest.setMsg("保存成功");
		return rest;
	}

}
