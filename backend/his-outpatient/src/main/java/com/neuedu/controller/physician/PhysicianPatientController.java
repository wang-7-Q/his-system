package com.neuedu.controller.physician;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.neuedu.bean.RestBean;
import com.neuedu.service.physician.PhysicianPatientService;
/**
 * 医生看诊：患者管理
 */
@RestController
@CrossOrigin
public class PhysicianPatientController {
	@Autowired
	private PhysicianPatientService physicianPatientService;
	//取得退号患者
	@RequestMapping("getFinishPatientCount")
	public Integer getFinishPatientCount(@RequestParam("employee_id")Integer employee_id) {
		return physicianPatientService.getFinishPatientCount(employee_id);
	}
	//取得费用查询的所有患者（状态：123），分页搜索
	@RequestMapping("getPatientQuery")
	public RestBean getPatientQuery(@RequestParam Map<String,Object> map) {
		return physicianPatientService.getPatientQuery(map);
	}
	
	@RequestMapping("getWaitPatientCount")
	public Integer getWaitPatientCount(@RequestParam("employee_id")Integer employee_id) {
		return physicianPatientService.getWaitPatientCount(employee_id);
	}
	
	@RequestMapping("getWaitPatient")
	public RestBean getWaitPatient(@RequestParam("employee_id")Integer employee_id,
			@RequestParam("case_number")String case_number,
			@RequestParam("real_name")String real_name,
			@RequestParam("nowPageNumber")Integer nowPageNumber,
			@RequestParam("pageSize")Integer pageSize){
		return physicianPatientService.getWaitPatient(employee_id,case_number,real_name,nowPageNumber,pageSize);
	}
	//得到患者所有项目
	@RequestMapping("getPatientItemByPhysician")
	public RestBean getPatientItemByPhysician(Integer register_id){
		return physicianPatientService.getPatientItemByItemtype(register_id,"所有");
	}
	
	//得到患者所有检查项目
	@RequestMapping("getPatientItemByCheck")
	public RestBean getPatientItemByCheck(Integer register_id){
		return physicianPatientService.getPatientItemByItemtype(register_id,"检查");
	}
	
	//得到患者所有检验项目
	@RequestMapping("getPatientItemByInspection")
	public RestBean getPatientItemByInspection(Integer register_id){
		return physicianPatientService.getPatientItemByItemtype(register_id,"检验");
	}
	
	//得到患者所有药品项目
	@RequestMapping("getPatientItemByDrug")
	public RestBean getPatientItemByDrug(Integer register_id){
		return physicianPatientService.getPatientItemByItemtype(register_id,"药品");
	}
	
	//得到患者所有处置项目
	@RequestMapping("getPatientItemByDisposal")
	public RestBean getPatientItemByDisposal(Integer register_id){
		return physicianPatientService.getPatientItemByItemtype(register_id,"处置");
	}
}
