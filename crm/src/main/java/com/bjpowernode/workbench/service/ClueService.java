package com.bjpowernode.workbench.service;

import com.bjpowernode.vo.PaginationVo;
import com.bjpowernode.workbench.domain.Clue;
import com.bjpowernode.workbench.domain.ClueRemark;
import com.bjpowernode.workbench.domain.Tran;

import java.util.List;
import java.util.Map;

public interface ClueService {
    boolean save(Clue clue);

    PaginationVo<Clue> pageList(Clue clue);

    boolean delete(String[] id);

    Map<String, Object> getUserListAndClue(String id);

    boolean update(Clue clue);

    Clue detail(String id);

    List<ClueRemark> getRemarkListByCid(String clueId);

    boolean unbund(String id);

    boolean bund(String cid, String[] aid);

    Clue getClueOnConvert(String id);

    boolean saveRemark(ClueRemark remark);

    boolean updateRemark(ClueRemark remark);

    boolean deleteRemark(String id);

    boolean convert(String clueId,Tran tran,String createBy);

}
