package com.neuedu.service.physician.impl;
import java.util.HashMap;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.neuedu.mapper.MedicalRecordMapper;
import com.neuedu.service.physician.PhysicianMedicalRecord;
@Service
public class PhysicianMedicalRecordImpl implements PhysicianMedicalRecord {
	@Autowired
	private MedicalRecordMapper medicalRecordMapper;
	//添加病历首页信息
	@Override
	public String addHomeMedicalRecord(Map<String, Object> map) {
		//添加病历首页录入信息
		medicalRecordMapper.addHomeMedicalRecord(map);
		Set<Entry<String,Object>> set = map.entrySet();
		for(Entry e : set) {			
			String keyTemp = (String)e.getKey();
			if(keyTemp.endsWith("[id]")) {
				Map<String,Object> mapd = new HashMap<>();
				mapd.put("medical_record_id", map.get("id"));
				mapd.put("disease_id", e.getValue());
				//添加病历中疾病信息
				medicalRecordMapper.addMedicalRecordDisease(mapd);
			}
		}
		return null;
	}

}
