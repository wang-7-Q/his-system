package com.neuedu.service.physician.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.neuedu.bean.RestBean;
import com.neuedu.mapper.DrugInfoMapper;
import com.neuedu.mapper.PrescriptionMapper;
import com.neuedu.service.physician.WritePrescriptionService;
@Service
public class WritePrescriptionServiceImpl implements WritePrescriptionService {
	@Autowired
	private DrugInfoMapper drugInfoMapper;
	@Autowired
	private PrescriptionMapper prescriptionMapper;

	@Override
	public List<Map<String, Object>> searchDrug(Map<String, Object> map) {
		return drugInfoMapper.searchDrug(map);
	}

	@Override
	public RestBean addPrescription(List<Map<String, Object>> submit_prescription) {
		for(Map<String,Object> m : submit_prescription) {
			
			prescriptionMapper.insertPrescription(m);
			System.out.println(m.get("register_id"));
			System.out.println(m.get("drug_id"));
			System.out.println(m.get("drug_usage"));
			System.out.println(m.get("drug_number"));
		}
		RestBean rest = new RestBean();
		rest.setMsg("开立处方成功");
		return rest;
	}

}
