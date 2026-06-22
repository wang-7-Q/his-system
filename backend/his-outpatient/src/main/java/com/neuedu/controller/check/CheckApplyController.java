package com.neuedu.controller.check;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.neuedu.bean.RestBean;
import com.neuedu.service.check.CheckApplyService;
import com.neuedu.service.physician.PhysicianPatientService;

/**
 * 检查管理：检查申请
 */
@RestController
@CrossOrigin
public class CheckApplyController {
	@Autowired
	private CheckApplyService checkApplyService;
	
	@RequestMapping("getFinishCheckCount")
	public Integer getFinishCheckCount() {
		return checkApplyService.getFinishCheckCount();
	}
	
	@RequestMapping("getWaitCheckCount")
	public Integer getWaitCheckCount() {
		return checkApplyService.getWaitCheckCount();
	}
	
	@RequestMapping("getWaitCheck")
	public RestBean getWaitCheck(@RequestParam("case_number")String case_number,
			@RequestParam("real_name")String real_name,
			@RequestParam("nowPageNumber")Integer nowPageNumber,
			@RequestParam("pageSize")Integer pageSize){
		return checkApplyService.getWaitCheck(case_number,real_name,nowPageNumber,pageSize);
	}
}
