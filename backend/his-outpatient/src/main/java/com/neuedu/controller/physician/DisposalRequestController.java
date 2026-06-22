package com.neuedu.controller.physician;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.neuedu.bean.RestBean;
import com.neuedu.service.physician.DisposalRequestService;

/**
 * 医生看诊：处置管理
 */
@RestController
@CrossOrigin
public class DisposalRequestController {
	@Autowired
	private DisposalRequestService disposalRequestService;
	
	@RequestMapping("getDisposal")
	public List<Map<String,Object>> getDisposal(@RequestParam Map<String,Object> map){
		return disposalRequestService.getDisposal(map);
	}
	
	@RequestMapping("addDisposalRequest")
	public RestBean addDisposalRequest(@RequestParam("register_id") String register_id
			,@RequestParam("medical_technology_ids") String[] medical_technology_ids
			,@RequestParam("disposal_info") String disposal_info
			,@RequestParam("disposal_position") String disposal_position
			,@RequestParam("disposal_remark") String disposal_remark) {
		return disposalRequestService.addDisposalRequest(register_id,medical_technology_ids,disposal_info,disposal_position,disposal_remark);
	}
}
