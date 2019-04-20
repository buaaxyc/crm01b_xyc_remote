package com.bjpowernode.crm.settings.service;

import com.bjpowernode.crm.exception.LoginException;
import com.bjpowernode.crm.settings.domain.User;

import java.util.List;

/**
 * author : 动力节点.1902.XYC
 * 2019/4/9 20:03
 */
public interface UserService {
//    List<User> selectAll();

//    User login(User user);

    User login(String loginAct, String loginPwd, String ip) throws LoginException;

    List<User> getUserList();

}
