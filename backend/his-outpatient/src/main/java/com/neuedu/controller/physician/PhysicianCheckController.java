package com.neuedu.controller.physician;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.neuedu.bean.RestBean;
import com.neuedu.service.physician.PhysicianCheckService;

/**
 * 医生看诊：检查管理
 */
@RestController
@CrossOrigin
public class PhysicianCheckController {
	@Autowired
	private PhysicianCheckService physicianCheckService;
	
	@RequestMapping("getCheck")
	public List<Map<String,Object>> getCheck(@RequestParam Map<String,Object> map){
		return physicianCheckService.getCheck(map);
	}
	
	@RequestMapping("addCheckRequest")
	public RestBean addCheckRequest(@RequestParam("register_id") String register_id
			,@RequestParam("medical_technology_ids") String[] medical_technology_ids
			,@RequestParam("check_info") String check_info
			,@RequestParam("check_position") String check_position
			,@RequestParam("check_remark") String check_remark) {
		return physicianCheckService.addCheckRequest(register_id,medical_technology_ids,check_info,check_position,check_remark);
	}
}
