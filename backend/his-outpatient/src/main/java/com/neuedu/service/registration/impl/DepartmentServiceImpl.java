package com.neuedu.service.registration.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.neuedu.mapper.DepartmentMapper;
import com.neuedu.service.registration.DepartmentService;
@Service
public class DepartmentServiceImpl implements DepartmentService {
	@Autowired
	private DepartmentMapper departmentMapper;
	
	@Override
	public List<Map<String, Object>> getAllDeptList() {
		return departmentMapper.getAllDeptList();
	}

}
