package com.bjpowernode.settings.web.controller;

import com.bjpowernode.settings.domain.User;
import com.bjpowernode.settings.service.UserService;
import com.bjpowernode.utils.MD5Util;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/settings/user")
public class UserController {

    @Autowired
    UserService userService;

    @PostMapping("/login")
    @ResponseBody
    public Map<String,Object> login(String loginAct, String loginPwd,
                                    HttpServletRequest request, HttpSession session){
        String addr = request.getRemoteAddr();
        Map<String,Object> map = new HashMap<>();
        try{
            loginPwd = MD5Util.getMD5(loginPwd);
            User user = userService.login(loginAct, loginPwd, addr);
            session.setAttribute("user",user);
            map.put("sucess",true);
        }catch (Exception e){
            e.printStackTrace();
            map.put("sucess",false);
            map.put("msg",e.getMessage());
        }
        return map;
    }
}
