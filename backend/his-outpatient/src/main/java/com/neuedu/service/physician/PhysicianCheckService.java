package com.neuedu.service.physician;

import java.util.List;
import java.util.Map;

import com.neuedu.bean.RestBean;

public interface PhysicianCheckService {

	List<Map<String, Object>> getCheck(Map<String, Object> map);

	RestBean addCheckRequest(String register_id, String[] medical_technology_ids, String check_info,
			String check_position, String check_remark);

}
