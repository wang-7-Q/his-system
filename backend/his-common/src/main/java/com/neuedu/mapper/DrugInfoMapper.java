package com.neuedu.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface DrugInfoMapper {
	//根据药品名称和拼音助记码进行模糊查询
	List<Map<String, Object>> searchDrug(Map<String, Object> map);

	//根据药品名称和拼音助记码进行模糊查询(分页)
	List<Map<String, Object>> searchPageDrug(Map<String, Object> map);
	int searchPageDrugCount(Map<String, Object> map);


}
