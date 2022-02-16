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

	$(function(){
		// 日历组件，复制粘贴即可
		$(".time").datetimepicker({
			minView: "month",
			language: 'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true, // 显示今天
			pickerPosition: "bottom-right" // 显示位置
		});
		// 为创建按钮绑定事件，打开添加操作的模态窗口
		$("#addBtn").click(function () {

			// 走后台，为所有者的下拉框提供数据
			$.ajax({
				url:"workbench/activity/getUserList",
				type:"get",
				dataType:"json",
				success:function (data) {
					var html = "<option></option>";
					$.each(data,function (i,n) {
						html += "<option value='"+n.id+"'>" + n.name + "</option>"
					});
					$("#create-owner").html(html);
					// 在js中使用el表达式必须要套在字符串当中
					var userid = "${user.id}";

					$("#create-owner").val(userid);
				}
			});

			/*
				操作模态窗口的方式
					需要操作模态窗口的jquery对象，调用modal方法，
					为该方法传递参数，show：打开窗口   hide：关闭窗口
			*/
			// 获得所有者数据后再打开模态窗口
			$("#createActivityModal").modal("show");
		});

		// 打开修改界面模态窗口
		$("#editBtn").click(function () {

			var $xz = $("input[name=xz]:checked");
			if($xz.length == 0){
				alert("请选择需要修改的记录")
			}else if ($xz.length > 1){
				alert("只能选择一条记录进行修改")
			}else {
				var id = $xz.val();
				$.ajax({
					url:"workbench/activity/getUserListAndActivity",
					type:"get",
					data:{"id":id},
					dataType:"json",
					success:function (data) {
						// 处理所有者下拉框
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
			}
		});

		// 保存按钮绑定事件
		$("#saveBtn").click(function () {

			$.ajax({
				url:"workbench/activity/save",
				data:{
					"owner":$.trim($("#create-owner").val()),
					"name":$.trim($("#create-name").val()),
					"startDate":$.trim($("#create-startDate").val()),
					"endDate":$.trim($("#create-endDate").val()),
					"cost":$.trim($("#create-cost").val()),
					"description":$.trim($("#create-description").val())
				},
				type:"post",
				dataType: "json",
				success:function (data) {
					if (data){
						// pageList(1,2);
						// 第二个参数表示操作后维持已经设置好的每页展现的记录
						pageList(1
								,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));

						// 添加成功后，关闭模态窗口，清空模态窗口的数据
						$("#activityAddForm")[0].reset();

						$("#createActivityModal").modal("hide")
					}else{
						alert("添加失败")
					}
				}
			});
		});

		$("#updateBtn").click(function () {
			$.ajax({
				url:"workbench/activity/update",
				data:{
					"id":$.trim($("#edit-id").val()),
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
					if (data){
						// pageList(1,2);
						// 第一个参数表示操作后停留在当前页
						// 第二个参数表示操作后维持已经设置好的每页展现的记录
						pageList($("#activityPage").bs_pagination('getOption', 'currentPage')
								,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
						$("#editActivityModal").modal("hide");
					}else{
						alert("修改失败")
					}
				}
			})
		});

		// 市场活动页面展开后就展示第一页的两条数据
		pageList(1,2);

		// 为市场活动页面的查询按钮绑定事件
		$("#searchBtn").click(function () {
			$("#hidden-name").val($.trim($("#search-name").val()));
			$("#hidden-owner").val($.trim($("#search-owner").val()));
			$("#hidden-startDate").val($.trim($("#search-startDate").val()));
			$("#hidden-endDate").val($.trim($("#search-endDate").val()));

			pageList(1,2)
		});

		$("#resetBtn").click(function () {
			$("#searchFromBtn")[0].reset()
		});

		// 全选按钮的单击事件
		$("#qx").click(function () {
			$("input[name=xz]").prop("checked",this.checked)
		});

		// 单选按钮操控全选
		$("#activityBody").on("click",$("input[name=xz]"),function () {
			$("#qx").prop("checked",$("input[name=xz]").length==$("input[name=xz]:checked").length)
		});

		// 点击删除按钮执行删除操作
		$("#deleteBtn").click(function () {

			var $xz = $("input[name=xz]:checked");
			if ($xz.length == 0){
				alert("请选择需要删除的记录");
			}else{
				if (confirm("确定删除所选中的记录吗？")){
					var param="";
					for(var i=0;i<$xz.length;i++){
						param += "id="+$($xz[i]).val();
						if (i<$xz.length-1){
							param += "&";
						}
					}
					$.ajax({
						url:"workbench/activity/delete",
						data:param,
						type:"post",
						dataType:"json",
						success:function (data) {
							if(data){
								pageList(1
										,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
							}else {
								alert("市场活动删除失败")
							}
						}
					})
				}
			}
		})

	});

	// pageNo：页码
	// pageSize：每页展现的记录数
	// pageList：向后台发出ajax请求，获取市场活动信息的方法
	// 添加、修改、删除、查询后需要使用该方法，向后台取得数据
	// 点击分页组件的时候
	function pageList(pageNo,pageSize){
		// 将全选的复选框✔干掉
		$("#qx").prop("checked",false);

		$("#search-name").val($.trim($("#hidden-name").val()));
		$("#search-owner").val($.trim($("#hidden-owner").val()));
		$("#search-startDate").val($.trim($("#hidden-startDate").val()));
		$("#search-endDate").val($.trim($("#hidden-endDate").val()));

		$.ajax({
			url:"workbench/activity/pageList",
			data:{
				"name":$.trim($("#search-name").val()),
				"owner":$.trim($("#search-owner").val()),
				"startDate":$.trim($("#search-startDate").val()),
				"endDate":$.trim($("#search-endDate").val()),
				"pageNo":pageNo,
				"pageSize":pageSize
			},
			type:"get",
			dataType:"json",
			success:function (data) {

				var html = "";
				// 每一个n就是一个市场活动对象
				$.each(data.dataList,function (i,n) {
					html += '<tr class="active">';
					html += '<td><input type="checkbox" name=xz value='+n.id+' /></td>';
					html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/activity/detail?id='+n.id+'\';">'+n.name+'</a></td>';
					html += '<td>'+n.owner+'</td>';
					html += '<td>'+n.startDate+'</td>';
					html += '<td>'+n.endDate+'</td>';
					html += '</tr>';
				});
				$("#activityBody").html(html);
				// 计算总页数
				var totalPages = data.total%pageSize == 0 ? data.total/pageSize:parseInt(data.total/pageSize)+1;

				// 在pageList.do处理ajax返回值后，加入分页组件
				$("#activityPage").bs_pagination({
					currentPage: pageNo, // 页码
					rowsPerPage: pageSize, // 每页显示的记录条数
					maxRowsPerPage: 20, // 每页最多显示的记录条数
					totalPages: totalPages, // 总页数
					totalRows: data.total, // 总记录条数

					visiblePageLinks: 3, // 显示几个卡片

					showGoToPage: true,
					showRowsPerPage: true,
					showRowsInfo: true,
					showRowsDefaultInfo: true,

					// 该回调函数是在点击分页组件的时候触发的
					onChangePage : function(event, data){
						pageList(data.currentPage , data.rowsPerPage);
					}
				});

			}
		})
	}
	
</script>
</head>
<body>
	<input type="hidden" id="hidden-name">
	<input type="hidden" id="hidden-owner">
	<input type="hidden" id="hidden-startDate">
	<input type="hidden" id="hidden-endDate">

	<!-- 创建市场活动的模态窗口 -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" id="activityAddForm" role="form">
					
						<div class="form-group">
							<label for="create-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-owner">

								</select>
							</div>
                            <label for="create-name" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-name">
                            </div>
						</div>
						
						<div class="form-group">
							<label for="create-startDate" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-startDate">
							</div>
							<label for="create-endDate" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-endDate">
							</div>
						</div>
                        <div class="form-group">

                            <label for="create-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-cost">
                            </div>
                        </div>
						<div class="form-group">
							<label for="create-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveBtn">保存</button>
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
					<h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form">
						<input type="hidden" id="edit-id">
					
						<div class="form-group">
							<label for="edit-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-owner">

								</select>
							</div>
                            <label for="edit-name" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-name">
                            </div>
						</div>

						<div class="form-group">
							<label for="edit-startDate" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="edit-startDate">
							</div>
							<label for="edit-endDate" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="edit-endDate">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-cost">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description"></textarea>
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
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>市场活动列表</h3>
			</div>
		</div>
	</div>
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;" id="searchFromBtn">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="search-name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="search-owner">
				    </div>
				  </div>


				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">开始日期</div>
					  <input class="form-control time" type="text" id="search-startDate" />
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">结束日期</div>
					  <input class="form-control time" type="text" id="search-endDate">
				    </div>
				  </div>
				  
				  <button type="button" id="searchBtn" class="btn btn-default">查询</button>
				  <button type="button" id="resetBtn" class="btn btn-default">清空</button>

				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
					<!--
						data-toggle="modal" 表示点击按钮将要打开一个模态窗口
						data-target 表示要打开哪个模态窗口，通过#id的形式来找到窗口

						这个按钮的功能写死了，我们把打开模态窗口的功能放入到js中
					-->
				  <button type="button" class="btn btn-primary" id="addBtn" <%--data-toggle="modal" data-target="#createActivityModal"--%>><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editBtn" <%--data-toggle="modal" data-target="#editActivityModal"--%>><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="qx"/></td>
							<td>名称</td>
                            <td>所有者</td>
							<td>开始日期</td>
							<td>结束日期</td>
						</tr>
					</thead>
					<tbody id="activityBody">

					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 30px;">
				<div id="activityPage"></div>
			</div>
			
		</div>
		
	</div>
</body>
</html>