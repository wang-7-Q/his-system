package com.neuedu.controller.login;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.neuedu.service.login.LoginService;
/**
 * 权限管理：登录管理
 */
@RestController
@CrossOrigin
public class LoginController {
	@Autowired
	private LoginService loginService;
	@RequestMapping("login")
	public List<Map<String ,Object>> login(String username,String password){
		return loginService.login(username,password);
	}
}
