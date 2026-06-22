package com.neuedu.service.registration.impl;

import java.util.Date;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.neuedu.bean.RestBean;
import com.neuedu.mapper.RegisterMapper;
import com.neuedu.service.registration.RegisterService;
@Service
public class RegisterServiceImpl implements RegisterService {
	@Autowired
	private RegisterMapper registerMapper;
	//添加挂号信息
	@Override
	public String addRegister(Map<String, Object> map) {
		String isBook = (String)map.get("is_book");
		if("true".equals(isBook)) {
			map.put("is_book", "是");
		}else if("false".equals(isBook)) {
			map.put("is_book", "否");
		}
		map.put("visit_state", "1");
		map.put("visit_date", new Date());
		
		int num = registerMapper.addRegister(map);
		if(num > 0) {
			return "添加成功";
		}else {
			return "添加失败";
		}
	}
	@Override
	public String getAlreadyRegisterCount(String visitDate, String noon, String employeeId) {
		return registerMapper.getAlreadyRegisterCount(visitDate,noon,employeeId);
	}
	
	
	//得到最大病例号
	@Override
	public String getMaxCaseNumber() {
		return registerMapper.getMaxCaseNumber();
	}
	//得到退号患者信息（所有已经挂号状态为1的患者信息，分页）
	@Override
	public RestBean getRecordRefundPatient(String case_number, String real_name
			, Integer nowPageNumber,Integer pageSize) {
		RestBean rest = new RestBean();
		rest.setList(registerMapper.getPagePatientByState(case_number,real_name,nowPageNumber,pageSize,1));
		rest.setTotalCount(registerMapper.getPagePatientByStateCount(case_number,real_name,1));
		return rest;
	}
	//退号
	@Override
	public RestBean refundMedicalRecord(Integer id) {
		int n = registerMapper.updateStateById(id,4);
		RestBean rest = new RestBean();
		rest.setMsg("退号成功");
		return rest;
	}
	//接诊:
	@Override
	public RestBean treatPatient(Integer id) {
		int n = registerMapper.updateStateById(id,2);
		RestBean rest = new RestBean();
		rest.setMsg("接诊成功");
		return rest;
	}
}
