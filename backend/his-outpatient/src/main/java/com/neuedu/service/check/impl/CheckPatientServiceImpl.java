package com.neuedu.service.check.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.neuedu.bean.RestBean;
import com.neuedu.mapper.CheckRequestMapper;
import com.neuedu.mapper.DepartmentMapper;
import com.neuedu.mapper.EmployeeMapper;
import com.neuedu.service.check.CheckPatientService;
@Service
public class CheckPatientServiceImpl implements CheckPatientService {
	@Autowired
	private CheckRequestMapper checkRequestMap;
	@Autowired
	private DepartmentMapper departmentMapper;
	@Autowired
	private EmployeeMapper employeeMapper;
	@Override
	public List<Map<String, Object>> getCheckPatient(String register_id) {
		Map<String,Object> map = new HashMap<>();
		map.put("register_id", register_id);
		map.put("check_state", "已缴费");
		return checkRequestMap.getCheckRequestAndTechnology(map);
	}
	@Override
	public List<Map<String, Object>> getCheckPatientDept() {
		
		return departmentMapper.getDeptmentByType("检查");
	}
	@Override
	public List<Map<String, Object>> getCheckPatientEmp(String deptment_id) {
		return employeeMapper.getEmployeeByDeptid(deptment_id);
	}
	@Override
	public RestBean updataCheckPatient(String id, String check_employee_id) {
		int num = checkRequestMap.updataCheckPatient(id,check_employee_id);
		RestBean rest = new RestBean();
		if(num >0) {
			rest.setMsg("添加患者检查成功！");
		}else {
			rest.setMsg("添加患者检查失败！");
		}
		return rest;
	}

}
