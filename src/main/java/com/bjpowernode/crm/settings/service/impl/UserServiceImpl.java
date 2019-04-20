package com.bjpowernode.crm.settings.service.impl;

import com.bjpowernode.crm.exception.LoginException;
import com.bjpowernode.crm.settings.dao.UserDao;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.utils.DateTimeUtil;
import com.bjpowernode.crm.utils.SqlSessionUtil;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * author : 动力节点.1902.XYC
 * 2019/4/9 20:04
 */
public class UserServiceImpl implements UserService {
    UserDao userDao = SqlSessionUtil.getSqlSession().getMapper(UserDao.class);

//    @Override
//    public List<User> selectAll() {
//        List<User> userList = null;
//
//        userList = userDao.selectAll();
//
//        return userList;
//    }

    @Override
    public User login(String loginAct, String loginPwd, String ip) throws LoginException {
        Map<String, Object> map = new HashMap<>();
        map.put("loginAct", loginAct);
        map.put("loginPwd", loginPwd);

        User user = userDao.login(map);

        if (user == null)
            throw new LoginException("账号或密码错误！");

        if (user.getExpireTime() != null && !"".equals(user.getExpireTime()) && user.getExpireTime().compareTo(DateTimeUtil.getSysTime()) < 0)
            throw new LoginException("该账号已过期！");

        if (user.getLockState() != null && !"".equals(user.getLockState()) && "0".equals(user.getLockState()))
            throw new LoginException("该账号已锁定！");

        if (user.getAllowIps() != null && !"".equals(user.getAllowIps()) && !user.getAllowIps().contains(ip))
            throw new LoginException("IP地址受限！");

        return user;
    }

    @Override
    public List<User> getUserList() {
        List<User> uList = userDao.getUserList();

        return uList;
    }

//    @Override
//    public User login(User user) {
//        User u = null;
//
//        u = userDao.login(user);
//
//        return u;
//    }
}
