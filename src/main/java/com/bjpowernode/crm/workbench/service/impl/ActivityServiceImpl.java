package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.exception.ActivityException;
import com.bjpowernode.crm.settings.dao.UserDao;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.utils.SqlSessionUtil;
import com.bjpowernode.crm.workbench.dao.ActivityDao;
import com.bjpowernode.crm.workbench.dao.ActivityRemarkDao;
import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.domain.ActivityRemark;
import com.bjpowernode.crm.workbench.service.ActivityService;
import com.bjpowernode.crm.vo.PaginationVO;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * author : 动力节点.1902.XYC
 * 2019/4/11 19:05
 */
public class ActivityServiceImpl implements ActivityService {
    private ActivityDao activityDao = SqlSessionUtil.getSqlSession().getMapper(ActivityDao.class);
    private ActivityRemarkDao activityRemarkDao = SqlSessionUtil.getSqlSession().getMapper(ActivityRemarkDao.class);
    private UserDao userDao = SqlSessionUtil.getSqlSession().getMapper(UserDao.class);

    @Override
    public void save(Activity a) throws ActivityException {
        int count = activityDao.save(a);
//        count = 0;
        if (count != 1) {
            throw new ActivityException("市场活动添加失败！");
        }
    }

    @Override
    public PaginationVO<Activity> pageList(Map<String, Object> map) {
        int total = activityDao.getTotalByCondition(map);
        List<Activity> aList = activityDao.getActivityListByCondition(map);

        PaginationVO<Activity> vo = new PaginationVO<>();
        vo.setTotal(total);
        vo.setDataList(aList);

        return vo;
    }

    @Override
    public void delete(String[] ids) throws ActivityException {
//        boolean flag = true;

        //查询需要删除的市场活动备注记录数
        int count1 = activityRemarkDao.getCountByAids(ids);
//        count1 = 1000;

        //删除市场活动备注记录
        int count2 = activityRemarkDao.deleteByAids(ids);

        if (count1 != count2) {
//            flag = false;
            throw new ActivityException("市场活动备注删除失败！");
        }

        //删除市场活动记录
        int count3 = activityDao.delete(ids);
//        count3 = 1000;//测试事务回滚

        if (count3 != ids.length) {
            throw new ActivityException("市场活动删除失败！");
        }

//        return flag;
    }

    @Override
    public Map<String, Object> getUserListAndActivity(String id) {
        List<User> uList = userDao.getUserList();
        Activity a = activityDao.getById(id);

        Map<String, Object> map = new HashMap<>();
        map.put("uList", uList);
        map.put("a", a);

        return map;
    }

    @Override
    public void update(Activity a) throws ActivityException {
        int count = activityDao.update(a);

        if (count != 1) {
            throw new ActivityException("市场活动修改失败！");
        }
    }

    @Override
    public Activity detail(String id) {
        Activity a = activityDao.detail(id);

        return a;
    }

    @Override
    public List<ActivityRemark> getRemarkListByAid(String aid) {
        List<ActivityRemark> arList = activityRemarkDao.getRemarkListByAid(aid);

        return arList;
    }

    @Override
    public void saveRemark(ActivityRemark ar) throws ActivityException {
        int count = activityRemarkDao.saveRemark(ar);

        if (count != 1) {
            throw new ActivityException("市场活动备注添加失败！");
        }
    }

    @Override
    public void deleteRemark(String id) throws ActivityException {
        int count = activityRemarkDao.deleteRemark(id);

        if (count != 1) {
            throw new ActivityException("市场活动备注删除失败！");
        }
    }

    @Override
    public void updateRemark(ActivityRemark ar) throws ActivityException {
        int count = activityRemarkDao.updateRemark(ar);

        if (count != 1) {
            throw new ActivityException("市场活动备注更新失败！");
        }
    }

    @Override
    public List<Activity> getActivityListByCid(String cid) {
        List<Activity> aList = activityDao.getActivityListByCid(cid);

        return aList;
    }

    @Override
    public List<Activity> getActivityListByNameAndNotByClueId(Map<String, String> map) {
        List<Activity> aList = activityDao.getActivityListByNameAndNotByClueId(map);

        return aList;
    }

    @Override
    public List<Activity> getActivityListByName(String aname) {
        List<Activity> aList = activityDao.getActivityListByName(aname);

        return aList;
    }

    @Override
    public List<Activity> getActivityListByContactsId(String contactsId) {
        List<Activity> aList = activityDao.getActivityListByContactsId(contactsId);

        return aList;
    }

    @Override
    public List<Activity> getActivityListByNameAndNotByContactsId(Map<String, String> map) {
        List<Activity> aList = activityDao.getActivityListByNameAndNotByContactsId(map);

        return aList;
    }
}
