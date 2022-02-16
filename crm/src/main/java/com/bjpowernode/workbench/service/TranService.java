package com.bjpowernode.workbench.service;

import com.bjpowernode.vo.PaginationVo;
import com.bjpowernode.workbench.domain.Tran;
import com.bjpowernode.workbench.domain.TranHistory;

import java.util.List;
import java.util.Map;

public interface TranService {
    boolean save(Tran tran, String customerName);

    PaginationVo<Tran> pageList(Tran tran, String customerName, String contactsName);

    Map<String, Object> getUserListAndTran(String id);

    boolean update(Tran tran, String customerName);

    boolean delete(String[] id);

    Tran detail(String id);

    List<TranHistory> getHistoryList(String tranId);

    boolean changeStage(Tran tran);

    Map<String, Object> getCharts();
}
