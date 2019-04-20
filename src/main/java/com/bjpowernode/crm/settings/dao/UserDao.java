package com.bjpowernode.crm.settings.dao;

import com.bjpowernode.crm.settings.domain.User;

import java.util.List;
import java.util.Map;

/**
 * author : 动力节点.1902.XYC
 * 2019/4/9 19:47
 */
public interface UserDao {
//    List<User> selectAll();

    User login(Map<String, Object> map);

    List<User> getUserList();

//    User login(User user);
}
