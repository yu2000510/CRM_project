<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%
String basePath = request.getScheme() + "://" +
request.getServerName() + ":" + request.getServerPort() +
request.getContextPath() + "/";
%>
<html>
<head>
	<base href="<%=basePath%>">
<meta charset="UTF-8">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
    <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

    <link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
    <script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination/en.js"></script>

<script type="text/javascript">

	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault = true;
	
	$(function(){
		$("#remark").focus(function(){
			if(cancelAndSaveBtnDefault){
				//设置remarkDiv的高度为130px
				$("#remarkDiv").css("height","130px");
				//显示
				$("#cancelAndSaveBtn").show("2000");
				cancelAndSaveBtnDefault = false;
			}
		});
		
		$("#cancelBtn").click(function(){
			//显示
			$("#cancelAndSaveBtn").hide();
			//设置remarkDiv的高度为130px
			$("#remarkDiv").css("height","90px");
			cancelAndSaveBtnDefault = true;
		});
		
		$(".remarkDiv").mouseover(function(){
			$(this).children("div").children("div").show();
		});
		
		$(".remarkDiv").mouseout(function(){
			$(this).children("div").children("div").hide();
		});
		
		$(".myHref").mouseover(function(){
			$(this).children("span").css("color","red");
		});
		
		$(".myHref").mouseout(function(){
			$(this).children("span").css("color","#E6E6E6");
		});

		// 页面加载完毕后，展现该市场活动的备注信息列表
		showRemarkList();

		// 备注信息后面的编辑和删除图标
        $("#remarkBody").on("mouseover",".remarkDiv",function(){
            $(this).children("div").children("div").show();
        });
        $("#remarkBody").on("mouseout",".remarkDiv",function(){
            $(this).children("div").children("div").hide();
        });

        // 打开市场活动信息修改的模态窗口
        $("#editBtn").click(function () {
            // 日历组件，复制粘贴即可
            $(".time").datetimepicker({
                minView: "month",
                language: 'zh-CN',
                format: 'yyyy-mm-dd',
                autoclose: true,
                todayBtn: true, // 显示今天
                pickerPosition: "bottom-left" // 显示位置
            });

            $.ajax({
                url:"workbench/activity/getUserListAndActivity",
                data:{
                    "id":"${a.id}"
                },
                type:"get",
                dataType:"json",
                success:function (data) {
                    var html = "<option></option>";
                    $.each(data.uList,function (i,n) {
                        html += "<option value='"+n.id+"'>"+n.name+"</option>"
                    });
                    $("#edit-owner").html(html);

                    $("#edit-id").val(data.a.id);
                    $("#edit-name").val(data.a.name);
                    $("#edit-owner").val(data.a.owner);
                    $("#edit-startDate").val(data.a.startDate);
                    $("#edit-endDate").val(data.a.endDate);
                    $("#edit-cost").val(data.a.cost);
                    $("#edit-description").val(data.a.description);
                }
            });
            $("#editActivityModal").modal("show")
        });

        // 使用删除按钮删除市场活动并返回原来的页面
        $("#deleteBtn").click(function () {
            if (confirm("确定删除该市场活动信息")){
                $.ajax({
                    url:"workbench/activity/delete",
                    data:{
                        "id":"${a.id}"
                    },
                    type:"post",
                    dataType:"json",
                    success:function(data){
                        document.location.href="workbench/activity/index.jsp"
                    }
                });
            }
        });

        // 修改市场模态窗口并关闭
        $("#updateBtn").click(function () {
            $.ajax({
                url:"workbench/activity/update",
                data:{
                    "id":"${a.id}",
                    "owner":$.trim($("#edit-owner").val()),
                    "name":$.trim($("#edit-name").val()),
                    "startDate":$.trim($("#edit-startDate").val()),
                    "endDate":$.trim($("#edit-endDate").val()),
                    "cost":$.trim($("#edit-cost").val()),
                    "description":$.trim($("#edit-description").val())
                },
                type:"post",
                dataType:"json",
                success:function (data) {
                    // 刷新详细信息页的活动信息
                    window.location.reload()
                }
            });
            $("#editActivityModal").modal("hide")
        });

        $("#saveRemarkBtn").click(function () {
            $.ajax({
                url:"workbench/activity/saveRemark",
                data:{
                    "noteContent":$.trim($("#remark").val()),
                    "activityId":"${a.id}"
                },
                type:"post",
                dataType:"json",
                success:function (data) {
                    if (data.success){
                        // 添加成功

                        // 文本域中的内容清空掉
                        $("#remark").val("");

                        var html = "";
                        html += '<div id='+data.ar.id+' class="remarkDiv" style="height: 60px;">';
                        html += '<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
                        html += '<div style="position: relative; top: -40px; left: 40px;" >';
                        html += '<h5 id="e'+data.ar.id+'">'+data.ar.noteContent+'</h5>';
                        html += '<font color="gray">市场活动</font> <font color="gray">-</font> <b>${a.name}</b> <small id="s'+data.ar.id+'" style="color: gray;"> '+data.ar.createTime+' 由'+data.ar.createBy+'</small>';
                        html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
                        html += '<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" onclick="editRemark(\''+data.ar.id+'\',\''+data.ar.noteContent+'\')" style="font-size: 20px; color: #FF0000;"></span></a>';
                        html += '&nbsp;&nbsp;&nbsp;&nbsp';
                        html += '<a class="myHref" href="javascript:void(0);" onclick="deleteRemark(\''+data.ar.id+'\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #FF0000;"></span></a>';
                        html += '</div>';
                        html += '</div>';
                        html += '</div>';
                        $("#remarkDiv").before(html);
                    }else {
                        alert("添加失败")
                    }
                }
            })
        });
        // 按取消按钮后清空文本域的内容
        $("#cancelBtn").click(function () {
            $("#remark").val("");
        });

        // 为备注信息模态窗口更新按钮绑定事件
        $("#updateRemarkBtn").click(function () {
            var id = $("#remarkId").val();
            $.ajax({
                url:"workbench/activity/updateRemark",
                data:{
                    "id":id,
                    "noteContent":$.trim($("#noteContent").val())
                },
                type:"post",
                dataType:"json",
                success:function (data) {
                    if (data.success){
                        // 修改成功后更改其值
                        $("#e"+id).html(data.ar.noteContent);
                        $("#s"+id).html(data.ar.editTime+' 由'+data.ar.editBy);

                        // 修改成功后关闭模态窗口
                        $("#editRemarkModal").modal("hide")

                    }else {
                        alert("修改备注失败")
                    }
                }
            })
        })
    });

	// 获取备注信息的方法
	function showRemarkList() {
		$.ajax({
			url:"workbench/activity/getRemarkListByAid",
			data:{
				"activityId":"${a.id}"
			},
			type:"get",
			dataType:"json",
			success:function (data) {
				var html = "";
				$.each(data,function (i,n) {
				    html += '<div id='+n.id+' class="remarkDiv" style="height: 60px;">';
				    html += '<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
				    html += '<div style="position: relative; top: -40px; left: 40px;" >';
				    html += '<h5 id="e'+n.id+'">'+n.noteContent+'</h5>';
				    html += '<font color="gray">市场活动</font> <font color="gray">-</font> <b>${a.name}</b> <small id="s'+n.id+'" style="color: gray;"> '+(n.editFlag==0?n.createTime:n.editTime)+' 由'+(n.editFlag==0?n.createBt:n.editBy)+' </small>';
				    html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
				    html += '<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" onclick="editRemark(\''+n.id+'\',\''+n.noteContent+'\')" style="font-size: 20px; color: #FF0000;"></span></a>';
				    html += '&nbsp;&nbsp;&nbsp;&nbsp';
				    html += '<a class="myHref" href="javascript:void(0);" onclick="deleteRemark(\''+n.id+'\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #FF0000;"></span></a>';
				    html += '</div>';
				    html += '</div>';
				    html += '</div>';
				});
				$("#remarkDiv").before(html);
			}
		})
	}

	function deleteRemark(id) {
        if (confirm("确定删除备注？")){
            $.ajax({
                url:"workbench/activity/deleteRemark",
                data:{
                    "id":id
                },
                type:"post",
                dataType: "json",
                success:function (data) {
                    if (data){
                        // 删除成功把删除的那条记录清除掉
                        $("#"+id).remove();

                    }else {
                        alert("删除失败")
                    }
                }
            })
        }
    }

    function editRemark(id,nodeContent) {
	    // 将模态窗口中，隐藏域中的id进行赋值
        $("#remarkId").val(id);
        // 打开的模态窗口中要有其备注信息
	    $("#noteContent").val(nodeContent);
	    // 打开模态窗口
        $("#editRemarkModal").modal("show")
    }
	
</script>

</head>
<body>
	
	<!-- 修改市场活动备注的模态窗口 -->
	<div class="modal fade" id="editRemarkModal" role="dialog">
		<%-- 备注的id --%>
		<input type="hidden" id="remarkId">
        <div class="modal-dialog" role="document" style="width: 40%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">修改备注</h4>
                </div>
                <div class="modal-body">
                    <form class="form-horizontal" role="form">
                        <div class="form-group">
                            <label for="edit-description" class="col-sm-2 control-label">内容</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="noteContent"></textarea>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button type="button" class="btn btn-primary" id="updateRemarkBtn">更新</button>
                </div>
            </div>
        </div>
    </div>

    <!-- 修改市场活动的模态窗口 -->
    <div class="modal fade" id="editActivityModal" role="dialog">
        <div class="modal-dialog" role="document" style="width: 85%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel1">修改市场活动</h4>
                </div>
                <div class="modal-body">

                    <form class="form-horizontal" role="form">

                        <div class="form-group">
                            <label for="edit-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <select class="form-control" id="edit-owner">

                                </select>
                            </div>
                            <label for="edit-name" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-name" value="发传单">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-startDate" class="col-sm-2 control-label">开始日期</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control time" id="edit-startDate" value="2020-10-10">
                            </div>
                            <label for="edit-endDate" class="col-sm-2 control-label">结束日期</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control time" id="edit-endDate" value="2020-10-20">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-cost" value="5,000">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-description" class="col-sm-2 control-label">描述</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="edit-description">市场活动Marketing，是指品牌主办或参与的展览会议与公关市场活动，包括自行主办的各类研讨会、客户交流会、演示会、新产品发布会、体验会、答谢会、年会和出席参加并布展或演讲的展览会、研讨会、行业交流会、颁奖典礼等</textarea>
                            </div>
                        </div>

                    </form>

                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button type="button" class="btn btn-primary" id="updateBtn">更新</button>
                </div>
            </div>
        </div>
    </div>

	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>市场活动-${a.name} <small>${a.startDate} ~ ${a.endDate}</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 250px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" id="editBtn" <%--data-toggle="modal" data-target="#editActivityModal"--%>><span class="glyphicon glyphicon-edit"></span> 编辑</button>
			<button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	
	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${a.owner}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${a.name}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>

		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">开始日期</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${a.startDate}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">结束日期</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${a.endDate}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">成本</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${a.cost}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${a.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${a.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${a.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${a.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${a.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
	</div>
	
	<!-- 备注 -->
	<div style="position: relative; top: 30px; left: 40px;" id="remarkBody">
		<div class="page-header">
			<h4>备注</h4>
		</div>
		
		<%--<!-- 备注1 -->
		<div class="remarkDiv" style="height: 60px;">
			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5>哎呦！</h5>
				<font color="gray">市场活动</font> <font color="gray">-</font> <b>发传单</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>
				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
				</div>
			</div>
		</div>
		
		<!-- 备注2 -->
		<div class="remarkDiv" style="height: 60px;">
			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5>呵呵！</h5>
				<font color="gray">市场活动</font> <font color="gray">-</font> <b>发传单</b> <small style="color: gray;"> 2017-01-22 10:20:10 由zhangsan</small>
				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
				</div>
			</div>
		</div>--%>
		
		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..." ></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button type="button" class="btn btn-primary" id="saveRemarkBtn">保存</button>
				</p>
			</form>
		</div>
	</div>
	<div style="height: 200px;"></div>
</body>
</html>