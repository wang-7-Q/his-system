package com.neuedu.controller.disposal;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.neuedu.bean.RestBean;
import com.neuedu.service.disposal.DisposalApplyService;

/**
 * 检查管理：处置申请
 */
@RestController
@CrossOrigin
public class DisposalApplyController {
	@Autowired
	private DisposalApplyService disposalApplyService;
	
	@RequestMapping("getFinishDisposalCount")
	public Integer getFinishDisposalCount() {
		return disposalApplyService.getFinishDisposalCount();
	}
	
	@RequestMapping("getWaitDisposalCount")
	public Integer getWaitDisposalCount() {
		return disposalApplyService.getWaitDisposalCount();
	}
	
	@RequestMapping("getWaitDisposal")
	public RestBean getWaitDisposal(@RequestParam("case_number")String case_number,
			@RequestParam("real_name")String real_name,
			@RequestParam("nowPageNumber")Integer nowPageNumber,
			@RequestParam("pageSize")Integer pageSize){
		return disposalApplyService.getWaitDisposal(case_number,real_name,nowPageNumber,pageSize);
	}
}
