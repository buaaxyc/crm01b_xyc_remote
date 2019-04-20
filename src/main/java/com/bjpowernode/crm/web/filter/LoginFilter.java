package com.bjpowernode.crm.web.filter;

import com.bjpowernode.crm.settings.domain.User;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * author : 动力节点.1902.XYC
 * 2019/4/11 12:03
 */
public class LoginFilter implements Filter {
    public void destroy() {
    }

    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain) throws ServletException, IOException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) resp;

        String contextPath = request.getContextPath();
        HttpSession session = request.getSession();
        String path = request.getServletPath();

        if ("/login.jsp".equals(path) || "/settings/user/login.do".equals(path)) {
            chain.doFilter(req, resp);
        } else {
            User user = (User) session.getAttribute("user");
            if (user != null) {
                chain.doFilter(req, resp);
            } else {
                response.sendRedirect(contextPath + "/login.jsp");
            }
        }

    }

    public void init(FilterConfig config) throws ServletException {

    }

}
