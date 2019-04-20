package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.exception.ActivityException;
import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.vo.PaginationVO;
import com.bjpowernode.crm.workbench.domain.ActivityRemark;

import java.util.List;
import java.util.Map;

/**
 * author : 动力节点.1902.XYC
 * 2019/4/11 19:05
 */
public interface ActivityService {

    void save(Activity a) throws ActivityException;

    PaginationVO<Activity> pageList(Map<String, Object> map);

    void delete(String[] ids) throws ActivityException;

    Map<String, Object> getUserListAndActivity(String id);

    void update(Activity a) throws ActivityException;

    Activity detail(String id);

    List<ActivityRemark> getRemarkListByAid(String aid);

    void saveRemark(ActivityRemark ar) throws ActivityException;

    void deleteRemark(String id) throws ActivityException;

    void updateRemark(ActivityRemark ar) throws ActivityException;

    List<Activity> getActivityListByCid(String cid);

    List<Activity> getActivityListByNameAndNotByClueId(Map<String, String> map);

    List<Activity> getActivityListByName(String aname);

    List<Activity> getActivityListByContactsId(String contactsId);

    List<Activity> getActivityListByNameAndNotByContactsId(Map<String, String> map);
}
