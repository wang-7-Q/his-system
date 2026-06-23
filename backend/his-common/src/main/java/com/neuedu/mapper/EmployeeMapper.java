package com.neuedu.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface EmployeeMapper {

	List<Map<String, Object>> getRegistDoctorList(String deptmentId, String registLevelId);

	List<Map<String, Object>> getEmployeeByDeptid(String deptment_id);

	/**
	 * Look up employee + department by realname (no password check).
	 * Returns full row including password for service-layer BCrypt verification.
	 */
	Map<String, Object> getEmployeeByRealname(String realname);
}
