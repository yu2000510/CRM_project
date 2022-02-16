package com.bjpowernode.workbench.service.impl;

import com.bjpowernode.settings.dao.UserDao;
import com.bjpowernode.settings.domain.User;
import com.bjpowernode.utils.DateTimeUtil;
import com.bjpowernode.utils.UUIDUtil;
import com.bjpowernode.vo.PaginationVo;
import com.bjpowernode.workbench.dao.ContactsDao;
import com.bjpowernode.workbench.dao.CustomerDao;
import com.bjpowernode.workbench.dao.TranDao;
import com.bjpowernode.workbench.dao.TranHistoryDao;
import com.bjpowernode.workbench.domain.Customer;
import com.bjpowernode.workbench.domain.Tran;
import com.bjpowernode.workbench.domain.TranHistory;
import com.bjpowernode.workbench.service.TranService;
import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class TranServiceImpl implements TranService {
    @Autowired
    private TranDao tranDao;
    @Autowired
    private TranHistoryDao tranHistoryDao;
    @Autowired
    private CustomerDao customerDao;
    @Autowired
    private UserDao userDao;

    @Override
    public PaginationVo<Tran> pageList(Tran tran, String customerName, String contactsName) {
        PaginationVo<Tran> vo = new PaginationVo<>();

        List<Tran> tList = tranDao.getTranListPage(tran,customerName,contactsName);
        int total = tranDao.getTotalByCondition(tran,customerName,contactsName);

        vo.setDataList(tList);
        vo.setTotal(total);

        return vo;
    }

    @Override
    public boolean save(Tran tran, String customerName) {
        boolean flag = true;
        // 通过客户名称查询是否有该客户，若为空，则创建一个新的客户
        Customer customer = customerDao.getCustomerByName(customerName);
        if (customer == null){
            customer = new Customer();
            customer.setId(UUIDUtil.getUUID());
            customer.setName(customerName);
            customer.setOwner(tran.getOwner());
            customer.setCreateBy(tran.getCreateBy());
            customer.setCreateTime(tran.getCreateTime());
            customer.setDescription(tran.getDescription());
            customer.setNextContactTime(tran.getNextContactTime());
            customer.setContactSummary(tran.getContactSummary());

            int count = customerDao.save(customer);
            if (count != 1){
                flag = false;
            }
        }

        tran.setCustomerId(customer.getId());
        int count = tranDao.save(tran);
        if (count != 1){
            flag = false;
        }
        // 添加交易历史
        TranHistory tranHistory = new TranHistory();
        tranHistory.setId(UUIDUtil.getUUID());
        tranHistory.setTranId(tran.getId());
        tranHistory.setCreateBy(tran.getCreateBy());
        tranHistory.setCreateTime(tran.getCreateTime());
        tranHistory.setMoney(tran.getMoney());
        tranHistory.setStage(tran.getStage());
        tranHistory.setExpectedDate(tran.getExpectedDate());
        int count2 = tranHistoryDao.save(tranHistory);
        if (count2 != 1){
            flag = false;
        }

        return flag;
    }

    @Override
    public Map<String, Object> getUserListAndTran(String id) {
        Map<String, Object> map = new HashMap<>();
        List<User> uList = userDao.getUserList();
        Tran tran = tranDao.getTranById(id);
        map.put("uList",uList);
        map.put("tran",tran);

        return map;
    }

    @Override
    public boolean update(Tran tran, String customerName) {
        boolean flag = true;
        Customer customer = customerDao.getCustomerByName(customerName);
        if(customer == null){
            customer = new Customer();
            customer.setId(UUIDUtil.getUUID());
            customer.setName(customerName);
            customer.setOwner(tran.getOwner());
            customer.setCreateBy(tran.getEditBy());
            customer.setCreateTime(DateTimeUtil.getSysTime());
            customer.setDescription(tran.getDescription());
            customer.setNextContactTime(tran.getNextContactTime());
            customer.setContactSummary(tran.getContactSummary());

            int count = customerDao.save(customer);
            if (count != 1){
                flag = false;
            }
        }
        tran.setCustomerId(customer.getId());
        int count = tranDao.update(tran);
        if (count != 1){
            flag = false;
        }
        /*// 添加交易历史
        TranHistory tranHistory = new TranHistory();
        tranHistory.setId(UUIDUtil.getUUID());
        tranHistory.setTranId(tran.getId());
        tranHistory.setCreateBy(tran.getEditBy());
        tranHistory.setCreateTime(tran.getEditTime());
        tranHistory.setMoney(tran.getMoney());
        tranHistory.setStage(tran.getStage());
        tranHistory.setExpectedDate(tran.getExpectedDate());
        int count2 = tranHistoryDao.save(tranHistory);
        if (count2 != 1){
            flag = false;
        }*/
        return flag;
    }

    @Override
    public boolean delete(String[] id) {
        boolean flag = true;
        int count = tranDao.delete(id);
        if (count != id.length){
            flag = false;
        }

        return flag;
    }

    @Override
    public Tran detail(String id) {
        Tran tran = tranDao.detail(id);
        return tran;
    }

    @Override
    public List<TranHistory> getHistoryList(String tranId) {
        List<TranHistory> thList = tranHistoryDao.getHistoryListByTranId(tranId);
        return thList;
    }

    @Override
    public boolean changeStage(Tran tran) {
        boolean flag = true;
        // 改变交易阶段
        int count1 = tranDao.changeStage(tran);
        if (count1 != 1){
            flag = false;
        }
        TranHistory th = new TranHistory();
        th.setId(UUIDUtil.getUUID());
        th.setTranId(tran.getId());
        th.setCreateBy(tran.getEditBy());
        th.setCreateTime(tran.getEditTime());
        th.setMoney(tran.getMoney());
        th.setStage(tran.getStage());
        th.setExpectedDate(tran.getExpectedDate());
        // 添加交易历史
        int count2 = tranHistoryDao.save(th);
        if (count2 != 1){
            flag = false;
        }

        return flag;
    }

    @Override
    public Map<String, Object> getCharts() {
        // 取得total
        int total = tranDao.getTotal();
        // 取得dataList
        List<Map<String,Object>> dataList = tranDao.getCharts();
        Map<String,Object> map = new HashMap<>();
        map.put("total",total);
        map.put("dataList",dataList);

        return map;
    }
}
