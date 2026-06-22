package com.neuedu.service.login;

import java.util.List;
import java.util.Map;

public interface LoginService {
	List<Map<String, Object>> login(String username, String password);
}
