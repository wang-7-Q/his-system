package com.neuedu.service.disposal;

import com.neuedu.bean.RestBean;

public interface DisposalApplyService {

	Integer getFinishDisposalCount();

	Integer getWaitDisposalCount();

	RestBean getWaitDisposal(String case_number, String real_name, Integer nowPageNumber, Integer pageSize);

}
