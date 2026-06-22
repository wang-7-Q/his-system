package com.neuedu.service.disposal;

import java.util.List;
import java.util.Map;

import com.neuedu.bean.RestBean;

public interface DisposalPatientService {

	List<Map<String, Object>> getDisposalPatient(String register_id);

	List<Map<String, Object>> getDisposalPatientDept();

	List<Map<String, Object>> getDisposalPatientEmp(String deptment_id);

	RestBean updataDisposalPatient(String id, String disposal_employee_id);

}
