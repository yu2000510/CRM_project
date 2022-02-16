package com.bjpowernode.workbench.dao;

import com.bjpowernode.workbench.domain.Activity;

import java.util.List;
import java.util.Map;

public interface ActivityDao {

    Integer save(Activity activity);

    List<Activity> getActivityListByCondition(Activity activity);

    int getTotalByCondition(Activity activity);

    int deleteByIds(String[] ids);

    Activity getActivityById(String id);

    Integer update(Activity activity);

    Activity getDetailById(String id);

    List<Activity> getActivityListByCid(String clueId);

    List<Activity> getActivityByNameAndNotByCid(Map<String, String> map);

    List<Activity> getActivityByName(String aName);
}
