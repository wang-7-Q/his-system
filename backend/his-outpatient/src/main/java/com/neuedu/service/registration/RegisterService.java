package com.neuedu.service.registration;

import java.util.Map;

import com.neuedu.bean.RestBean;
//患者信息
public interface RegisterService {

	String addRegister(Map<String, Object> map);

	String getAlreadyRegisterCount(String visitDate, String noon, String employeeId);
	//退号
	RestBean refundMedicalRecord(Integer id);

	String getMaxCaseNumber();

	RestBean getRecordRefundPatient(String case_number, String real_name
			, Integer nowPageNumber,Integer pageSize);

	RestBean treatPatient(Integer id);
	
}
