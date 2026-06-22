package com.neuedu.controller.check;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.neuedu.bean.RestBean;
import com.neuedu.service.check.CheckPatientService;

/**
 * 检查管理：检查患者信息录入
 */
@RestController
@CrossOrigin
public class CheckPatientController {
	@Autowired
	private CheckPatientService checkPatientService;

	@RequestMapping("getCheckPatient")
	public List<Map<String,Object>> getCheckPatient(String register_id){
		
		return checkPatientService.getCheckPatient(register_id);
	}
	
	@RequestMapping("getCheckPatientDept")
	public List<Map<String,Object>> getCheckPatientDept(){
		return checkPatientService.getCheckPatientDept();
	}
	
	@RequestMapping("getCheckPatientEmp")
	public List<Map<String,Object>> getCheckPatientEmp(String deptment_id){
		return checkPatientService.getCheckPatientEmp(deptment_id);
	}
	
	@RequestMapping("updataCheckPatient")
	public RestBean updataCheckPatient(
			@RequestParam("id") String id,
			@RequestParam("check_employee_id") String check_employee_id) {
		return checkPatientService.updataCheckPatient(id,check_employee_id);
	}
}
