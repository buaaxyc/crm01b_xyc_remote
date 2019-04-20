package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.ContactsActivityRelation;

import java.util.Map;

public interface ContactsActivityRelationDao {

    int save(ContactsActivityRelation contactsActivityRelation);

    int unbund(Map<String, String> map);

    int bund(ContactsActivityRelation car);
}
