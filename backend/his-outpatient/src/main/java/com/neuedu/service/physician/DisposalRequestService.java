package com.neuedu.service.physician;

import java.util.List;
import java.util.Map;

import com.neuedu.bean.RestBean;

public interface DisposalRequestService {

	List<Map<String, Object>> getDisposal(Map<String, Object> map);

	RestBean addDisposalRequest(String register_id, String[] medical_technology_ids, String disposal_info,
			String disposal_position, String disposal_remark);

}
