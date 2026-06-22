package com.neuedu.service.login.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.neuedu.mapper.EmployeeMapper;
import com.neuedu.service.login.LoginService;
@Service
public class LoginServiceImpl implements LoginService {
	@Autowired
	private EmployeeMapper employeeMapper;

	@Override
	public List<Map<String, Object>> login(String username, String password) {
		return employeeMapper.getEmployeeAndDeptByNamePass(username,password);
	}
}
