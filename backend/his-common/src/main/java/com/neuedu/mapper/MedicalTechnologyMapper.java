package com.neuedu.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
@Mapper
public interface MedicalTechnologyMapper {

	List<Map<String, Object>> getPhysicianCheckSearch(Map<String, Object> map);

	List<Map<String, Object>> getPhysicianInspectionSearch(Map<String, Object> map);

	List<Map<String, Object>> getPhysicianDisposalSearch(Map<String, Object> map);
	
}
