package com.neuedu.controller.physician;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.neuedu.bean.RestBean;
import com.neuedu.service.physician.OutPatientDiagnosisService;

/**
 * 医生看诊：医生确诊
 */
@RestController
@CrossOrigin
public class OutPatientDiagnosisController {
	@Autowired
	private OutPatientDiagnosisService outPatientDiagnosisService;

	@RequestMapping("outpatientDiagnosis")
	public RestBean outpatientDiagnosis(@RequestParam("register_id") String register_id
			,@RequestParam("diagnosis") String diagnosis
			,@RequestParam("cure") String cure) {
		return outPatientDiagnosisService.outpatientDiagnosis(register_id,diagnosis,cure);
	}
}
