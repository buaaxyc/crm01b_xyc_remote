package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.Activity;

import java.util.List;
import java.util.Map;

/**
 * author : 动力节点.1902.XYC
 * 2019/4/11 18:59
 */
public interface ActivityDao {

    int save(Activity a);

    //    List<Activity> pageList(Map<String, Object> map);

    int getTotalByCondition(Map<String, Object> map);

    List<Activity> getActivityListByCondition(Map<String, Object> map);

    int delete(String[] ids);

    Activity getById(String id);

    int update(Activity a);

    Activity detail(String id);

    List<Activity> getActivityListByCid(String cid);

    List<Activity> getActivityListByNameAndNotByClueId(Map<String, String> map);

    List<Activity> getActivityListByName(String aname);

    List<Activity> getActivityListByContactsId(String contactsId);

    List<Activity> getActivityListByNameAndNotByContactsId(Map<String, String> map);
}
