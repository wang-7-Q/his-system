package com.neuedu.service.drugstore.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.neuedu.bean.RestBean;
import com.neuedu.mapper.PrescriptionMapper;
import com.neuedu.service.drugstore.GiveMedicineService;
@Service
public class GiveMedicineServiceImpl implements GiveMedicineService {
	@Autowired
	private PrescriptionMapper prescriptionMapper;

	@Override
	public RestBean getFinishPricePatient(Map<String, Object> map) {
		RestBean rest = new RestBean();
		String case_number = (String)map.get("case_number");
		String real_name = (String)map.get("real_name");
		Integer nowPageNumber = new Integer(map.get("nowPageNumber").toString());
		Integer pageSize = new Integer(map.get("pageSize").toString());
		rest.setList(prescriptionMapper.getPrescriptionAndPatientByProperty(case_number,real_name,"已缴费",nowPageNumber,pageSize));
		rest.setTotalCount(prescriptionMapper.getPrescriptionAndPatientCountByProperty(case_number,real_name,"已缴费"));
		return rest;
	}

	@Override
	public List<Map<String, Object>> getPricePatientDrug(Integer id) {
		Map<String,Object> map = new HashMap<>();
		map.put("drug_state", "已缴费");
		map.put("register_id", id);
		//根据患者id选择该患者已缴费药品
		return prescriptionMapper.getPrescriptionRequestAndDrug(map);
	}

	@Override
	public RestBean givePatientDrugs(Integer id) {
		int num = prescriptionMapper.updateStateById(id,"已发药");
		RestBean rest = new RestBean();
		rest.setMsg("发药成功");
		return rest;
	}

}
