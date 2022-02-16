package com.bjpowernode.workbench.dao;

import com.bjpowernode.workbench.domain.ActivityRemark;

import java.util.List;

public interface ActivityRemarkDao {
    int getCountByIds(String[] ids);

    int deleteByAids(String[] ids);

    List<ActivityRemark> getRemarkListByAid(String activityId);

    int deleteRemarkById(String id);

    int saveRemark(ActivityRemark remark);

    int updateRemark(ActivityRemark remark);
}
