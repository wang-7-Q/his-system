package com.neuedu.service.check.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.neuedu.bean.RestBean;
import com.neuedu.mapper.CheckRequestMapper;
import com.neuedu.service.check.CheckApplyService;
@Service
public class CheckApplyServiceImpl implements CheckApplyService {
	@Autowired
	private CheckRequestMapper checkRequestMapper;

	@Override
	public Integer getFinishCheckCount() {
		return checkRequestMapper.getFinishCheckCount();
	}

	@Override
	public Integer getWaitCheckCount() {
		return checkRequestMapper.getWaitCheckCount("","");
	}

	@Override
	public RestBean getWaitCheck(String case_number, String real_name, Integer nowPageNumber, Integer pageSize) {
		RestBean rest = new RestBean();
		//患者信息
		List<Map<String,Object>> list = checkRequestMapper.getWaitCheck(case_number,real_name,nowPageNumber,pageSize);
		rest.setList(list);
		//患者总数
		Integer count = checkRequestMapper.getWaitCheckCount(case_number,real_name);
		rest.setTotalCount(count);
		return rest;
	}

}
