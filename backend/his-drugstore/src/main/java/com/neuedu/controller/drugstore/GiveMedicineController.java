package com.neuedu.controller.drugstore;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.neuedu.bean.RestBean;
import com.neuedu.service.drugstore.GiveMedicineService;

/**
 * 药库管理：发药
 *
 */
@RestController
@CrossOrigin
public class GiveMedicineController {

	@Autowired
	private GiveMedicineService giveMedicineService;
	
	@RequestMapping("getFinishPricePatient")
	public RestBean getFinishPricePatient(@RequestParam Map<String,Object> map) {
		return giveMedicineService.getFinishPricePatient(map);
	}
	
	@RequestMapping("getPricePatientDrug")
	public List<Map<String,Object>> getPricePatientDrug(Integer id) {
		return giveMedicineService.getPricePatientDrug(id);
	}
	
	@RequestMapping("givePatientDrugs")
	public RestBean givePatientDrugs(Integer id) {
		return giveMedicineService.givePatientDrugs(id);
	}
}
