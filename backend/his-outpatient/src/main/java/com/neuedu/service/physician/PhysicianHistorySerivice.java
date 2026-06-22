package com.neuedu.service.physician;

import com.neuedu.bean.RestBean;

public interface PhysicianHistorySerivice {

	RestBean getCheckedPatient(Integer employee_id,String case_number, String real_name, Integer nowPageNumber,
			Integer pageSize);

}
