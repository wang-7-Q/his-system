package com.neuedu.service.physician;

import java.util.List;
import java.util.Map;

public interface CheckResultsService {

	List<Map<String, Object>> getCheckPatientTableByRegist(String registid);

}
