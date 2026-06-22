package com.neuedu.controller.registration;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.neuedu.bean.RestBean;
import com.neuedu.service.registration.RegisterService;

@RestController
@CrossOrigin
public class RegisterController {
	@Autowired
	private RegisterService registerService;
	//挂号
	@RequestMapping("addRegister")
	public String addRegister(@RequestParam Map<String,Object> map) {
		String rest = registerService.addRegister(map);
		return rest;
	}
	//得到最大病例号
	@RequestMapping("getMaxCaseNumber")
	public String getMaxCaseNumber(){
		String rest = registerService.getMaxCaseNumber();
		return rest;
	}
	
	@RequestMapping("getAlreadyRegisterCount")
	public String getAlreadyRegisterCount(String visitDate,String noon,String employeeId) {
		return registerService.getAlreadyRegisterCount(visitDate,noon,employeeId);
	}
	//得到退号患者信息（所有已经挂号状态为1的患者信息，分页）
	@RequestMapping("getRecordRefundPatient")
	public RestBean getRecordRefundPatient(String case_number
			,String real_name,Integer nowPageNumber,Integer pageSize) {
		return registerService.getRecordRefundPatient(case_number
				,real_name,nowPageNumber,pageSize);
	}
	//接诊
	@RequestMapping("treatPatient")
	public RestBean treatPatient(Integer id) {
		return registerService.treatPatient(id);
	}
	//退号
	@RequestMapping("refundMedicalRecord")
	public RestBean refundMedicalRecord(Integer id) {
		return registerService.refundMedicalRecord(id);
	}
}
