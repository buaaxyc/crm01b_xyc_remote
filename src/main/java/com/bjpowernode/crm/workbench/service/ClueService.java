package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.exception.ClueException;
import com.bjpowernode.crm.vo.PaginationVO;
import com.bjpowernode.crm.workbench.domain.Clue;
import com.bjpowernode.crm.workbench.domain.Tran;

import java.util.Map;

/**
 * author : 动力节点.1902.XYC
 * 2019/4/15 12:30
 */
public interface ClueService {
    void save(Clue c) throws ClueException;

    Clue detail(String id);

    void unbund(String id) throws ClueException;

    void bund(String clueId, String[] activityIds) throws ClueException;

    boolean convert(String clueId, Tran t, String createBy);

    PaginationVO<Clue> pageList(Map<String, Object> map);
}
