package com.bjpowernode.workbench.dao;

import com.bjpowernode.workbench.domain.Tran;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

public interface TranDao {

    int save(Tran tran);

    List<Tran> getTranListPage(@Param("tran") Tran tran,
                               @Param("customerName") String customerName,
                               @Param("contactsName") String contactsName);

    int getTotalByCondition(@Param("tran") Tran tran,
                            @Param("customerName") String customerName,
                            @Param("contactsName") String contactsName);

    Tran getTranById(String id);

    int update(Tran tran);

    int delete(String[] id);

    Tran detail(String id);

    int changeStage(Tran tran);

    int getTotal();

    List<Map<String, Object>> getCharts();
}
