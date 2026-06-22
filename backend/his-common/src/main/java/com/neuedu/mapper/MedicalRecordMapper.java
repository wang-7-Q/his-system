package com.neuedu.mapper;

import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.neuedu.bean.RestBean;

@Mapper
public interface MedicalRecordMapper {
	//给病历首页保存信息
	public int addHomeMedicalRecord(Map<String,Object> map);
	//给病历首页保存疾病关联
	public int addMedicalRecordDisease(Map<String,Object> map);
	//根据registerid修改记录
	public int updateByRegisterid(String register_id, String diagnosis, String cure);
}
