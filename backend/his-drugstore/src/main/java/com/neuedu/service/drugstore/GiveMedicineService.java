package com.neuedu.service.drugstore;

import java.util.List;
import java.util.Map;

import com.neuedu.bean.RestBean;

public interface GiveMedicineService {

	RestBean getFinishPricePatient(Map<String, Object> map);

	List<Map<String, Object>> getPricePatientDrug(Integer id);

	RestBean givePatientDrugs(Integer id);

}
