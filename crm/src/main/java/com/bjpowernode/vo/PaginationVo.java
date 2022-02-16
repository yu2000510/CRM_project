package com.bjpowernode.vo;

import com.bjpowernode.workbench.domain.Activity;

import java.util.List;

public class PaginationVo<T> {
    private Integer total;

    private List<T> DataList;

    public Integer getTotal() {
        return total;
    }

    public void setTotal(Integer total) {
        this.total = total;
    }

    public List<T> getDataList() {
        return DataList;
    }

    public void setDataList(List<T> dataList) {
        DataList = dataList;
    }
}
