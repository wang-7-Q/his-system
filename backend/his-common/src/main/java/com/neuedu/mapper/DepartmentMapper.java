package com.neuedu.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
/**
 * 科室操作
 * @author 东软教育
 *
 */
@Mapper
public interface DepartmentMapper {
	//得到所有科室
	List<Map<String,Object>> getAllDeptList();

	List<Map<String, Object>> getDeptmentByType(String dept_type);
}
