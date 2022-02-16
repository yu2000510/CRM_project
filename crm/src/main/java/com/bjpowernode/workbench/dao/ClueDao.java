package com.bjpowernode.workbench.dao;


import com.bjpowernode.workbench.domain.Clue;

import java.util.List;

public interface ClueDao {

    Clue getClueById(String id);

    int save(Clue clue);

    List<Clue> getClueByCondition(Clue clue);

    int getTotalByCondition(Clue clue);

    int deleteByIds(String[] id);

    int update(Clue clue);

    Clue getDetailById(String id);

    Clue getClueOnConvert(String id);

    int deleteById(String id);
}
