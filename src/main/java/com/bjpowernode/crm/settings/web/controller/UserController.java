package com.bjpowernode.crm.settings.web.controller;

import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.settings.service.impl.UserServiceImpl;
import com.bjpowernode.crm.utils.DateTimeUtil;
import com.bjpowernode.crm.utils.MD5Util;
import com.bjpowernode.crm.utils.PrintJson;
import com.bjpowernode.crm.utils.ServiceFactory;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

/**
 * author : 动力节点.1902.XYC
 * 2019/4/9 20:24
 */
public class UserController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        if ("/settings/user/login.do".equals(path)) {
            login(request, response);
        }
    }

    private void login(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
//        String contextPath = request.getContextPath();
//        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        String loginAct = request.getParameter("loginAct");
        String loginPwd = MD5Util.getMD5(request.getParameter("loginPwd"));
        String ip = request.getRemoteAddr();

        System.out.println(loginAct);
        System.out.println(loginPwd);
        System.out.println(ip);

        UserService userService = (UserService) ServiceFactory.getService(new UserServiceImpl());

        try {
            User user = userService.login(loginAct, loginPwd, ip);
            request.getSession().setAttribute("user", user);
            PrintJson.printJsonFlag(response, true);
        } catch (Exception e) {
//            e.printStackTrace();
            String msg = e.getMessage();
            Map<String, Object> map = new HashMap<>();
            map.put("success", false);
            map.put("msg", msg);
            PrintJson.printJsonObj(response, map);
        }

//        User user = new User();
//        user.setLoginAct(loginAct);
//        user.setLoginPwd(MD5Util.getMD5(loginPwd));
//
//        UserService userService = (UserService) ServiceFactory.getService(new UserServiceImpl());
//        User u = userService.login(user);

//        if (u == null) {
        //以前在用request存储错误信息后使用请求转发做全局刷新，现在使用AJAX做局部刷新
//            request.setAttribute("error", "账号或密码不正确！");
//            request.getRequestDispatcher("/login.jsp").forward(request, response);

        //{"state":?, "error":"?"}
//            out.print("{\"state\":0, \"error\":\"账号或密码不正确！\"}");
//            return;
//        }
//
//        if (u.getExpireTime().compareTo(DateTimeUtil.getSysTime()) < 0) {
//            out.print("{\"state\":0, \"error\":\"该账号已过期！\"}");
//            return;
//        }
//
//        if ("0".equals(u.getLockState())) {
//            out.print("{\"state\":0, \"error\":\"该账号已被锁定！\"}");
//            return;
//        }

//        boolean result = u.getAllowIps().contains(ip);
        /*if (u.getAllowIps() != null && !"".equals(u.getAllowIps()) && !u.getAllowIps().contains(ip)) {
            out.print("{\"state\":0, \"error\":\"非法IP访问！\"}");
            return;
        }*/

        //为合法用户保存session
//        HttpSession session = request.getSession();
//        session.setAttribute("user", u);

        //使用AJAX进行页面跳转
//        out.print("{\"state\":1, \"error\":\"\"}");

        //不能在AJAX中使用重定向/请求转发，否则AJAX走error指向的函数
//        response.sendRedirect(contextPath + "/workbench/index.jsp");
//        request.getRequestDispatcher("/workbench/index.jsp").forward(request, response);

    }
}
