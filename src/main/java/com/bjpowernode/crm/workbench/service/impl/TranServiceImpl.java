package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.exception.TranException;
import com.bjpowernode.crm.utils.DateTimeUtil;
import com.bjpowernode.crm.utils.SqlSessionUtil;
import com.bjpowernode.crm.utils.UUIDUtil;
import com.bjpowernode.crm.workbench.dao.CustomerDao;
import com.bjpowernode.crm.workbench.dao.TranDao;
import com.bjpowernode.crm.workbench.dao.TranHistoryDao;
import com.bjpowernode.crm.workbench.domain.Customer;
import com.bjpowernode.crm.workbench.domain.Tran;
import com.bjpowernode.crm.workbench.domain.TranHistory;
import com.bjpowernode.crm.workbench.service.TranService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * author : 动力节点.1902.XYC
 * 2019/4/16 18:49
 */
public class TranServiceImpl implements TranService {
    private TranDao tranDao = SqlSessionUtil.getSqlSession().getMapper(TranDao.class);
    private TranHistoryDao tranHistoryDao = SqlSessionUtil.getSqlSession().getMapper(TranHistoryDao.class);
    private CustomerDao customerDao = SqlSessionUtil.getSqlSession().getMapper(CustomerDao.class);

    @Override
    public boolean save(Tran t, String customerName) {
        boolean flag = true;

        //1)判断客户是否存在，如果不存在则创建新客户
        Customer cus = customerDao.getCustomerbyName(customerName);

        if (cus == null) {
            cus = new Customer();

            cus.setId(UUIDUtil.getUUID());
            cus.setOwner(t.getOwner());
            cus.setName(customerName);
            cus.setCreateBy(t.getCreateBy());
            cus.setCreateTime(DateTimeUtil.getSysTime());
            cus.setContactSummary(t.getContactSummary());
            cus.setNextContactTime(t.getNextContactTime());
            cus.setDescription(t.getDescription());
            //缺少website, phone, address字段

            int count1 = customerDao.save(cus);

            if (count1 != 1) {
                flag = false;
            }
        }

        //2)保存交易
        t.setCustomerId(cus.getId());
        int count2 = tranDao.save(t);

        if (count2 != 1) {
            flag = false;
        }

        //3)保存交易历史
        TranHistory th = new TranHistory();

        th.setId(UUIDUtil.getUUID());
        th.setStage(t.getStage());
        th.setMoney(t.getMoney());
        th.setExpectedDate(t.getExpectedDate());
        th.setCreateTime(DateTimeUtil.getSysTime());
        th.setCreateBy(t.getCreateBy());
        th.setTranId(t.getId());

        int count3 = tranHistoryDao.save(th);

        if (count3 != 1) {
            flag = false;
        }

        return flag;
    }

    @Override
    public Tran detail(String id) {
        Tran t = tranDao.detail(id);

        return t;
    }

    @Override
    public List<TranHistory> getHistoryListByTranId(String tranId) {
        List<TranHistory> thList = tranHistoryDao.getHistoryListByTranId(tranId);

        return thList;
    }

    @Override
    public void changeStage(Tran t) throws TranException {
        int count1 = tranDao.changeStage(t);

        if (count1 != 1) {
            throw new TranException("交易阶段变更失败！");
        }

        TranHistory th = new TranHistory();
        th.setId(UUIDUtil.getUUID());
        th.setStage(t.getStage());
        th.setMoney(t.getMoney());
        th.setExpectedDate(t.getExpectedDate());
        th.setCreateTime(DateTimeUtil.getSysTime());
        th.setCreateBy(t.getEditBy());
        th.setTranId(t.getId());

        int count2 = tranHistoryDao.save(th);


        if (count2 != 1) {
            throw new TranException("交易阶段变更失败！");
        }

    }

    @Override
    public Map<String, Object> getCharts() {
        int total = tranDao.getTotal();

        List<Map<String, Object>> mapList = tranDao.getCharts();

        Map<String, Object> map = new HashMap<>();

        map.put("total", total);
        map.put("dataList", mapList);

        return map;
    }
}
