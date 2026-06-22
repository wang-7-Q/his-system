package com.neuedu.controller.disposal;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.neuedu.bean.RestBean;
import com.neuedu.service.disposal.DisposalInputService;

/**
 * 处置管理：处置结果录入
 */
@RestController
@CrossOrigin
public class DisposalInputController {
	@Autowired
	private DisposalInputService disposalInputService;
	@RequestMapping("getFinishDisposal")
	public RestBean getFinishDisposal(@RequestParam("case_number")String case_number
			,@RequestParam("real_name")String real_name
			,@RequestParam("nowPageNumber")Integer nowPageNumber
			,@RequestParam("pageSize")Integer pageSize) {
		return disposalInputService.getFinishDisposal(case_number,real_name,nowPageNumber,pageSize);
	}

	@RequestMapping("getFinishDisposalByRegistid")
	public List<Map<String,Object>> getFinishDisposalByRegistid(String id){
		return disposalInputService.getFinishDisposalByRegistid(id);
	}
	
	@RequestMapping("updateDisposalInput")
	public RestBean updateDisposalInput(@RequestParam("id")String id
			,@RequestParam("employee_id")String employee_id
			,@RequestParam("disposal_result")String disposal_result) {
		return disposalInputService.updateDisposalInput(id,employee_id,disposal_result);
	}
}
