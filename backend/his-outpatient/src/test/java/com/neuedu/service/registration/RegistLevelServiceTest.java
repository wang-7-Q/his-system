package com.neuedu.service.registration;

import java.util.List;
import java.util.Map;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

import com.neuedu.OutPatientApplication;
import com.neuedu.service.registration.impl.RegistLevelServiceImpl;
@RunWith(SpringRunner.class)
@SpringBootTest(classes=OutPatientApplication.class)
public class RegistLevelServiceTest {
	@Autowired
	private RegistLevelServiceImpl registLevelServiceImpl;
	@Test
	public void getRegistLevelList() {
		List<Map<String,Object>> list = registLevelServiceImpl.getRegistLevelList();
		System.out.println(list);
	}
}
