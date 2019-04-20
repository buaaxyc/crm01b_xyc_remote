package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.ActivityRemark;

import java.util.List;

/**
 * author : 动力节点.1902.XYC
 * 2019/4/12 10:15
 */
public interface ActivityRemarkDao {
    int getCountByAids(String[] ids);

    int deleteByAids(String[] ids);

    List<ActivityRemark> getRemarkListByAid(String aid);

    int saveRemark(ActivityRemark ar);

    int deleteRemark(String id);

    int updateRemark(ActivityRemark ar);
}
