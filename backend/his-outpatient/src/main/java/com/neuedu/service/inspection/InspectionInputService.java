package com.neuedu.service.inspection;

import java.util.List;
import java.util.Map;

import com.neuedu.bean.RestBean;

public interface InspectionInputService {

	RestBean getFinishInspection(String case_number, String real_name, Integer nowPageNumber, Integer pageSize);

	List<Map<String, Object>> getFinishInspectionByRegistid(String id);

	RestBean updateInspectionInput(String id, String employee_id, String inspection_result);

}
