package com.neuedu.service.physician.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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
	@Transactional
	public RestBean addPrescription(List<Map<String, Object>> submit_prescription) {
		for(Map<String,Object> m : submit_prescription) {
			// Insert prescription record
			prescriptionMapper.insertPrescription(m);

			// Decrement drug stock — throw if insufficient (triggers rollback)
			Object drugIdObj = m.get("drug_id");
			Object drugNumObj = m.get("drug_number");
			if (drugIdObj != null && drugNumObj != null) {
				Integer drugId = Integer.valueOf(drugIdObj.toString());
				Integer quantity = Integer.valueOf(drugNumObj.toString());
				int affected = drugInfoMapper.decrementStock(drugId, quantity);
				if (affected == 0) {
					throw new RuntimeException("库存不足: drugId=" + drugId + " 需要=" + quantity);
				}
			}
		}
		RestBean rest = new RestBean();
		rest.setMsg("开立处方成功");
		return rest;
	}
}
