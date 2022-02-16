package com.bjpowernode.workbench.web.controller;

import com.bjpowernode.settings.domain.User;
import com.bjpowernode.settings.service.UserService;
import com.bjpowernode.utils.DateTimeUtil;
import com.bjpowernode.utils.UUIDUtil;
import com.bjpowernode.vo.PaginationVo;
import com.bjpowernode.workbench.domain.Contacts;
import com.bjpowernode.workbench.domain.Tran;
import com.bjpowernode.workbench.domain.TranHistory;
import com.bjpowernode.workbench.service.ContactsService;
import com.bjpowernode.workbench.service.CustomerService;
import com.bjpowernode.workbench.service.TranService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/workbench/transaction")
public class TranController {
    @Autowired
    private UserService userService;
    @Autowired
    private TranService tranService;
    @Autowired
    private CustomerService customerService;
    @Autowired
    private ContactsService contactsService;

    // 分页
    @GetMapping("/pageList")
    public PaginationVo<Tran> pageSize(Tran tran,String customerName,String contactsName,Integer pageNo, Integer pageSize){
        PageHelper.startPage(pageNo,pageSize);
        PaginationVo<Tran> vo = tranService.pageList(tran,customerName,contactsName);
        PageInfo<Tran> info = new PageInfo(vo.getDataList());

        return vo;
    }

    // 跳转到添加交易的页面，获取所有者
    @GetMapping("/addPage")
    public void addAndGetOwnerList(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<User> uList = userService.getUserList();
        request.setAttribute("uList",uList);
        request.getRequestDispatcher("/workbench/transaction/save.jsp")
                .forward(request,response);
    }

    // 客户名称自动补全
    @GetMapping("/getCustomerName")
    public List<String> getCustomerName(String name){
        List<String> sList = customerService.getCustomerName(name);
        return sList;
    }

    // 通过联系人名称模糊查询联系人对象
    @GetMapping("getContactsByName")
    public List<Contacts> getContactsByName(String cName){
        List<Contacts> cList = contactsService.getContactsByName(cName);
        return cList;
    }

    @PostMapping("/save")
    public void save(Tran tran,String customerName,HttpServletRequest request,HttpServletResponse response) throws IOException {
        User user = (User) request.getSession().getAttribute("user");
        tran.setId(UUIDUtil.getUUID());
        tran.setCreateTime(DateTimeUtil.getSysTime());
        tran.setCreateBy(user.getName());
        boolean flag = tranService.save(tran,customerName);
        if (flag){
            // 如果添加交易成功，重定向到添加列表页
            response.sendRedirect(request.getContextPath()+"/workbench/transaction/index.jsp");
        }
    }

    // 跳转到修改界面
    @GetMapping("/editPage")
    public void editPage(String id,HttpServletRequest request,HttpServletResponse response) throws ServletException, IOException {
        Map<String,Object> map = tranService.getUserListAndTran(id);
        request.setAttribute("map",map);

        request.getRequestDispatcher("/workbench/transaction/edit.jsp").forward(request,response);
    }

    @PostMapping("/update")
    public void update(Tran tran,String customerName,HttpServletRequest request,HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        tran.setEditBy(user.getName());
        tran.setEditTime(DateTimeUtil.getSysTime());
        boolean flag = tranService.update(tran,customerName);
        if (flag){
            response.sendRedirect(request.getContextPath()+"/workbench/transaction/index.jsp");
        }
    }

    @PostMapping("/delete")
    public boolean delete(String[] id){
        boolean flag = tranService.delete(id);
        return flag;
    }

    @GetMapping("/detail")
    public void detail(String id,HttpServletRequest request,HttpServletResponse response) throws ServletException, IOException {
        Tran tran = tranService.detail(id);
        Map<String,String> pMap = (Map<String, String>) request.getServletContext().getAttribute("pMap");
        String possibility = pMap.get(tran.getStage());
        tran.setPossibility(possibility);

        request.setAttribute("t",tran);
        request.getRequestDispatcher("/workbench/transaction/detail.jsp").forward(request,response);
    }

    @GetMapping("/getHistoryList")
    public List<TranHistory> getHistoryList(String tranId,HttpServletRequest request){
        List<TranHistory> thList = tranService.getHistoryList(tranId);
        Map<String,String> pMap = (Map<String, String>) request.getServletContext().getAttribute("pMap");
        for (TranHistory tranHistory:thList) {
            String possibility = pMap.get(tranHistory.getStage());
            tranHistory.setPossibility(possibility);
        }
        return thList;
    }

    @PostMapping("/changeStage")
    public Map<String,Object> changeStage(Tran tran,HttpServletRequest request){
        User user = (User) request.getSession().getAttribute("user");
        tran.setEditBy(user.getName());
        tran.setEditTime(DateTimeUtil.getSysTime());
        boolean flag = tranService.changeStage(tran);

        Map<String,String> pMap = (Map<String, String>) request.getServletContext().getAttribute("pMap");
        String possibility = pMap.get(tran.getStage());
        tran.setPossibility(possibility);

        Map<String,Object> map = new HashMap<>();
        map.put("success",flag);
        map.put("t",tran);
        return map;
    }

    @GetMapping("/getCharts")
    public Map<String,Object> getCharts(){
        // 取得交易阶段数量
        Map<String,Object> map = tranService.getCharts();

        return map;
    }
}
