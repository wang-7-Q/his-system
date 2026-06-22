package com.neuedu.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface RegistLevelMapper {
	//得到所有挂号级别
	List<Map<String,Object>> getRegistLevelList();
    
}
