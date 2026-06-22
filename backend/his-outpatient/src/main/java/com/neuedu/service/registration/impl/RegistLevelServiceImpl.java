package com.neuedu.service.registration.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.neuedu.mapper.RegistLevelMapper;
import com.neuedu.service.registration.RegistLevelService;

@Service
public class RegistLevelServiceImpl implements RegistLevelService{
	@Autowired
	private RegistLevelMapper registLevelMapper;
	
	//得到所有挂号级别
	public List<Map<String,Object>> getRegistLevelList(){
		return registLevelMapper.getRegistLevelList();
	}
}
