package com.bjpowernode.settings.service;

import com.bjpowernode.exception.LoginException;
import com.bjpowernode.settings.domain.User;

import java.util.List;

public interface UserService {
    User login(String loginAct, String loginPwd, String addr) throws LoginException;

    List<User> getUserList();
}
