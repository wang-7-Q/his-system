package com.neuedu.controller.physician;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.neuedu.service.physician.CheckResultsService;

/**
 * 医生看诊：检查结果
 */
@RestController
@CrossOrigin
public class CheckResultsController {
	@Autowired
	private CheckResultsService checkResultsService;
	
	@RequestMapping("getCheckPatientTableByRegist")
	public List<Map<String,Object>> getCheckPatientTableByRegist(String registid){
		return checkResultsService.getCheckPatientTableByRegist(registid);
	}
}
