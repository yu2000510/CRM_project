package com.bjpowernode.web.listener;

import com.bjpowernode.settings.domain.DicValue;
import com.bjpowernode.settings.service.DicService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.context.support.WebApplicationContextUtils;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import java.util.*;

@WebListener
public class SysInitListener implements ServletContextListener {

    @Autowired
    private DicService dicService;

    @Override
    public void contextInitialized(ServletContextEvent event) {
        WebApplicationContextUtils.getRequiredWebApplicationContext(event.getServletContext())
                .getAutowireCapableBeanFactory().autowireBean(this);//必须添加的代码

        System.out.println("======上下文作用域=======");
        if (dicService != null){
            ServletContext application = event.getServletContext();
            Map<String, List<DicValue>> map = dicService.getAll();
            Set<String> set = map.keySet();
            for (String code:set) {
                List<DicValue> dv = map.get(code);
                application.setAttribute(code,dv);
            }
        }

        //-----------------------------------------------
        // 数据字典处理完成后，处理properties文件
        HashMap<String,String> pMap = new HashMap<>();
        ResourceBundle rb = ResourceBundle.getBundle("Stage2Possibility");
        Enumeration<String> keys = rb.getKeys();
        while (keys.hasMoreElements()){
            String key = keys.nextElement();
            pMap.put(key,rb.getString(key));
        }
        ServletContext application = event.getServletContext();
        application.setAttribute("pMap",pMap);
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("===========请求销毁===========");
    }
}
