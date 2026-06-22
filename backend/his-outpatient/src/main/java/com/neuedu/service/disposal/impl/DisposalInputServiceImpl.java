package com.neuedu.service.disposal.impl;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.neuedu.bean.RestBean;
import com.neuedu.mapper.DisposalRequestMapper;
import com.neuedu.service.disposal.DisposalInputService;
@Service
public class DisposalInputServiceImpl implements DisposalInputService {
	@Autowired
	private DisposalRequestMapper disposalRequestMapper;
	@Override
	public RestBean getFinishDisposal(String case_number, String real_name, Integer nowPageNumber, Integer pageSize) {
		RestBean rest = new RestBean();
		//完成检查患者信息
		List<Map<String,Object>> list = disposalRequestMapper.getFinishDisposal(case_number,real_name,nowPageNumber,pageSize);
		rest.setList(list);
		//完成检查的患者数量		
		Integer count = disposalRequestMapper.getFinishDisposalCountNumber(case_number,real_name);
		rest.setTotalCount(count);
		return rest;
	}

	@Override
	public List<Map<String, Object>> getFinishDisposalByRegistid(String id) {
		List<Map<String,Object>> list = disposalRequestMapper.getFinishDisposalByRegistid(id);
		SimpleDateFormat smf = new SimpleDateFormat("YYYY-MM-dd hh:mm:ss");
		for(Map<String,Object> m : list) {
			Object ct = m.get("check_time");
			if(ct!=null) {
				Timestamp date = (Timestamp)ct;
				String s = smf.format(date);
				m.put("check_time", s);
			}
		}
		return list;
	}

	@Override
	public RestBean updateDisposalInput(String id, String employee_id, String disposal_result) {
		RestBean rest = new RestBean();
		disposalRequestMapper.updateCheckInput(id,employee_id,disposal_result);
		rest.setMsg("添加成功");
		return rest;
	}

}
