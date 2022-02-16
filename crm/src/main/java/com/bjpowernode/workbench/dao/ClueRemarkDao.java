package com.bjpowernode.workbench.dao;

import com.bjpowernode.workbench.domain.ClueRemark;

import java.util.List;

public interface ClueRemarkDao {

    int getCountByIds(String[] id);

    int deleteRemarkByIds(String[] id);

    List<ClueRemark> getRemarkListByCid(String clueId);

    int saveRemark(ClueRemark remark);

    int updateRemark(ClueRemark remark);

    int deleteRemarkById(String id);
}
