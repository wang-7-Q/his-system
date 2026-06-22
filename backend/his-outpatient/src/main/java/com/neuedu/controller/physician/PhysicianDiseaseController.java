package com.neuedu.controller.physician;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.neuedu.service.physician.PhysicianDiseaseService;
/**
 * 医生看诊：疾病管理
 */
@RestController
@CrossOrigin
public class PhysicianDiseaseController {
	@Autowired
	private PhysicianDiseaseService physicianDiseaseService;
	
	@RequestMapping("getDisease")
	public List<Map<String,Object>> getDisease(@RequestParam Map<String,Object> map){
		return physicianDiseaseService.getDisease(map);
	}
}
