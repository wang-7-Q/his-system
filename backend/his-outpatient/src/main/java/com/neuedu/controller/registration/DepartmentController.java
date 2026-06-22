package com.neuedu.controller.registration;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.neuedu.service.registration.DepartmentService;

@RestController
@CrossOrigin
public class DepartmentController {
	@Autowired
	private DepartmentService departmentService;
	
	@RequestMapping("/getAllDeptList")
	public List<Map<String, Object>> getAllDeptList() {
		return departmentService.getAllDeptList();
	}
}
