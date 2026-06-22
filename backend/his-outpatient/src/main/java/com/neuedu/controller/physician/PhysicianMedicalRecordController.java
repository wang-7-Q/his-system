package com.neuedu.controller.physician;

import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.neuedu.service.physician.PhysicianMedicalRecord;

/**
 * 医生看诊：病历管理
 */
@RestController
@CrossOrigin
public class PhysicianMedicalRecordController {
	@Autowired
	private PhysicianMedicalRecord physicianMedicalRecord;
	
	@RequestMapping("addHomeMedicalRecord")
	public String addHomeMedicalRecord(@RequestParam Map<String,Object> map) {
//		System.out.println(map);
		String s = physicianMedicalRecord.addHomeMedicalRecord(map);
		return s;
	}
}
