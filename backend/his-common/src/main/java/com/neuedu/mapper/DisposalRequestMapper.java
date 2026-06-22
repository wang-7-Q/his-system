package com.neuedu.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
//处置申请
@Mapper
public interface DisposalRequestMapper {
	//根据患者id得到医生开具的处置申请信息和检查项目信息
	List<Map<String, Object>> getDisposalRequestAndTechnology(Map<String, Object> map);

	void addDisposalRequest(String register_id, String medical_technology_id, String disposal_info,
			String disposal_position, String disposal_remark);

	Integer getFinishDisposalCount();

	Integer getWaitDisposalCount(String case_number, String real_name);

	List<Map<String, Object>> getWaitDisposal(String case_number, String real_name, Integer nowPageNumber,
			Integer pageSize);

	List<Map<String, Object>> getFinishDisposal(String case_number, String real_name, Integer nowPageNumber,
			Integer pageSize);

	Integer getFinishDisposalCountNumber(String case_number, String real_name);

	List<Map<String, Object>> getFinishDisposalByRegistid(String id);

	Integer updateCheckInput(String id, String employee_id, String disposal_result);

	Integer updateStateById(Integer id, String state);

}
