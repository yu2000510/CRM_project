package com.bjpowernode.settings.service.impl;

import com.bjpowernode.settings.dao.DicTypeDao;
import com.bjpowernode.settings.dao.DicValueDao;
import com.bjpowernode.settings.domain.DicType;
import com.bjpowernode.settings.domain.DicValue;
import com.bjpowernode.settings.service.DicService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import javax.annotation.PostConstruct;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class DicServiceImpl implements DicService {
    private static final String DIC_LIST = "dtList";

    @Autowired
    private DicTypeDao dicTypeDao;
    @Autowired
    private DicValueDao dicValueDao;
    @Autowired
    RedisTemplate redisTemplate;

    @PostConstruct
    public void init(){
        loadingDivCache();
    }

    public void loadingDivCache() {
        List<DicType> list = (List<DicType>) redisTemplate.opsForValue().get(DIC_LIST);
        if (list == null){
            // 将字典类型取出
            List<DicType> dtList = dicTypeDao.getTypeList();
            redisTemplate.opsForValue().set("dtList",dtList);
            // 将字典类型遍历
            for (DicType dt:dtList) {
                // 取得每一种类型的字典类型编码
                String code = dt.getCode();
                // 根据每一个字典类型来取得字典列表
                List<DicValue> dvList = dicValueDao.getListByCode(code);
                redisTemplate.opsForValue().set(code,dvList);
            }
        }
    }

    @Override
    public Map<String, List<DicValue>> getAll() {
        Map<String, List<DicValue>> map = new HashMap<>();
        // 将字典类型取出
        List<DicType> dtList = (List<DicType>) redisTemplate.opsForValue().get(DIC_LIST);
        // 将字典类型遍历
        for (DicType dt:dtList) {
            // 取得每一种类型的字典类型编码
            String code = dt.getCode();
            // 根据每一个字典类型来取得字典列表
            List<DicValue> dvList = (List<DicValue>) redisTemplate.opsForValue().get(code);
            map.put(code,dvList);
        }
        return map;
    }


}
