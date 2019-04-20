package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.exception.ClueException;
import com.bjpowernode.crm.utils.DateTimeUtil;
import com.bjpowernode.crm.utils.SqlSessionUtil;
import com.bjpowernode.crm.utils.UUIDUtil;
import com.bjpowernode.crm.vo.PaginationVO;
import com.bjpowernode.crm.workbench.dao.*;
import com.bjpowernode.crm.workbench.domain.*;
import com.bjpowernode.crm.workbench.service.ClueService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * author : 动力节点.1902.XYC
 * 2019/4/15 12:30
 */
public class ClueServiceImpl implements ClueService {
    private ClueDao clueDao = SqlSessionUtil.getSqlSession().getMapper(ClueDao.class);
    private ClueRemarkDao clueRemarkDao = SqlSessionUtil.getSqlSession().getMapper(ClueRemarkDao.class);
    private ClueActivityRelationDao clueActivityRelationDao = SqlSessionUtil.getSqlSession().getMapper(ClueActivityRelationDao.class);

    private CustomerDao customerDao = SqlSessionUtil.getSqlSession().getMapper(CustomerDao.class);
    private CustomerRemarkDao customerRemarkDao = SqlSessionUtil.getSqlSession().getMapper(CustomerRemarkDao.class);

    private ContactsDao contactsDao = SqlSessionUtil.getSqlSession().getMapper(ContactsDao.class);
    private ContactsRemarkDao contactsRemarkDao = SqlSessionUtil.getSqlSession().getMapper(ContactsRemarkDao.class);
    private ContactsActivityRelationDao contactsActivityRelationDao = SqlSessionUtil.getSqlSession().getMapper(ContactsActivityRelationDao.class);

    private TranDao tranDao = SqlSessionUtil.getSqlSession().getMapper(TranDao.class);
    private TranHistoryDao tranHistoryDao = SqlSessionUtil.getSqlSession().getMapper(TranHistoryDao.class);


    @Override
    public void save(Clue c) throws ClueException {
        int count = clueDao.save(c);

        if (count != 1) {
            throw new ClueException("线索添加失败！");
        }
    }

    @Override
    public Clue detail(String id) {
        Clue c = clueDao.detail(id);

        return c;
    }

    @Override
    public void unbund(String id) throws ClueException {
        int count = clueActivityRelationDao.unbund(id);

        if (count != 1) {
            throw new ClueException("线索解绑失败！");
        }
    }

    @Override
    public void bund(String clueId, String[] activityIds) throws ClueException {
        for (String activityId : activityIds) {
            Map<String, String> map = new HashMap<>();

            ClueActivityRelation car = new ClueActivityRelation();
            car.setId(UUIDUtil.getUUID());
            car.setClueId(clueId);
            car.setActivityId(activityId);

            int count = clueActivityRelationDao.bund(car);

            if (count != 1) {
                throw new ClueException("线索绑定失败！");
            }
        }
    }

    @Override
    public boolean convert(String clueId, Tran t, String createBy) {
        boolean flag = true;

        String createTime = DateTimeUtil.getSysTime();


        //1)根据clueId得到线索对象
        Clue c = clueDao.getById(clueId);

        //2)当客户不存在时，创建并保存客户
        Customer cus = customerDao.getCustomerbyName(c.getCompany());

        if (cus == null) {
            cus = new Customer();
            cus.setId(UUIDUtil.getUUID());
            cus.setOwner(c.getOwner());
            cus.setName(c.getCompany());
            cus.setWebsite(c.getWebsite());
            cus.setPhone(c.getPhone());
            cus.setCreateBy(createBy);
            cus.setCreateTime(createTime);
            cus.setContactSummary(c.getContactSummary());
            cus.setNextContactTime(c.getNextContactTime());
            cus.setDescription(c.getDescription());
            cus.setAddress(c.getAddress());

            int count1 = customerDao.save(cus);

            if (count1 != 1) {
                flag = false;
            }
        }

        //3)创建并保存联系人
        Contacts con = new Contacts();
        con.setId(UUIDUtil.getUUID());
        con.setOwner(c.getOwner());
        con.setSource(c.getSource());
        con.setCustomerId(cus.getId());
        con.setFullname(c.getFullname());
        con.setAppellation(c.getAppellation());
        con.setEmail(c.getEmail());
        con.setMphone(c.getMphone());
        con.setJob(c.getJob());
        con.setCreateBy(createBy);
        con.setCreateTime(createTime);
        con.setDescription(c.getDescription());
        con.setContactSummary(c.getContactSummary());
        con.setNextContactTime(c.getNextContactTime());
        con.setAddress(c.getAddress());

        int count2 = contactsDao.save(con);

        if (count2 != 1) {
            flag = false;
        }

        //4)根据clueId查询线索备注，将所有线索备注分别转换为客户备注和联系人备注
        List<ClueRemark> clueRemarkList = clueRemarkDao.getRemarkListByClueId(clueId);

        for (ClueRemark clueRemark : clueRemarkList) {

            CustomerRemark customerRemark = new CustomerRemark();
            customerRemark.setId(UUIDUtil.getUUID());
            customerRemark.setNoteContent(clueRemark.getNoteContent());
            customerRemark.setCreateBy(createBy);
            customerRemark.setCreateTime(createTime);
            customerRemark.setEditFlag("0");
            customerRemark.setCustomerId(cus.getId());

            int count3 = customerRemarkDao.save(customerRemark);

            if (count3 != 1) {
                flag = false;
            }

            ContactsRemark contactsRemark = new ContactsRemark();
            contactsRemark.setId(UUIDUtil.getUUID());
            contactsRemark.setNoteContent(clueRemark.getNoteContent());
            contactsRemark.setCreateBy(createBy);
            contactsRemark.setCreateTime(createTime);
            contactsRemark.setEditFlag("0");
            contactsRemark.setContactsId(cus.getId());

            int count4 = contactsRemarkDao.save(contactsRemark);

            if (count4 != 1) {
                flag = false;
            }
        }

        //5)将线索市场活动关联转换为联系人市场活动关联
        List<ClueActivityRelation> clueActivityRelationList = clueActivityRelationDao.getRelationListByClueId(clueId);

        for (ClueActivityRelation clueActivityRelation : clueActivityRelationList) {
            ContactsActivityRelation contactsActivityRelation = new ContactsActivityRelation();
            contactsActivityRelation.setId(UUIDUtil.getUUID());
            contactsActivityRelation.setContactsId(con.getId());
            contactsActivityRelation.setActivityId(clueActivityRelation.getActivityId());

            int count5 = contactsActivityRelationDao.save(contactsActivityRelation);

            if (count5 != 1) {
                flag = false;
            }
        }

        //6)如果有创建交易需求，将线索、客户、联系人转换为交易并保存
        if (t != null) {
            t.setOwner(c.getOwner());
            t.setCustomerId(cus.getId());
            t.setSource(c.getSource());
            t.setContactsId(con.getId());
            t.setDescription(c.getDescription());
            t.setContactSummary(c.getContactSummary());
            t.setNextContactTime(c.getNextContactTime());

            int count6 = tranDao.save(t);

            if (count6 != 1) {
                flag = false;
            }

            //7)创建并保存交易历史
            TranHistory th = new TranHistory();
            th.setId(UUIDUtil.getUUID());
            th.setStage(t.getStage());
            th.setMoney(t.getMoney());
            th.setExpectedDate(t.getExpectedDate());
            th.setCreateTime(createTime);
            th.setCreateBy(createBy);
            th.setTranId(t.getId());

            int count7 = tranHistoryDao.save(th);

            if (count7 != 1) {
                flag = false;
            }
        }

        //8)删除线索备注
        for (ClueRemark clueRemark : clueRemarkList) {

            int count8 = clueRemarkDao.delete(clueRemark);

            if (count8 != 1) {
                flag = false;
            }
        }

        //9)删除线索与市场活动关系
        for (ClueActivityRelation clueActivityRelation : clueActivityRelationList) {

            int count9 = clueActivityRelationDao.delete(clueActivityRelation);

            if (count9 != 1) {
                flag = false;
            }
        }

        //10)删除线索
        int count10 = clueDao.delete(c);

        if (count10 != 1) {
            flag = false;
        }

        return flag;
    }

    @Override
    public PaginationVO<Clue> pageList(Map<String, Object> map) {
        int total = clueDao.getTotalByCondition(map);

        List<Clue> dataList = clueDao.getClueListByCondition(map);

        PaginationVO<Clue> vo = new PaginationVO<>();
        vo.setTotal(total);
        vo.setDataList(dataList);

        return vo;
    }
}
