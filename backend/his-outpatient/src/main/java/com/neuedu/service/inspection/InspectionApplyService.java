package com.neuedu.service.inspection;

import com.neuedu.bean.RestBean;

public interface InspectionApplyService {

	Integer getFinishInspectionCount();

	Integer getWaitInspectionCount();

	RestBean getWaitInspection(String case_number, String real_name, Integer nowPageNumber, Integer pageSize);

}
