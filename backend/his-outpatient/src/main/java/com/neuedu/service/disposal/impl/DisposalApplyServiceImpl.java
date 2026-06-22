package com.neuedu.service.disposal.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.neuedu.bean.RestBean;
import com.neuedu.mapper.DisposalRequestMapper;
import com.neuedu.service.disposal.DisposalApplyService;
@Service
public class DisposalApplyServiceImpl implements DisposalApplyService {
	@Autowired
	private DisposalRequestMapper disposalRequestMapper;

	@Override
	public Integer getFinishDisposalCount() {
		return disposalRequestMapper.getFinishDisposalCount();
	}

	@Override
	public Integer getWaitDisposalCount() {
		return disposalRequestMapper.getWaitDisposalCount("","");
	}

	@Override
	public RestBean getWaitDisposal(String case_number, String real_name, Integer nowPageNumber, Integer pageSize) {
		RestBean rest = new RestBean();
		//患者信息
		List<Map<String,Object>> list = disposalRequestMapper.getWaitDisposal(case_number,real_name,nowPageNumber,pageSize);
		rest.setList(list);
		//患者总数
		Integer count = disposalRequestMapper.getWaitDisposalCount(case_number,real_name);
		rest.setTotalCount(count);
		return rest;
	}

}
