package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.exception.TranException;
import com.bjpowernode.crm.workbench.domain.Tran;
import com.bjpowernode.crm.workbench.domain.TranHistory;

import java.util.List;
import java.util.Map;

/**
 * author : 动力节点.1902.XYC
 * 2019/4/16 18:48
 */
public interface TranService {
    boolean save(Tran t, String customerName);

    Tran detail(String id);

    List<TranHistory> getHistoryListByTranId(String tranId);

    void changeStage(Tran t) throws TranException;

    Map<String, Object> getCharts();
}
