package com.neuedu.service.physician.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.neuedu.bean.RestBean;
import com.neuedu.mapper.DisposalRequestMapper;
import com.neuedu.mapper.MedicalTechnologyMapper;
import com.neuedu.service.physician.DisposalRequestService;
@Service
public class DisposalRequestServiceImpl implements DisposalRequestService {
	@Autowired
	private MedicalTechnologyMapper medicalTechnologyMapper;
	@Autowired
	private DisposalRequestMapper disposalRequestMapper;

	@Override
	public List<Map<String, Object>> getDisposal(Map<String, Object> map) {
		return medicalTechnologyMapper.getPhysicianDisposalSearch(map);
	}

	@Override
	public RestBean addDisposalRequest(String register_id, String[] medical_technology_ids, String disposal_info,
			String disposal_position, String disposal_remark) {
		for(String medical_technology_id:medical_technology_ids) {
			medical_technology_id = medical_technology_id.replace("[", "");
			medical_technology_id = medical_technology_id.replace("]", "");
			disposalRequestMapper.addDisposalRequest(
					register_id, medical_technology_id, 
					disposal_info, disposal_position, 
					disposal_remark);
		}
		RestBean rest = new RestBean();
		rest.setMsg("保存成功");
		return rest;
	}

}
