package com.neuedu.service.drugstore;

import java.util.List;
import java.util.Map;

import com.neuedu.bean.RestBean;

public interface RefundMedicineService {

	RestBean getGivePricePatient(Map<String, Object> map);

	List<Map<String, Object>> getGivePatientDrug(Integer id);

	RestBean refundPatientDrugs(Integer id);

}
