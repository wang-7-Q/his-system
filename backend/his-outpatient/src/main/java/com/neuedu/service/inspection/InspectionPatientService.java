package com.neuedu.service.inspection;

import java.util.List;
import java.util.Map;

import com.neuedu.bean.RestBean;

public interface InspectionPatientService {

	List<Map<String, Object>> getInspectionPatient(String register_id);

	List<Map<String, Object>> getInspectionPatientDept();

	List<Map<String, Object>> getInspectionPatientEmp(String deptment_id);

	RestBean updataInspectionPatient(String id, String inspection_employee_id);

}
