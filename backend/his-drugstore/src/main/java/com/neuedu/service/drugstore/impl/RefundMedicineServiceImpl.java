package com.neuedu.service.drugstore.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.neuedu.bean.RestBean;
import com.neuedu.mapper.DrugInfoMapper;
import com.neuedu.mapper.PrescriptionMapper;
import com.neuedu.service.drugstore.RefundMedicineService;

@Service
public class RefundMedicineServiceImpl implements RefundMedicineService {
	@Autowired
	private PrescriptionMapper prescriptionMapper;
	@Autowired
	private DrugInfoMapper drugInfoMapper;

	@Override
	public RestBean getGivePricePatient(Map<String, Object> map) {
		RestBean rest = new RestBean();
		String case_number = (String)map.get("case_number");
		String real_name = (String)map.get("real_name");
		Integer nowPageNumber = new Integer(map.get("nowPageNumber").toString());
		Integer pageSize = new Integer(map.get("pageSize").toString());
		rest.setList(prescriptionMapper.getPrescriptionAndPatientByProperty(case_number,real_name,"已发药",nowPageNumber,pageSize));
		rest.setTotalCount(prescriptionMapper.getPrescriptionAndPatientCountByProperty(case_number,real_name,"已发药"));
		return rest;
	}

	@Override
	public List<Map<String, Object>> getGivePatientDrug(Integer id) {
		Map<String,Object> map = new HashMap<>();
		map.put("drug_state", "已发药");
		map.put("register_id", id);
		return prescriptionMapper.getPrescriptionRequestAndDrug(map);
	}

	@Override
	@Transactional
	public RestBean refundPatientDrugs(Integer registerId) {
		// 1. Restore drug stock
		Map<String, Object> query = new HashMap<>();
		query.put("drug_state", "已发药");
		query.put("register_id", registerId);
		List<Map<String, Object>> drugs = prescriptionMapper.getPrescriptionRequestAndDrug(query);
		if (drugs != null) {
			for (Map<String, Object> drug : drugs) {
				Object drugIdObj = drug.get("drug_info_id");
				Object numberObj = drug.get("item_number");
				if (drugIdObj != null && numberObj != null) {
					Integer drugId = Integer.valueOf(drugIdObj.toString());
					Integer quantity = Integer.valueOf(numberObj.toString());
					drugInfoMapper.incrementStock(drugId, quantity);
				}
			}
		}

		// 2. Update all prescriptions for this register: 已发药 → 已退药
		int num = prescriptionMapper.updateStateByRegisterId(registerId, "已发药", "已退药");
		RestBean rest = new RestBean();
		if (num > 0) {
			rest.setMsg("退药成功");
		} else {
			rest.setMsg("无待退药品");
		}
		return rest;
	}
}
