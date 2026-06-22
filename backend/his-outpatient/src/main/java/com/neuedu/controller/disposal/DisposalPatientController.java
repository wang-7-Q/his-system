package com.neuedu.controller.disposal;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.neuedu.bean.RestBean;
import com.neuedu.service.disposal.DisposalPatientService;

/**
 * 处置管理：处置患者信息录入
 */
@RestController
@CrossOrigin
public class DisposalPatientController {
	@Autowired
	private DisposalPatientService disposalPatientService;

	@RequestMapping("getDisposalPatient")
	public List<Map<String,Object>> getDisposalPatient(String register_id){
		
		return disposalPatientService.getDisposalPatient(register_id);
	}
	
	@RequestMapping("getDisposalPatientDept")
	public List<Map<String,Object>> getDisposalPatientDept(){
		return disposalPatientService.getDisposalPatientDept();
	}
	
	@RequestMapping("getDisposalPatientEmp")
	public List<Map<String,Object>> getDisposalPatientEmp(String deptment_id){
		return disposalPatientService.getDisposalPatientEmp(deptment_id);
	}
	
	@RequestMapping("updataDisposalPatient")
	public RestBean updataDisposalPatient(
			@RequestParam("id") String id,
			@RequestParam("disposal_employee_id") String disposal_employee_id) {
		return disposalPatientService.updataDisposalPatient(id,disposal_employee_id);
	}
}
