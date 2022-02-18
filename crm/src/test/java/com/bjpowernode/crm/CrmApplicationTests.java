package com.bjpowernode.crm;

import com.bjpowernode.workbench.dao.TranDao;
import com.bjpowernode.workbench.domain.Tran;
import com.bjpowernode.workbench.domain.TranHistory;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import javax.servlet.http.HttpServletRequest;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.ResourceBundle;

@SpringBootTest
class CrmApplicationTests {
    @Autowired
    TranDao tranDao;

    @Test
    void contextLoads() {
        HashMap<String,String> pMap = new HashMap<>();
        ResourceBundle rb = ResourceBundle.getBundle("Stage2Possibility");
        Enumeration<String> keys = rb.getKeys();
        while (keys.hasMoreElements()){
            String key = keys.nextElement();
            System.out.println(key);
            pMap.put(key,rb.getString(key));
        }
    }

    @Test
    void getTranHistory(){
        Tran tran = tranDao.getTranAndHistory("上亿大交易");
        System.out.println(tran);
        List<TranHistory> list = tran.getTranHistoryList();
        for (TranHistory th:list) {
            System.out.println(th);
        }
    }

}
