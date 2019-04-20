package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.exception.ContactsException;
import com.bjpowernode.crm.workbench.domain.Contacts;

import java.util.Map;

/**
 * author : 动力节点.1902.XYC
 * 2019/4/19 20:38
 */
public interface ContactsService {
    Contacts detail(String id);

    void unbund(Map<String,String> map) throws ContactsException;

    void bund(String contactsId, String[] activityIds) throws ContactsException;
}
