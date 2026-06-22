package com.neuedu.service.registration;

import java.util.List;
import java.util.Map;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

import com.neuedu.OutPatientApplication;

@RunWith(SpringRunner.class)
@SpringBootTest(classes=OutPatientApplication.class)
public class DepartmentServiceTest {
	@Autowired
	private DepartmentService departmentService;
	@Test
	public void getAllDeptListTest() {
		List<Map<String, Object>> list = departmentService.getAllDeptList();
		System.out.println(list);
	}
}
