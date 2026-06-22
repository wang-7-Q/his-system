package com.neuedu.mapper;

import java.util.Collection;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface CheckRequestMapper {
	
	void addCheckRequest(String register_id, String medical_technology_id, String check_info, String check_position,
			String check_remark);
	//根据患者id得到医生开具的检查申请信息和检查项目信息
	List<Map<String, Object>> getCheckRequestAndTechnology(Map<String, Object> map);

	int updateStateById(Integer id,String state);
	//得到已经检查完成患者数量：检查状态为：已缴费、日期为：当前天数
	Integer getFinishCheckCount();
	//得到当前医生排队患者数量：检查状态为：已缴费、日期为：当前天数
	Integer getWaitCheckCount(String case_number,String real_name);
	//得到当前医生排队患者信息
	List<Map<String, Object>> getWaitCheck(String case_number, String real_name, Integer nowPageNumber,
			Integer pageSize);
	//修改数据，在对应id行添加check_employee_id
	int updataCheckPatient(String id, String check_employee_id);
	
	//完成检查患者信息(搜索、分页）检查状态为：执行完成
	List<Map<String, Object>> getFinishCheck(String case_number, String real_name, Integer nowPageNumber,
			Integer pageSize);
	//完成检查的患者数量(搜索、分页）检查状态为：执行完成
	Integer getFinishCheckCountNumber(String case_number, String real_name);
	//根据患者id得到已经检查完成的检查项目
	List<Map<String, Object>> getFinishCheckByRegistid(String id);
	//提交检查结果
	Integer updateCheckInput(String id, String employee_id, String check_result);
	
	//得到患者检查和医生检查医嘱数据，根据患者的id
	List<Map<String, Object>> getCheckPatientTableByRegist(String registid);

	
}
