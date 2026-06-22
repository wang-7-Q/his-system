package com.neuedu.controller.registration;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.neuedu.bean.RestBean;
import com.neuedu.service.registration.ExpenseChargeService;

/**
 * 窗口收费
 * @author 东软教育
 *
 */
@RestController
@CrossOrigin
public class ExpenseChargeController {
	@Autowired
	private ExpenseChargeService expenseChargeService;
	//得到未缴费数据
	@RequestMapping("searchExpenseChargePatient")
	public Map<String,Object> searchExpenseChargePatient(String case_number,String real_name){
		return expenseChargeService.searchExpenseChargePatient(case_number,real_name);
	}
	//缴费
	@RequestMapping("expenseCharge")
	public RestBean expenseCharge(@RequestBody List<Map<String,Object>> list) {
		
		return expenseChargeService.expenseCharge(list);
	}
	
	//得到已缴费数据
	@RequestMapping("searchExpenseRefundPatient")
	public Map<String,Object> searchExpenseRefundPatient(String case_number,String real_name){
		return expenseChargeService.searchExpenseRefundPatient(case_number,real_name);
	}
	//退费
	@RequestMapping("expenseRefund")
	public RestBean expenseRefund(@RequestBody List<Map<String,Object>> list) {
		
		return expenseChargeService.expenseRefund(list);
	}
	
	//得到所有数据
	@RequestMapping("searchAllPricePatient")
	public Map<String,Object> searchAllPricePatient(String case_number,String real_name){
		return expenseChargeService.searchAllPricePatient(case_number,real_name);
	}
}
