package com.neuedu.service.physician.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.neuedu.mapper.DiseaseMapper;
import com.neuedu.service.physician.PhysicianDiseaseService;
@Service
public class PhysicianDiseaseServiceImpl implements PhysicianDiseaseService {
	@Autowired
	private DiseaseMapper diseaseMapper;

	@Override
	public List<Map<String, Object>> getDisease(Map<String, Object> map) {
		return diseaseMapper.getDisease(map);
	}

}
