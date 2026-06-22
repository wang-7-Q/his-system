package com.neuedu.service.disposal;

import java.util.List;
import java.util.Map;

import com.neuedu.bean.RestBean;

public interface DisposalInputService {

	RestBean getFinishDisposal(String case_number, String real_name, Integer nowPageNumber, Integer pageSize);

	List<Map<String, Object>> getFinishDisposalByRegistid(String id);

	RestBean updateDisposalInput(String id, String employee_id, String disposal_result);

}
