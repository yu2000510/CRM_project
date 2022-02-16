package com.bjpowernode.web.filter;

import com.bjpowernode.settings.domain.User;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class LoginFilter implements Filter {
    @Override
    public void doFilter(ServletRequest servletRequest,
                         ServletResponse servletResponse,
                         FilterChain filterChain) throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) servletRequest;
        HttpServletResponse response = (HttpServletResponse) servletResponse;
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        String path = request.getServletPath();
        if ("/login.jsp".equals(path) || "/settings/user/login".equals(path)){
            filterChain.doFilter(servletRequest,servletResponse);
        }else {
            if (user != null){
                filterChain.doFilter(servletRequest,servletResponse);
            }else {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
            }
        }

    }
}
