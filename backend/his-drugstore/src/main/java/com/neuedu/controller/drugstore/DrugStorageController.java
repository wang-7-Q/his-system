package com.neuedu.controller.drugstore;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.neuedu.bean.RestBean;
import com.neuedu.service.drugstore.DrugStorageService;

/**
 * 药库管理：药库管理
 *
 */
@RestController
@CrossOrigin
public class DrugStorageController {
	@Autowired
	private DrugStorageService drugStorageService;
	
	@RequestMapping("getDrugInfo")
	public RestBean getDrugInfo(@RequestParam Map<String,Object> map) {
		return drugStorageService.getDrugInfo(map);
	}
}
