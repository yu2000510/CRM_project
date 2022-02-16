package com.bjpowernode.workbench.dao;

import com.bjpowernode.workbench.domain.ClueActivityRelation;

import java.util.List;

public interface ClueActivityRelationDao {

    int unbund(String id);

    int bund(ClueActivityRelation car);

    List<ClueActivityRelation> getListByCid(String clueId);

    int deleteById(String id);
}
