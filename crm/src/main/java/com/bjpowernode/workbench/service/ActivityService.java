package com.bjpowernode.workbench.service;

import com.bjpowernode.vo.PaginationVo;
import com.bjpowernode.workbench.domain.Activity;
import com.bjpowernode.workbench.domain.ActivityRemark;

import java.util.List;
import java.util.Map;

public interface ActivityService {

    boolean save(Activity activity);

    PaginationVo<Activity> pageList(Activity activity);

    boolean delete(String[] ids);

    Map<String, Object> getUserListAndActivity(String id);

    boolean update(Activity activity);

    Activity detail(String id);

    List<ActivityRemark> getRemarkListByAid(String activityId);

    boolean deleteRemark(String id);

    boolean saveRemark(ActivityRemark remark);

    boolean updateRemark(ActivityRemark remark);

    List<Activity> getActivityListByCid(String clueId);

    List<Activity> getActivityByNameAndNotByCid(Map<String, String> map);

    List<Activity> getActivityByName(String aName);
}
