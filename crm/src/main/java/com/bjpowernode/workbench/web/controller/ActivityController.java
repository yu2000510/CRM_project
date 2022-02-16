package com.bjpowernode.workbench.web.controller;

import com.bjpowernode.settings.domain.User;
import com.bjpowernode.settings.service.UserService;
import com.bjpowernode.utils.DateTimeUtil;
import com.bjpowernode.utils.UUIDUtil;
import com.bjpowernode.vo.PaginationVo;
import com.bjpowernode.workbench.domain.Activity;
import com.bjpowernode.workbench.domain.ActivityRemark;
import com.bjpowernode.workbench.service.ActivityService;
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
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/workbench/activity")
public class ActivityController {

    @Autowired
    UserService userService;

    @Autowired
    ActivityService activityService;

    @GetMapping("/getUserList")
    public List<User> getUserList(){
        List<User> uList = userService.getUserList();
        return uList;
    }

    @PostMapping("/save")
    public Boolean save(Activity activity, HttpSession session){
        User user = (User) session.getAttribute("user");
        activity.setId(UUIDUtil.getUUID());
        activity.setCreateBy(user.getName());// 创建人
        activity.setCreateTime(DateTimeUtil.getSysTime());// 创建时间
        boolean flag = activityService.save(activity);
        return flag;
    }

    @GetMapping("/pageList")
    public PaginationVo<Activity> pageList(Activity activity,Integer pageNo,Integer pageSize){
        PageHelper.startPage(pageNo,pageSize);
        PaginationVo<Activity> vo = activityService.pageList(activity);
        PageInfo<Activity> pageInfo = new PageInfo<>(vo.getDataList());

        return vo;
    }

    @PostMapping("/delete")
    public boolean delete(String[] id){
        boolean flag = activityService.delete(id);
        return flag;
    }

    @GetMapping("/getUserListAndActivity")
    public Map<String,Object> getUserListAndActivity(String id){
        Map<String,Object> map = activityService.getUserListAndActivity(id);
        return map;
    }

    @PostMapping("/update")
    public boolean update(Activity activity,HttpSession session,HttpServletRequest request){
        User user = (User) session.getAttribute("user");
        activity.setEditBy(user.getName());
        activity.setEditTime(DateTimeUtil.getSysTime());
        boolean flag = activityService.update(activity);
        request.setAttribute("a",activity);
        return flag;
    }

    @GetMapping("/detail")
    public void detail(String id, HttpServletRequest request,HttpServletResponse response) throws ServletException, IOException {
        Activity activity = activityService.detail(id);
        request.setAttribute("a",activity);
        request.getRequestDispatcher("/workbench/activity/detail.jsp").forward(request,response);
    }

    @GetMapping("/getRemarkListByAid")
    public List<ActivityRemark> getRemarkListByAid(String activityId){
        List<ActivityRemark> list = activityService.getRemarkListByAid(activityId);
        return list;
    }

    @PostMapping("/deleteRemark")
    public boolean deleteRemark(String id){
        boolean flag = activityService.deleteRemark(id);
        return flag;
    }

    @PostMapping("/saveRemark")
    public Map<String,Object> saveRemark(ActivityRemark remark,HttpSession session){
        User user = (User) session.getAttribute("user");
        remark.setId(UUIDUtil.getUUID());
        remark.setCreateTime(DateTimeUtil.getSysTime());
        remark.setCreateBy(user.getName());
        remark.setEditFlag("0");
        boolean flag = activityService.saveRemark(remark);
        Map<String,Object> map = new HashMap<>();
        map.put("success",flag);
        map.put("ar",remark);

        return map;
    }

    @PostMapping("/updateRemark")
    public Map<String,Object> updateRemark(ActivityRemark remark,HttpSession session){
        User user = (User) session.getAttribute("user");
        remark.setEditFlag("1");
        remark.setEditTime(DateTimeUtil.getSysTime());
        remark.setEditBy(user.getName());
        boolean flag = activityService.updateRemark(remark);

        Map<String,Object> map = new HashMap<>();
        map.put("success",flag);
        map.put("ar",remark);

        return map;
    }
}
