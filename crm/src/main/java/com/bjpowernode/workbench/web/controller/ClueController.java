package com.bjpowernode.workbench.web.controller;

import com.bjpowernode.settings.domain.User;
import com.bjpowernode.settings.service.UserService;
import com.bjpowernode.utils.DateTimeUtil;
import com.bjpowernode.utils.UUIDUtil;
import com.bjpowernode.vo.PaginationVo;
import com.bjpowernode.workbench.domain.Activity;
import com.bjpowernode.workbench.domain.Clue;
import com.bjpowernode.workbench.domain.ClueRemark;
import com.bjpowernode.workbench.domain.Tran;
import com.bjpowernode.workbench.service.ActivityService;
import com.bjpowernode.workbench.service.ClueService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Flux;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

// 线索控制器
@RestController
@RequestMapping("/workbench/clue")
public class ClueController {
    @Autowired
    private UserService userService;
    @Autowired
    private ClueService clueService;
    @Autowired
    private ActivityService activityService;
    @Autowired
    RedisTemplate redisTemplate;

    @GetMapping("/getUserList")
    public List<User> getUserList(){
        List<User> userList = userService.getUserList();
        return userList;
    }

    @PostMapping("/save")
    public Boolean save(Clue clue, HttpSession session){
        User user = (User) session.getAttribute("user");
        clue.setId(UUIDUtil.getUUID());
        clue.setCreateTime(DateTimeUtil.getSysTime());
        clue.setCreateBy(user.getName());

        boolean flag = clueService.save(clue);
        return flag;
    }

    @GetMapping("/pageList")
    public PaginationVo<Clue> pageList(Clue clue, Integer pageNo, Integer pageSize){
        PageHelper.startPage(pageNo,pageSize);
        PaginationVo<Clue> vo = clueService.pageList(clue);
        PageInfo<Clue> pageInfo = new PageInfo<>(vo.getDataList());

        return vo;
    }

    @PostMapping("/delete")
    public Boolean delete(String[] id){
        System.out.println(Arrays.toString(id));
        boolean flag = clueService.delete(id);
        return flag;
    }

    @GetMapping("/getUserListAndClue")
    public Map<String,Object> getUserListAndClue(String id){
        Map<String,Object> map = clueService.getUserListAndClue(id);
        return map;
    }

    @PostMapping("/update")
    public boolean update(Clue clue,HttpSession session){
        User user = (User) session.getAttribute("user");
        clue.setEditBy(user.getName());
        clue.setEditTime(DateTimeUtil.getSysTime());
        boolean flag = clueService.update(clue);
        return flag;
    }

    @GetMapping("/detail")
    public void detail(String id, HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Clue clue = clueService.detail(id);
        request.setAttribute("c",clue);
        request.getRequestDispatcher("/workbench/clue/detail.jsp").forward(request,response);
    }

    @GetMapping("/getRemarkListByCid")
    public List<ClueRemark> getRemarkListByCid(String clueId){
        List<ClueRemark> list = clueService.getRemarkListByCid(clueId);
        return list;
    }

    @PostMapping("/saveRemark")
    public Map<String,Object> saveRemark(ClueRemark remark,HttpSession session){
        User user = (User) session.getAttribute("user");
        remark.setId(UUIDUtil.getUUID());
        remark.setCreateTime(DateTimeUtil.getSysTime());
        remark.setCreateBy(user.getName());
        remark.setEditFlag("0");
        boolean flag = clueService.saveRemark(remark);
        Map<String,Object> map = new HashMap<>();
        map.put("success",flag);
        map.put("cr",remark);
        return map;
    }
    @PostMapping("/updateRemark")
    public Map<String,Object> updateRemark(ClueRemark remark,HttpSession session){
        User user = (User) session.getAttribute("user");
        remark.setEditFlag("1");
        remark.setEditBy(user.getName());
        remark.setEditTime(DateTimeUtil.getSysTime());
        boolean flag = clueService.updateRemark(remark);

        Map<String,Object> map = new HashMap<>();
        map.put("success",flag);
        map.put("cr",remark);
        return map;
    }
    @PostMapping("/deleteRemark")
    public boolean deleteRemark(String id){
        boolean flag = clueService.deleteRemark(id);
        return flag;
    }

    @GetMapping("/getActivityListByCid")
    public List<Activity> getActivityListByCid(String clueId){
        List<Activity> list = activityService.getActivityListByCid(clueId);
        return list;
    }

    @PostMapping("/unbund")
    public boolean unbund(String id){
        boolean flag = clueService.unbund(id);
        return flag;
    }

    @GetMapping("/getActivityByNameAndNotByCid")
    public List<Activity> getActivityByNameAndNotByCid(String aName,String clueId){
        Map<String,String> map = new HashMap<>();
        map.put("aName",aName);
        map.put("clueId",clueId);
        List<Activity> list = activityService.getActivityByNameAndNotByCid(map);

        return list;
    }

    @PostMapping("/bund")
    public boolean bund(String cid,String[] aid){
        boolean flag = clueService.bund(cid,aid);

        return flag;
    }

    @GetMapping("/getClueOnConvert")
    public void getClueOnConvert(String id,HttpServletRequest request,HttpServletResponse response) throws ServletException, IOException {
        Clue clue = clueService.getClueOnConvert(id);
        request.setAttribute("c",clue);
        request.getRequestDispatcher("/workbench/clue/convert.jsp").forward(request,response);
    }

    @GetMapping("/getActivityByName")
    public List<Activity> getActivityByName(String aName){
        List<Activity> aList = activityService.getActivityByName(aName);
        return aList;
    }

    @RequestMapping("/convert")
    public void convert(String clueId,Tran tran,
                        HttpServletRequest request,HttpServletResponse response) throws ServletException, IOException {
        boolean flag = false;
        User user = (User) request.getSession().getAttribute("user");
        // 判断是否需要添加交易
        if (tran.getMoney() != null || tran.getName() != null || tran.getExpectedDate() != null
                                    || tran.getStage() != null || tran.getActivityId() != null){
            tran.setId(UUIDUtil.getUUID());
            tran.setCreateBy(user.getName());
            tran.setCreateTime(DateTimeUtil.getSysTime());
            flag = clueService.convert(clueId,tran,user.getName());
        }else {
            flag = clueService.convert(clueId,null,user.getName());
        }

        if (flag){
            request.getRequestDispatcher("/workbench/clue/index.jsp").forward(request,response);
        }
    }
}
