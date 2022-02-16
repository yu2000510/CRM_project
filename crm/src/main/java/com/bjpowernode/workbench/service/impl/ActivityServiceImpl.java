package com.bjpowernode.workbench.service.impl;

import com.bjpowernode.settings.dao.UserDao;
import com.bjpowernode.settings.domain.User;
import com.bjpowernode.vo.PaginationVo;
import com.bjpowernode.workbench.dao.ActivityDao;
import com.bjpowernode.workbench.dao.ActivityRemarkDao;
import com.bjpowernode.workbench.domain.Activity;
import com.bjpowernode.workbench.domain.ActivityRemark;
import com.bjpowernode.workbench.service.ActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class ActivityServiceImpl implements ActivityService {

    @Autowired
    private ActivityDao activityDao;
    @Autowired
    private ActivityRemarkDao activityRemarkDao;
    @Autowired
    private UserDao userDao;

    @Override
    public boolean save(Activity activity) {
        boolean flag = true;

        Integer i = activityDao.save(activity);
        if (i != 1){
            flag = false;
        }
        return flag;
    }

    @Override
    public PaginationVo<Activity> pageList(Activity activity) {
        List<Activity> aList = activityDao.getActivityListByCondition(activity);
        int total = activityDao.getTotalByCondition(activity);

        PaginationVo<Activity> vo = new PaginationVo<>();
        vo.setDataList(aList);
        vo.setTotal(total);
        return vo;
    }

    @Override
    public boolean delete(String[] ids) {
        boolean flag = true;
        // 查询出需要删除的备注的数量
        int count = activityRemarkDao.getCountByIds(ids);

        // 删除备注，返回受到影响的条数（实际删除的数量）
        int count2 = activityRemarkDao.deleteByAids(ids);
        if (count != count2){
            flag = false;
        }

        // 删除市场活动
        int count3 = activityDao.deleteByIds(ids);
        if (count3 != ids.length){
            flag = false;
        }

        return flag;
    }

    @Override
    public Map<String, Object> getUserListAndActivity(String id) {
        Map<String, Object> map = new HashMap<>();
        // 取uList
        List<User> uList = userDao.getUserList();

        // 取a
        Activity a = activityDao.getActivityById(id);

        // 打包到map
        map.put("uList",uList);
        map.put("a",a);

        return map;
    }

    @Override
    public boolean update(Activity activity) {
        boolean flag = true;

        Integer i = activityDao.update(activity);
        if (i != 1){
            flag = false;
        }
        return flag;
    }

    @Override
    public Activity detail(String id) {
        Activity activity = activityDao.getDetailById(id);
        return activity;
    }

    @Override
    public List<ActivityRemark> getRemarkListByAid(String activityId) {
        List<ActivityRemark> list = activityRemarkDao.getRemarkListByAid(activityId);
        return list;
    }

    @Override
    public boolean deleteRemark(String id) {
        boolean flag = true;
        int count = activityRemarkDao.deleteRemarkById(id);
        if (count != 1){
            flag=false;
        }
        return flag;
    }

    @Override
    public boolean saveRemark(ActivityRemark remark) {
        boolean flag = true;
        int count = activityRemarkDao.saveRemark(remark);
        if (count != 1){
            flag = false;
        }
        return flag;
    }

    @Override
    public boolean updateRemark(ActivityRemark remark) {
        boolean flag = true;
        int count = activityRemarkDao.updateRemark(remark);
        if (count != 1){
            flag = false;
        }
        return flag;
    }

    @Override
    public List<Activity> getActivityListByCid(String clueId) {
        List<Activity> list = activityDao.getActivityListByCid(clueId);
        return list;
    }

    @Override
    public List<Activity> getActivityByNameAndNotByCid(Map<String, String> map) {
        List<Activity> list = activityDao.getActivityByNameAndNotByCid(map);
        return list;
    }

    @Override
    public List<Activity> getActivityByName(String aName) {
        List<Activity> aList = activityDao.getActivityByName(aName);
        return aList;
    }
}
