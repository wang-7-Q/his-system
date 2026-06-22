package com.neuedu.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface DiseaseMapper {
	
	List<Map<String, Object>> getDisease(Map<String, Object> map);

}
