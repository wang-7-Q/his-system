package com.neuedu.controller.inspection;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.neuedu.bean.RestBean;
import com.neuedu.service.inspection.InspectionInputService;

/**
 * 检查管理：检查结果录入
 */
@RestController
@CrossOrigin
public class InspectionInputController {
	@Autowired
	private InspectionInputService inspectionInputSerivce;
	@RequestMapping("getFinishInspection")
	public RestBean getFinishInspection(@RequestParam("case_number")String case_number
			,@RequestParam("real_name")String real_name
			,@RequestParam("nowPageNumber")Integer nowPageNumber
			,@RequestParam("pageSize")Integer pageSize) {
		return inspectionInputSerivce.getFinishInspection(case_number,real_name,nowPageNumber,pageSize);
	}

	@RequestMapping("getFinishInspectionByRegistid")
	public List<Map<String,Object>> getFinishInspectionByRegistid(String id){
		return inspectionInputSerivce.getFinishInspectionByRegistid(id);
	}
	
	@RequestMapping("updateInspectionInput")
	public RestBean updateInspectionInput(@RequestParam("id")String id
			,@RequestParam("employee_id")String employee_id
			,@RequestParam("inspection_result")String inspection_result) {
		return inspectionInputSerivce.updateInspectionInput(id,employee_id,inspection_result);
	}
}
