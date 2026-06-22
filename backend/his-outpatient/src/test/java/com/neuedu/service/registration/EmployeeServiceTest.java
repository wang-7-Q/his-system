package com.neuedu.service.registration;

import java.util.Calendar;
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
public class EmployeeServiceTest {
	@Autowired
	private EmployeeService employeeService;
	// 10 00 10 00 10 00 00
	// 日上          二上         四上
	@Test
	public void getRegistDoctorListTest() {
		List<Map<String, Object>> list = employeeService.getRegistDoctorList("2", "1");
		System.out.println(list);
//		Calendar c = Calendar.getInstance();
//		//(c.get(Calendar.DAY_OF_WEEK)-1 : 0--6 * 2 == 0 2 4 6 8 10 12
//		int ruleDay = (c.get(Calendar.DAY_OF_WEEK)-1)*2;
//		int amOrPm = c.get(Calendar.AM_PM);
//		String ampm = amOrPm == 0 ? "上午":"下午";
//		System.out.println("现在是"+amOrPm);
//		for(Map<String, Object> emp : list) {
//			//得到排班规则
//			String weekRule = (String)emp.get("week_rule");
//			System.out.println(emp.get("realname")+"的排班是："+weekRule);
//			//是否上班
//			char cc = weekRule.charAt(ruleDay + amOrPm);
//			System.out.println(cc);
//			if(cc == '1') {
//				System.out.println(emp.get("realname")+ampm+"上班");
//			}else {
//				System.out.println(emp.get("realname")+ampm+"休息");
//			}
//		}
	}
}
