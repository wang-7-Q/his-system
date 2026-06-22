package com.neuedu.mapper;

import java.util.Collection;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface InspectionRequestMapper {
	
	void addInspectionRequest(String register_id, String medical_technology_id
			, String inspection_info, String inspection_position
			, String inspection_remark);

	List<Map<String, Object>> getInspectionRequestAndTechnology(Map<String, Object> map);

	int updateStateById(Integer id,String state);

	Integer getFinishInspectionCount();

	List<Map<String, Object>> getWaitInspection(String case_number, String real_name, Integer nowPageNumber,
			Integer pageSize);

	Integer getWaitInspectionCount(String case_number, String real_name);

	List<Map<String, Object>> getFinishCheck(String case_number, String real_name, Integer nowPageNumber,
			Integer pageSize);

	Integer getFinishCheckCountNumber(String case_number, String real_name);

	List<Map<String, Object>> getFinishCheckByRegistid(String id);

	Integer updateCheckInput(String id, String employee_id, String inspection_result);
}
