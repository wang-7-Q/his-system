package com.neuedu.controller.check;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.neuedu.bean.RestBean;
import com.neuedu.service.check.CheckInputService;

/**
 * 检查管理：检查结果录入
 */
@RestController
@CrossOrigin
public class CheckInputController {
	@Autowired
	private CheckInputService checkInputSerivce;
	@RequestMapping("getFinishCheck")
	public RestBean getFinishCheck(@RequestParam("case_number")String case_number
			,@RequestParam("real_name")String real_name
			,@RequestParam("nowPageNumber")Integer nowPageNumber
			,@RequestParam("pageSize")Integer pageSize) {
		return checkInputSerivce.getFinishCheck(case_number,real_name,nowPageNumber,pageSize);
	}

	@RequestMapping("getFinishCheckByRegistid")
	public List<Map<String,Object>> getFinishCheckByRegistid(String id){
		return checkInputSerivce.getFinishCheckByRegistid(id);
	}
	
	@RequestMapping("updateCheckInput")
	public RestBean updateCheckInput(@RequestParam("id")String id
			,@RequestParam("employee_id")String employee_id
			,@RequestParam("check_result")String check_result) {
		return checkInputSerivce.updateCheckInput(id,employee_id,check_result);
	}
}
