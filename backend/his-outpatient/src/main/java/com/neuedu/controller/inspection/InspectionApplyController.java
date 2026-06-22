package com.neuedu.controller.inspection;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.neuedu.bean.RestBean;
import com.neuedu.service.check.CheckApplyService;
import com.neuedu.service.inspection.InspectionApplyService;
import com.neuedu.service.physician.PhysicianPatientService;

/**
 * 检验管理：检验申请
 */
@RestController
@CrossOrigin
public class InspectionApplyController {
	@Autowired
	private InspectionApplyService inspectionApplyService;
	
	@RequestMapping("getFinishInspectionCount")
	public Integer getFinishInspectionCount() {
		return inspectionApplyService.getFinishInspectionCount();
	}
	
	@RequestMapping("getWaitInspectionCount")
	public Integer getWaitInspectionCount() {
		return inspectionApplyService.getWaitInspectionCount();
	}
	
	@RequestMapping("getWaitInspection")
	public RestBean getWaitInspection(@RequestParam("case_number")String case_number,
			@RequestParam("real_name")String real_name,
			@RequestParam("nowPageNumber")Integer nowPageNumber,
			@RequestParam("pageSize")Integer pageSize){
		return inspectionApplyService.getWaitInspection(case_number,real_name,nowPageNumber,pageSize);
	}
}
