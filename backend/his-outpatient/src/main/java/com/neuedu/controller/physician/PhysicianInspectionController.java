package com.neuedu.controller.physician;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.neuedu.bean.RestBean;
import com.neuedu.service.physician.PhysicianInspectionService;

/**
 * 医生看诊：检验管理
 */
@RestController
@CrossOrigin
public class PhysicianInspectionController {
	@Autowired
	private PhysicianInspectionService physicianInspectionService;
	
	@RequestMapping("getInspection")
	public List<Map<String,Object>> getInspection(@RequestParam Map<String,Object> map){
		return physicianInspectionService.getInspection(map);
	}
	
	@RequestMapping("addInspectionRequest")
	public RestBean addInspectionRequest(@RequestParam("register_id") String register_id
			,@RequestParam("medical_technology_ids") String[] medical_technology_ids
			,@RequestParam("inspection_info") String inspection_info
			,@RequestParam("inspection_position") String inspection_position
			,@RequestParam("inspection_remark") String inspection_remark){
		return physicianInspectionService.addInspectionRequest(register_id,medical_technology_ids,inspection_info,inspection_position,inspection_remark);
	}
	
}
