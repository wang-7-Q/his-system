package com.neuedu.service.physician.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.neuedu.bean.RestBean;
import com.neuedu.mapper.MedicalRecordMapper;
import com.neuedu.service.physician.OutPatientDiagnosisService;
@Service
public class OutPatientDiagnosisServiceImpl implements OutPatientDiagnosisService {
	@Autowired
	private MedicalRecordMapper medicalRecordMapper;

	@Override
	public RestBean outpatientDiagnosis(String register_id, String diagnosis, String cure) {
		medicalRecordMapper.updateByRegisterid(register_id,diagnosis,cure);
		RestBean rest = new RestBean();
		rest.setMsg("添加确诊信息成功");
		return rest;
	}

}
