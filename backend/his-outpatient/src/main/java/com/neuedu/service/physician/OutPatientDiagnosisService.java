package com.neuedu.service.physician;

import com.neuedu.bean.RestBean;

public interface OutPatientDiagnosisService {

	RestBean outpatientDiagnosis(String register_id, String diagnosis, String cure);

}
