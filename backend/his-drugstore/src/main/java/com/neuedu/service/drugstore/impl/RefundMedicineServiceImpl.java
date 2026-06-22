package com.neuedu.service.drugstore.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.neuedu.bean.RestBean;
import com.neuedu.mapper.PrescriptionMapper;
import com.neuedu.service.drugstore.RefundMedicineService;
@Service
public class RefundMedicineServiceImpl implements RefundMedicineService {
	@Autowired
	private PrescriptionMapper prescriptionMapper;

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
		//根据患者id选择该患者已缴费药品
		return prescriptionMapper.getPrescriptionRequestAndDrug(map);
	}

	@Override
	public RestBean refundPatientDrugs(Integer id) {
		int num = prescriptionMapper.updateStateById(id,"已退药");
		RestBean rest = new RestBean();
		rest.setMsg("退药成功");
		return rest;
	}

}
