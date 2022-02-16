package com.bjpowernode.workbench.service.impl;

import com.bjpowernode.settings.dao.UserDao;
import com.bjpowernode.settings.domain.User;
import com.bjpowernode.utils.DateTimeUtil;
import com.bjpowernode.utils.UUIDUtil;
import com.bjpowernode.vo.PaginationVo;
import com.bjpowernode.workbench.dao.*;
import com.bjpowernode.workbench.domain.*;
import com.bjpowernode.workbench.service.ClueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class ClueServiceImpl implements ClueService {
    @Autowired
    private UserDao userDao;
    @Autowired
    private ClueDao clueDao;
    @Autowired
    private ClueRemarkDao clueRemarkDao;
    @Autowired
    private ClueActivityRelationDao clueActivityRelationDao;
    @Autowired
    private CustomerDao customerDao;
    @Autowired
    private CustomerRemarkDao customerRemarkDao;
    @Autowired
    private ContactsDao contactsDao;
    @Autowired
    private ContactsRemarkDao contactsRemarkDao;
    @Autowired
    private ContactsActivityRelationDao contactsActivityRelationDao;
    @Autowired
    private TranDao tranDao;
    @Autowired
    private TranHistoryDao tranHistoryDao;

    @Override
    public boolean save(Clue clue) {
        boolean flag = true;
        int count = clueDao.save(clue);
        if (count != 1){
            flag = false;
        }
        return flag;
    }

    @Override
    public PaginationVo<Clue> pageList(Clue clue) {
        List<Clue> cList = clueDao.getClueByCondition(clue);
        int total = clueDao.getTotalByCondition(clue);
        PaginationVo<Clue> vo = new PaginationVo<>();
        vo.setTotal(total);
        vo.setDataList(cList);
        return vo;
    }

    @Override
    public boolean delete(String[] id) {
        boolean flag = true;
        // 查询出需要删除的线索备注数量
        int count1 = clueRemarkDao.getCountByIds(id);
        // 删除备注，返回实际删除的数量
        int count2 = clueRemarkDao.deleteRemarkByIds(id);
        if (count1 != count2){
            flag = false;
        }

        // 删除线索
        int count3 = clueDao.deleteByIds(id);
        if (count3 != id.length){
            flag = false;
        }
        return flag;
    }

    @Override
    public Map<String, Object> getUserListAndClue(String id) {
        Map<String, Object> map = new HashMap<>();
        List<User> uList = userDao.getUserList();
        map.put("uList",uList);

        Clue c = clueDao.getClueById(id);
        map.put("c",c);

        return map;
    }

    @Override
    public boolean update(Clue clue) {
        boolean flag = true;
        int count = clueDao.update(clue);
        if (count != 1){
            flag = false;
        }
        return flag;
    }

    @Override
    public Clue detail(String id) {
        Clue clue = clueDao.getDetailById(id);
        return clue;
    }

    @Override
    public List<ClueRemark> getRemarkListByCid(String clueId) {
        List<ClueRemark> list = clueRemarkDao.getRemarkListByCid(clueId);
        return list;
    }

    @Override
    public boolean saveRemark(ClueRemark remark) {
        boolean flag = true;
        int count = clueRemarkDao.saveRemark(remark);
        if (count != 1){
            flag = false;
        }
        return flag;
    }

    @Override
    public boolean updateRemark(ClueRemark remark) {
        boolean flag = true;
        int count = clueRemarkDao.updateRemark(remark);
        if (count != 1){
            flag = false;
        }
        return flag;
    }

    @Override
    public boolean deleteRemark(String id) {
        boolean flag = true;
        int count = clueRemarkDao.deleteRemarkById(id);
        if (count != 1){
            flag = false;
        }
        return flag;
    }

    @Override
    public boolean unbund(String id) {
        boolean flag = true;
        int count = clueActivityRelationDao.unbund(id);
        if (count != 1){
            flag = false;
        }

        return flag;
    }

    @Override
    public boolean bund(String cid, String[] aids) {
        boolean flag = true;
        // 取得每一个aid和cid做关联
        for (String aid:aids) {
            ClueActivityRelation car = new ClueActivityRelation();
            car.setId(UUIDUtil.getUUID());
            car.setActivityId(aid);
            car.setClueId(cid);
            int count = clueActivityRelationDao.bund(car);
            if (count != 1){
                flag = false;
            }
        }
        return flag;
    }

    @Override
    public Clue getClueOnConvert(String id) {
        Clue clue = clueDao.getClueOnConvert(id);
        return clue;
    }

    // 需要创建交易的转换
    @Override
    public boolean convert(String clueId,Tran tran,String createBy) {
        String createTime = DateTimeUtil.getSysTime();
        boolean flag = true;
        // 1.通过线索id获取线索对象
        Clue clue = clueDao.getClueById(clueId);
        // 2.通过线索对象提取客户信息，当客户信息不存在的时候，新建客户（根据公司的名称精确匹配）
        Customer customer = customerDao.getCustomerByName(clue.getCompany());
        if (customer == null){
            // 如果客户为空，添加客户
            customer = new Customer();
            customer.setId(UUIDUtil.getUUID());
            customer.setCreateBy(createBy);// 创建人是从前端传过来的
            customer.setCreateTime(createTime);
            customer.setName(clue.getCompany());
            customer.setAddress(clue.getAddress());
            customer.setWebsite(clue.getWebsite());
            customer.setPhone(clue.getPhone());
            customer.setContactSummary(clue.getContactSummary());
            customer.setNextContactTime(clue.getNextContactTime());
            customer.setDescription(clue.getDescription());
            customer.setOwner(clue.getOwner());
            int count = customerDao.save(customer);
            if (count != 1){
                flag = false;
            }
        }
        // 3.通过线索对象提取联系人信息，保存联系人
        Contacts contacts = new Contacts();
        contacts.setId(UUIDUtil.getUUID());
        contacts.setCreateBy(createBy);
        contacts.setCreateTime(createTime);
        contacts.setAppellation(clue.getAppellation());
        contacts.setAddress(clue.getAddress());
        contacts.setContactSummary(clue.getContactSummary());
        contacts.setCustomerId(customer.getId());
        contacts.setDescription(clue.getDescription());
        contacts.setEmail(clue.getEmail());
        contacts.setFullname(clue.getFullname());
        contacts.setJob(clue.getJob());
        contacts.setSource(clue.getSource());
        contacts.setOwner(clue.getOwner());
        contacts.setNextContactTime(clue.getNextContactTime());
        contacts.setMphone(clue.getMphone());
        int count2 = contactsDao.save(contacts);
        if (count2 != 1){
            flag = false;
        }
        // 4.线索备注转换到客户备注以及联系人备注
        List<ClueRemark> clueRemarkList = clueRemarkDao.getRemarkListByCid(clueId);
        for (ClueRemark clueRemark:clueRemarkList) {
            // 取出备注信息
            String noteContent = clueRemark.getNoteContent();

            // 创建客户备注信息
            CustomerRemark customerRemark = new CustomerRemark();
            customerRemark.setId(UUIDUtil.getUUID());
            customerRemark.setNoteContent(noteContent);
            customerRemark.setCreateBy(createBy);
            customerRemark.setCreateTime(createTime);
            customerRemark.setCustomerId(customer.getId());
            customerRemark.setEditFlag("0");
            int count3 = customerRemarkDao.save(customerRemark);
            if (count3 != 1){
                flag = false;
            }

            // 创建联系人备注信息
            ContactsRemark contactsRemark = new ContactsRemark();
            contactsRemark.setId(UUIDUtil.getUUID());
            contactsRemark.setNoteContent(noteContent);
            contactsRemark.setCreateBy(createBy);
            contactsRemark.setCreateTime(createTime);
            contactsRemark.setContactsId(contacts.getId());
            contactsRemark.setEditFlag("0");
            int count4 = contactsRemarkDao.save(contactsRemark);
            if (count4 != 1){
                flag = false;
            }
        }
        // 5.“线索和市场活动的关联关系”转换到“联系人和市场活动的关联关系”
        List<ClueActivityRelation> clueActivityRelationList = clueActivityRelationDao.getListByCid(clueId);
        for (ClueActivityRelation clueActivityRelation:clueActivityRelationList) {

            ContactsActivityRelation contactsActivityRelation = new ContactsActivityRelation();
            contactsActivityRelation.setId(UUIDUtil.getUUID());
            contactsActivityRelation.setContactsId(contacts.getId());
            contactsActivityRelation.setActivityId(clueActivityRelation.getActivityId());
            int count5 = contactsActivityRelationDao.save(contactsActivityRelation);
            if (count5 != 1){
                flag = false;
            }
        }
        // 6.如果有创建交易的需求，创建一条交易
        if (tran != null){
            // 在controller层中，交易对象已经注入的属性有：
            // id,money,name,expectedDate,stage,activityId,createBy,createTime
            tran.setContactsId(contacts.getId());
            tran.setCustomerId(customer.getId());
            tran.setSource(clue.getSource());
            tran.setNextContactTime(clue.getNextContactTime());
            tran.setDescription(clue.getDescription());
            tran.setContactSummary(clue.getContactSummary());
            tran.setOwner(clue.getOwner());
            // 添加交易
            int count6 = tranDao.save(tran);
            if (count6 != 1){
                flag = false;
            }
            // 7.如果创建了一条交易，则创建一条该交易下的交易历史
            TranHistory tranHistory = new TranHistory();
            tranHistory.setId(UUIDUtil.getUUID());
            tranHistory.setTranId(tran.getId());
            tranHistory.setCreateBy(createBy);
            tranHistory.setCreateTime(createTime);
            tranHistory.setMoney(tran.getMoney());
            tranHistory.setStage(tran.getStage());
            tranHistory.setExpectedDate(tran.getExpectedDate());
            int count7 = tranHistoryDao.save(tranHistory);
            if (count7 != 1){
                flag = false;
            }
        }

        // 8.删除线索备注
        for (ClueRemark clueRemark:clueRemarkList) {
            int count8 = clueRemarkDao.deleteRemarkById(clueRemark.getId());
            if (count8 != 1){
                flag = false;
            }
        }
        // 9.删除线索和市场活动的关联关系
        for (ClueActivityRelation clueActivityRelation:clueActivityRelationList) {
            int count9 = clueActivityRelationDao.deleteById(clueActivityRelation.getId());
            if (count9 != 1){
                flag = false;
            }
        }
        // 10.删除线索
        int count10 = clueDao.deleteById(clueId);
        if (count10 != 1){
            flag = false;
        }

        return flag;
    }
}
