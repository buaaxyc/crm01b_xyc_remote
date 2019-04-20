package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.Customer;

import java.util.List;

public interface CustomerDao {

    int save(Customer cus);

    List<String> getCustomerNameListByName(String name);

    Customer getCustomerbyName(String name);
}
