package com.neuedu.service.physician.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.neuedu.bean.RestBean;
import com.neuedu.mapper.CheckRequestMapper;
import com.neuedu.mapper.DisposalRequestMapper;
import com.neuedu.mapper.InspectionRequestMapper;
import com.neuedu.mapper.PrescriptionMapper;
import com.neuedu.mapper.RegisterMapper;
import com.neuedu.service.physician.PhysicianPatientService;
import com.neuedu.util.TimestampUtil;
@Service
public class PhysicianPatientServiceImpl implements PhysicianPatientService {
	@Autowired
	private RegisterMapper registerMapper;
	@Autowired
	private CheckRequestMapper checkRequestMapper;
	@Autowired
	private InspectionRequestMapper inspectionRequestMapper;
	@Autowired
	private PrescriptionMapper prescriptionMapper;
	@Autowired
	private DisposalRequestMapper disposalRequestMapper;
	@Override
	public Integer getFinishPatientCount(Integer employee_id) {
		return registerMapper.getPatientByStateCount(employee_id,"","","4");
	}
	@Override
	public Integer getWaitPatientCount(Integer employee_id) {
		//得到当前医生排队患者数量：医生id、患者状态为：已完成（3）、日期为：当前天数
		return registerMapper.getPatientByStateCount(employee_id,"","","1");
	}
	@Override
	public RestBean getWaitPatient(Integer employee_id,String case_number,String real_name,Integer nowPageNumber,Integer pageSize) {
		RestBean restBean = new RestBean();
		//患者信息
		List<Map<String,Object>> list = registerMapper.getPatientByState(employee_id,case_number,real_name,nowPageNumber,pageSize,"1");
		restBean.setList(list);
		//患者总数
		Integer count = registerMapper.getPatientByStateCount(employee_id,case_number,real_name,"1");
		restBean.setTotalCount(count);
		return restBean;
	}
	//取得费用查询的所有患者（状态：123），分页搜索
	@Override
	public RestBean getPatientQuery(Map<String, Object> map) {
		RestBean restBean = new RestBean();
		Integer nowPageNumber = new Integer(map.get("nowPageNumber").toString());
		Integer pageSize = new Integer(map.get("pageSize").toString());
		//患者信息
		List<Map<String,Object>> list = registerMapper.getAllPatient(
				(String)map.get("case_number"),
				(String)map.get("real_name"),
				nowPageNumber,pageSize);
		restBean.setList(list);
		//患者总数
		Integer count = registerMapper.getAllPatientCount(
				(String)map.get("case_number"),
				(String)map.get("real_name"));
		restBean.setTotalCount(count);
		return restBean;
	}
	//得到患者所有项目：根据状态itemType:"所有"，"检查"，"检验"，"药品"，"处置"
	@Override
	public RestBean getPatientItemByItemtype(Integer register_id, String itemType) {
		RestBean rest = new RestBean();
		Map<String,Object> map = new HashMap<>();
		map.put("register_id", register_id);
		List<Map<String,Object>> list = new ArrayList<>();
		switch(itemType) {
		case "所有":
			list.addAll(checkRequestMapper.getCheckRequestAndTechnology(map));
			list.addAll(inspectionRequestMapper.getInspectionRequestAndTechnology(map));
			list.addAll(prescriptionMapper.getPrescriptionRequestAndDrug(map));
			list.addAll(disposalRequestMapper.getDisposalRequestAndTechnology(map));
			rest.setMsg("患者费用查询成功");
			break;
		case "检查":			
			list.addAll(checkRequestMapper.getCheckRequestAndTechnology(map));
			rest.setMsg("患者费用查询成功");
			break;
		case "检验":			
			list.addAll(inspectionRequestMapper.getInspectionRequestAndTechnology(map));
			rest.setMsg("患者费用查询成功");
			break;
		case "药品":
			list.addAll(prescriptionMapper.getPrescriptionRequestAndDrug(map));	
			rest.setMsg("患者费用查询成功");
			break;
		case "处置":
			list.addAll(disposalRequestMapper.getDisposalRequestAndTechnology(map));	
			rest.setMsg("患者费用查询成功");
			break;
		}
		TimestampUtil.formatTimestamp(list, "item_create_time");
		rest.setList(list);
		return rest;
	}
}
