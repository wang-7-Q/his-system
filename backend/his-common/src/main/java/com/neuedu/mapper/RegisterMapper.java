package com.neuedu.mapper;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.web.bind.annotation.RequestParam;
@Mapper
public interface RegisterMapper {
	//根据某一个状态和姓名、病历号取得当天患者信息（分页、查询）
	List<Map<String, Object>> getPatientByState(
			@Param("employee_id")Integer employee_id,
			@Param("case_number")String case_number,
			@Param("real_name")String real_name,
			@Param("nowPageNumber")Integer nowPageNumber,
			@Param("pageSize")Integer pageSize,
			@Param("visit_state")String visit_state);
	//根据某一个状态和姓名、病历号取得当天患者数量（分页、查询）
	Integer getPatientByStateCount(
			@Param("employee_id")Integer employee_id,
			@Param("case_number")String case_number,
			@Param("real_name")String real_name,
			@Param("visit_state")String visit_state);
	
	//取得患者看诊记录（状态为1、2、3）（分页、查询）
	List<Map<String, Object>> getAllPatient(
			String case_number, 
			String real_name, 
			Integer nowPageNumber,
			Integer pageSize);
	//取得患者看诊记录数量（状态为1、2、3）（分页、查询）
	Integer getAllPatientCount(
			String case_number, 
			String real_name);
	
	//添加注册信息
	int addRegister(Map<String, Object> map);

	//已挂号数量统计    按照日期  午别 医生 统计   visit_state状态为 1、2、3
	String getAlreadyRegisterCount(String visitDate, String noon, String employeeId);
	
	//根据属性进行查询
	List<Map<String, Object>> getRegisterByProperty(Map<String, Object> map);
	
	//根据id更改患者挂号状态
	int updateStateById(Integer id, Integer visit_state);
	//得到最大病例号
	String getMaxCaseNumber();
	
	//得到退号患者信息（所有已经挂号状态为1的患者信息，分页）
	List<Map<String, Object>> getPagePatientByState(String case_number, String real_name,
			Integer nowPageNumber, Integer pageSize,Integer visit_state);
	int getPagePatientByStateCount(String case_number, String real_name,Integer visit_state);
	

	
}
