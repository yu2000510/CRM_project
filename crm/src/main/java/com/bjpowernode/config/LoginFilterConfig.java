package com.bjpowernode.config;

import com.bjpowernode.web.filter.LoginFilter;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class LoginFilterConfig {
    @Bean
    public FilterRegistrationBean getFilterRegistrationBean(){
        FilterRegistrationBean bean = new FilterRegistrationBean();
        bean.setFilter(new LoginFilter());
        bean.addUrlPatterns("*.jsp","/settings/**");

        return bean;
    }
}
