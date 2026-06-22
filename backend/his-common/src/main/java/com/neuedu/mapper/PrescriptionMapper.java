package com.neuedu.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface PrescriptionMapper {
	//添加数据
	int insertPrescription(Map<String, Object> m);
	//根据患者id和状态，查询药品信息
	List<Map<String,Object>> getPrescriptionRequestAndDrug(Map<String, Object> map);
	//根据id将状态改变，例如从 已开立 转为 已缴费
	int updateStateById(Integer id,String drug_state);
	//根据处方属性得到患者信息 分页
	List<Map<String, Object>> getPrescriptionAndPatientByProperty(String case_number, String real_name,
			String drug_state,
			Integer nowPageNumber,
			Integer pageSize);
	int getPrescriptionAndPatientCountByProperty(String case_number, String real_name,String drug_state);
	
	
}
