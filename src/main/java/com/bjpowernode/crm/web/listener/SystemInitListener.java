package com.bjpowernode.crm.web.listener;

import com.bjpowernode.crm.settings.domain.DicValue;
import com.bjpowernode.crm.settings.service.DicService;
import com.bjpowernode.crm.settings.service.impl.DicServiceImpl;
import com.bjpowernode.crm.utils.ServiceFactory;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.util.*;

/**
 * author : 动力节点.1902.XYC
 * 2019/4/13 17:18
 */

public class SystemInitListener implements ServletContextListener {
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("初始化数据字典开始");

        ServletContext application = sce.getServletContext();
        DicService ds = (DicService) ServiceFactory.getService(new DicServiceImpl());

        Map<String, List<DicValue>> map = ds.getAll();

        Set<Map.Entry<String, List<DicValue>>> entrySet = map.entrySet();

        for (Map.Entry<String, List<DicValue>> entry : entrySet) {
            application.setAttribute(entry.getKey(), entry.getValue());
        }

        System.out.println("初始化数据字典结束");

        //提取属性文件内容，将阶段和可能性的对应关系保存到上下文域对象中
        ResourceBundle rb = ResourceBundle.getBundle("Stage2Possibility");
//        System.out.println(rb);

        Map<String, String> pMap = new HashMap<>();
        Enumeration<String> keys = rb.getKeys();

        while (keys.hasMoreElements()) {
            String stage = keys.nextElement();
            String possibility = rb.getString(stage);

            pMap.put(stage, possibility);
        }

        application.setAttribute("pMap", pMap);
    }
}
