package com.neuedu.service.login.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.neuedu.mapper.EmployeeMapper;
import com.neuedu.service.login.LoginService;
import com.neuedu.util.PasswordUtil;

@Service
public class LoginServiceImpl implements LoginService {
	@Autowired
	private EmployeeMapper employeeMapper;

	@Override
	public List<Map<String, Object>> login(String username, String password) {
		// 1. Query employee by realname (no password in SQL)
		Map<String, Object> row = employeeMapper.getEmployeeByRealname(username);
		if (row == null) {
			return new ArrayList<>();
		}

		// 2. BCrypt password verification (with legacy plaintext fallback)
		String storedPassword = (String) row.get("password");
		if (!PasswordUtil.matches(password, storedPassword)) {
			return new ArrayList<>();
		}

		// 3. Return employee info (password already removed or filtered)
		Map<String, Object> result = new HashMap<>();
		result.put("id", row.get("id"));
		result.put("realname", row.get("realname"));
		result.put("deptment_id", row.get("deptment_id"));
		result.put("dept_name", row.get("dept_name"));
		result.put("dept_type", row.get("dept_type"));

		List<Map<String, Object>> list = new ArrayList<>();
		list.add(result);
		return list;
	}
}
