package com.neuedu.service.check;

import com.neuedu.bean.RestBean;

public interface CheckApplyService {

	Integer getFinishCheckCount();

	Integer getWaitCheckCount();

	RestBean getWaitCheck(String case_number, String real_name, Integer nowPageNumber, Integer pageSize);

}
