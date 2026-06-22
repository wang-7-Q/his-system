package com.neuedu.controller.physician;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.neuedu.bean.RestBean;
import com.neuedu.service.physician.PhysicianHistorySerivice;

/**
 * 医生看诊：看诊记录
 */
@RestController
@CrossOrigin
public class PhysicianHistoryController {
	@Autowired
	private PhysicianHistorySerivice physicianHistorySerivice;

	@RequestMapping("getCheckedPatient")
	public RestBean getCheckedPatient(@RequestParam("employee_id") Integer employee_id
			,@RequestParam("case_number") String case_number
			,@RequestParam("real_name") String real_name
			,@RequestParam("nowPageNumber") Integer nowPageNumber
			,@RequestParam("pageSize") Integer pageSize	){
		
		return physicianHistorySerivice.getCheckedPatient(employee_id,case_number,real_name,nowPageNumber,pageSize);
	}
	//通用根据类型得到患者信息（分页）
//	@RequestMapping("getPatientBy")
//	public RestBean getCheckedPatient(@RequestParam("case_number") String case_number
//			,@RequestParam("real_name") String real_name
//			,@RequestParam("nowPageNumber") Integer nowPageNumber
//			,@RequestParam("pageSize") Integer pageSize	){
//		
//		return physicianHistorySerivice.getCheckedPatient(case_number,real_name,nowPageNumber,pageSize);
//	}
	
}
