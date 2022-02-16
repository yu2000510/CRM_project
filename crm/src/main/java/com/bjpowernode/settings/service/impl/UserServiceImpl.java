package com.bjpowernode.settings.service.impl;

import com.bjpowernode.exception.LoginException;
import com.bjpowernode.settings.dao.UserDao;
import com.bjpowernode.settings.domain.User;
import com.bjpowernode.settings.service.UserService;
import com.bjpowernode.utils.DateTimeUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class UserServiceImpl implements UserService {
    @Autowired
    private UserDao userDao;

    @Override
    public User login(String loginAct, String loginPwd, String addr) throws LoginException {
        Map<String,String> map = new HashMap<>();
        map.put("loginAct",loginAct);
        map.put("loginPwd",loginPwd);
        User user = userDao.login(map);

        if (user == null){
            throw new LoginException("账号密码错误");
        }
        // 验证失效时间
        int i = user.getExpireTime().compareTo(DateTimeUtil.getSysTime());
        if (i < 0) {
            throw new LoginException("账号已失效");
        }
        // 判断账号锁定状态
        if ("0".equals(user.getLockState())){
            throw new LoginException("账号已锁定，请联系管理员");
        }
        // 判断IP地址
        if (!user.getAllowIps().contains(addr)){
            throw new LoginException("IP地址受限");
        }

        return user;
    }


    @Override
    public List<User> getUserList() {
        return userDao.getUserList();
    }
}
