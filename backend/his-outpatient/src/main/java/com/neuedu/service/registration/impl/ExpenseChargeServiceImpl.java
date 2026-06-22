package com.neuedu.service.registration.impl;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.neuedu.bean.RestBean;
import com.neuedu.mapper.CheckRequestMapper;
import com.neuedu.mapper.DisposalRequestMapper;
import com.neuedu.mapper.InspectionRequestMapper;
import com.neuedu.mapper.PrescriptionMapper;
import com.neuedu.mapper.RegisterMapper;
import com.neuedu.service.registration.ExpenseChargeService;
@Service
public class ExpenseChargeServiceImpl implements ExpenseChargeService {
	@Autowired
	private RegisterMapper registerMapper;
	@Autowired
	private CheckRequestMapper checkRequestMap;
	@Autowired
	private InspectionRequestMapper inspectionRequestMapper;
	@Autowired
	private DisposalRequestMapper disposalRequestMapper;
	@Autowired
	private PrescriptionMapper prescriptionMapper;	
	
	//收费窗口，获取患者需要收费的记录
	@Override
	public Map<String, Object> searchExpenseChargePatient(String case_number, String real_name) {		
		return this.searchExpensePatient(case_number, real_name,"已开立");		
	}
	private Map<String,Object> searchExpensePatient(String case_number, String real_name,String state){
		List<Map<String,Object>> requestList = new ArrayList<>();
		Map<String,Object> map = new HashMap<>();
		map.put("case_number", case_number);
		map.put("real_name", real_name);
		
		List<Map<String,Object>> list = registerMapper.getRegisterByProperty(map);
		Map<String,Object> registMap = null;
		if(list!=null && list.size()>0) {
			registMap = list.get(0);
			Object registId = registMap.get("id");
			map.clear();
			map.put("register_id", registId);
			map.put("check_state", state);
			requestList = checkRequestMap.getCheckRequestAndTechnology(map);
			
			map.clear();
			map.put("register_id", registId);
			map.put("inspection_state", state);
			requestList.addAll(inspectionRequestMapper.getInspectionRequestAndTechnology(map));
			
			map.clear();
			map.put("register_id", registId);
			map.put("disposal_state", state);
			requestList.addAll(disposalRequestMapper.getDisposalRequestAndTechnology(map));
			
			map.clear();
			map.put("register_id", registId);
			map.put("drug_state", state);
			requestList.addAll(prescriptionMapper.getPrescriptionRequestAndDrug(map));
		}else {
			map.put("registMap",null);
			map.put("requestList",null);
			return map;
		}
		Map<String,Object> rest = new HashMap<>();
		rest.put("registMap", registMap);
		for(Map<String,Object> m : requestList) {
			Timestamp d = (Timestamp)m.get("item_create_time");
			SimpleDateFormat smp = new SimpleDateFormat("YYYY-MM-dd");
			String s = smp.format(d);
			m.put("item_create_time", s);
		}
		rest.put("requestList", requestList);
		return rest;
	}
	//根据类型，修改检查或检验数据状态为 “已缴费”
	@Override
	public RestBean expenseCharge(List<Map<String, Object>> list) {
		RestBean rest = this.expenseState(list, "已缴费");
		rest.setMsg("缴费成功");
		return rest;
	}
	private RestBean expenseState(List<Map<String, Object>> list,String state) {
		for(Map<String,Object> m : list) {
			if("检查".equals(m.get("item_type"))) {
				checkRequestMap.updateStateById(new Integer(m.get("id").toString()),state);
			}else if("检验".equals(m.get("item_type"))) {
				inspectionRequestMapper.updateStateById(new Integer(m.get("id").toString()),state);
			}else if("药品".equals(m.get("item_type"))) {
				prescriptionMapper.updateStateById(new Integer(m.get("id").toString()),state);
			}else if("处置".equals(m.get("item_type"))) {
				disposalRequestMapper.updateStateById(new Integer(m.get("id").toString()),state);
			}
		}
		RestBean rest = new RestBean();		
		return rest;
	}
	@Override
	public Map<String, Object> searchExpenseRefundPatient(String case_number, String real_name) {
		return this.searchExpensePatient(case_number, real_name,"已缴费");	
	}
	@Override
	public RestBean expenseRefund(List<Map<String, Object>> list) {
		RestBean rest = this.expenseState(list, "已退费");
		rest.setMsg("退费成功");
		return rest;
	}
	//收费窗口：查看所有患者
	@Override
	public Map<String, Object> searchAllPricePatient(String case_number, String real_name) {
		return this.searchExpensePatient(case_number, real_name,"");
	}
}
