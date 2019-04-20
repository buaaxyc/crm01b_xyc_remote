package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.exception.ContactsException;
import com.bjpowernode.crm.utils.SqlSessionUtil;
import com.bjpowernode.crm.utils.UUIDUtil;
import com.bjpowernode.crm.workbench.dao.ContactsActivityRelationDao;
import com.bjpowernode.crm.workbench.dao.ContactsDao;
import com.bjpowernode.crm.workbench.domain.Contacts;
import com.bjpowernode.crm.workbench.domain.ContactsActivityRelation;
import com.bjpowernode.crm.workbench.service.ContactsService;

import java.util.HashMap;
import java.util.Map;

/**
 * author : 动力节点.1902.XYC
 * 2019/4/19 20:39
 */
public class ContactsServiceImpl implements ContactsService {
    private ContactsDao contactsDao = SqlSessionUtil.getSqlSession().getMapper(ContactsDao.class);
    private ContactsActivityRelationDao contactsActivityRelationDao = SqlSessionUtil.getSqlSession().getMapper(ContactsActivityRelationDao.class);


    @Override
    public Contacts detail(String id) {
        Contacts con = contactsDao.getById(id);

        return con;
    }

    @Override
    public void unbund(Map<String, String> map) throws ContactsException {
        int count = contactsActivityRelationDao.unbund(map);

        if (count != 1) {
            throw new ContactsException("解除关联失败！");
        }
    }

    @Override
    public void bund(String contactsId, String[] activityIds) throws ContactsException {

        for (String activityId : activityIds) {
            ContactsActivityRelation car = new ContactsActivityRelation();
            car.setId(UUIDUtil.getUUID());
            car.setActivityId(activityId);
            car.setContactsId(contactsId);

            int count = contactsActivityRelationDao.bund(car);

            if (count != 1) {
                throw new ContactsException("绑定关联失败！");
            }

        }

    }
}
