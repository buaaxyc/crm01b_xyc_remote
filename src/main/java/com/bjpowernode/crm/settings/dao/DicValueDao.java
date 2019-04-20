package com.bjpowernode.crm.settings.dao;

import com.bjpowernode.crm.settings.domain.DicValue;

import java.util.List;

/**
 * author : 动力节点.1902.XYC
 * 2019/4/13 17:26
 */
public interface DicValueDao {
    List<DicValue> getValueListByTypeCode(String typeCode);
}
