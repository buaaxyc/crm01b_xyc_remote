package com.bjpowernode.crm.test;

import com.bjpowernode.crm.exception.LoginException;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.settings.service.impl.UserServiceImpl;
import com.bjpowernode.crm.utils.MD5Util;
import com.bjpowernode.crm.utils.ServiceFactory;
import org.junit.Assert;
import org.junit.Test;

import java.util.List;

/**
 * author : 动力节点.1902.XYC
 * 2019/4/17 10:39
 */
public class UserTest {

    @Test
    public void testGetUserList() {
        UserService us = (UserService) ServiceFactory.getService(new UserServiceImpl());
        List<User> userList = us.getUserList();

        System.out.println(userList);

        Assert.assertNotNull(userList);
    }

    @Test
    public void testLogin() {
        UserService us = (UserService) ServiceFactory.getService(new UserServiceImpl());

        User user = null;
        try {
            user = us.login("zs", MD5Util.getMD5("123"), "127.0.0.1");
        } catch (LoginException e) {
            e.printStackTrace();
        }

        System.out.println(user);

        Assert.assertNotNull(user);
    }
}
