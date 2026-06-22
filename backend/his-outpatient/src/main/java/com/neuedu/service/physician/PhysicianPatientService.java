package com.neuedu.service.physician;

import java.util.Map;

import com.neuedu.bean.RestBean;

public interface PhysicianPatientService {

	Integer getFinishPatientCount(Integer employee_id);

	Integer getWaitPatientCount(Integer employee_id);

	RestBean getWaitPatient(Integer employee_id,String case_number,String real_name,Integer nowPageNumber,Integer pageSize);

	RestBean getPatientQuery(Map<String, Object> map);

	RestBean getPatientItemByItemtype(Integer register_id, String string);

}
