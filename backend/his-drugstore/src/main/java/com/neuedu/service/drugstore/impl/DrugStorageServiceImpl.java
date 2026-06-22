package com.neuedu.service.drugstore.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.neuedu.bean.RestBean;
import com.neuedu.mapper.DrugInfoMapper;
import com.neuedu.service.drugstore.DrugStorageService;
import com.neuedu.util.PageUtil;
@Service
public class DrugStorageServiceImpl implements DrugStorageService {
	@Autowired
	private DrugInfoMapper drugInfoMapper;

	@Override
	public RestBean getDrugInfo(Map<String, Object> map) {
		RestBean rest = new RestBean();
		rest.setList(drugInfoMapper.searchPageDrug(PageUtil.objectToInt(map)));
		rest.setTotalCount(drugInfoMapper.searchPageDrugCount(map));
		return rest;
	}

}
