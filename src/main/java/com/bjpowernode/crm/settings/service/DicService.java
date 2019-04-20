package com.bjpowernode.crm.settings.service;

import com.bjpowernode.crm.settings.domain.DicValue;

import java.util.List;
import java.util.Map;

/**
 * author : 动力节点.1902.XYC
 * 2019/4/13 17:27
 */
public interface DicService {
    Map<String, List<DicValue>> getAll();
}
