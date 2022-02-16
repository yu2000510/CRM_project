package com.bjpowernode.crm;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

import javax.servlet.http.HttpServletRequest;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.ResourceBundle;

@SpringBootTest
class CrmApplicationTests {

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

}
