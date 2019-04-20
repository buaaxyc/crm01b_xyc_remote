package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.utils.PrintJson;
import com.bjpowernode.crm.utils.ServiceFactory;
import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.domain.Contacts;
import com.bjpowernode.crm.workbench.service.ActivityService;
import com.bjpowernode.crm.workbench.service.ContactsService;
import com.bjpowernode.crm.workbench.service.impl.ActivityServiceImpl;
import com.bjpowernode.crm.workbench.service.impl.ContactsServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * author : 动力节点.1902.XYC
 * 2019/4/19 20:40
 */
public class ContactsController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();

        if ("/workbench/contacts/detail.do".equals(path)) {
            detail(request, response);
        } else if ("/workbench/contacts/getActivityListByContactsId.do".equals(path)) {
            getActivityListByContactsId(request, response);
        } else if ("/workbench/contacts/unbund.do".equals(path)) {
            unbund(request, response);
        } else if ("/workbench/contacts/getActivityListByNameAndNotByContactsId.do".equals(path)) {
            getActivityListByNameAndNotByContactsId(request, response);
        } else if ("/workbench/contacts/bund.do".equals(path)) {
            bund(request, response);
        }
    }

    private void bund(HttpServletRequest request, HttpServletResponse response) {
        String contactsId = request.getParameter("contactsId");
        String[] activityIds = request.getParameterValues("activityId");

        ContactsService cs = (ContactsService) ServiceFactory.getService(new ContactsServiceImpl());

        try {
            cs.bund(contactsId, activityIds);
            PrintJson.printJsonFlag(response, true);
        } catch (Exception e) {
            String msg = e.getMessage();
            Map<String, Object> map1 = new HashMap<>();
            map1.put("success", false);
            map1.put("msg", msg);
            PrintJson.printJsonObj(response, map1);
        }
    }

    private void getActivityListByNameAndNotByContactsId(HttpServletRequest request, HttpServletResponse response) {
        String aname = request.getParameter("aname");
        String contactsId = request.getParameter("contactsId");

        Map<String, String> map = new HashMap<>();
        map.put("aname", aname);
        map.put("contactsId", contactsId);

        ActivityService as = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());

        List<Activity> aList = as.getActivityListByNameAndNotByContactsId(map);

        PrintJson.printJsonObj(response, aList);
    }

    private void unbund(HttpServletRequest request, HttpServletResponse response) {
        String activityId = request.getParameter("activityId");
        String contactsId = request.getParameter("contactsId");

        Map<String, String> map = new HashMap<>();
        map.put("activityId", activityId);
        map.put("contactsId", contactsId);

        ContactsService cs = (ContactsService) ServiceFactory.getService(new ContactsServiceImpl());

        try {
            cs.unbund(map);
            PrintJson.printJsonFlag(response, true);
        } catch (Exception e) {
            String msg = e.getMessage();
            Map<String, Object> map1 = new HashMap<>();
            map1.put("success", false);
            map1.put("msg", msg);
            PrintJson.printJsonObj(response, map1);
        }
    }

    private void getActivityListByContactsId(HttpServletRequest request, HttpServletResponse response) {
        String contactsId = request.getParameter("contactsId");

        ActivityService as = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());

        List<Activity> aList = as.getActivityListByContactsId(contactsId);

        PrintJson.printJsonObj(response, aList);
    }

    private void detail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");

        ContactsService cs = (ContactsService) ServiceFactory.getService(new ContactsServiceImpl());

        Contacts con = cs.detail(id);

        request.setAttribute("con", con);
        request.getRequestDispatcher("/workbench/contacts/detail.jsp").forward(request, response);
    }
}
