package com.neuedu.controller.inspection;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.neuedu.bean.RestBean;
import com.neuedu.service.inspection.InspectionPatientService;

/**
 * 检验管理：检验患者信息录入
 */
@RestController
@CrossOrigin
public class InspectionPatientController {
	@Autowired
	private InspectionPatientService inspectionPatientService;

	@RequestMapping("getInspectionPatient")
	public List<Map<String,Object>> getInspectionPatient(String register_id){
		
		return inspectionPatientService.getInspectionPatient(register_id);
	}
	
	@RequestMapping("getInspectionPatientDept")
	public List<Map<String,Object>> getInspectionPatientDept(){
		return inspectionPatientService.getInspectionPatientDept();
	}
	
	@RequestMapping("getInspectionPatientEmp")
	public List<Map<String,Object>> getInspectionPatientEmp(String deptment_id){
		return inspectionPatientService.getInspectionPatientEmp(deptment_id);
	}
	
	@RequestMapping("updataInspectionPatient")
	public RestBean updataInspectionPatient(
			@RequestParam("id") String id,
			@RequestParam("inspection_employee_id") String inspection_employee_id) {
		return inspectionPatientService.updataInspectionPatient(id,inspection_employee_id);
	}
}
