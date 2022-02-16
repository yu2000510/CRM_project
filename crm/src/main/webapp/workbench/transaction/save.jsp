<%@ page import="java.util.Map" %>
<%@ page import="java.util.Set" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%
String basePath = request.getScheme() + "://" +
request.getServerName() + ":" + request.getServerPort() +
request.getContextPath() + "/";

	Map<String,String> pMap = (Map<String, String>) application.getAttribute("pMap");
	Set<String> set = pMap.keySet();
%>
<html>
<head>
<meta charset="UTF-8">
	<base href="<%=basePath%>">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

	<script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>

	<script>
		var json={
			<%
				for (String key : set) {
					String value = pMap.get(key);
			%>
				"<%=key%>":<%=value%>,
			<%
				}
			%>
		};

		$(function () {
			$("#create-customerName").typeahead({
				source: function (query, process) {
					$.get(
							"workbench/transaction/getCustomerName",
							{ "name" : query },
							function (data) {
								process(data);
							},
							"json"
					);
				},
				delay: 1500 // 延迟加载时间，过了1.5秒后自动补全
			});


			$(".time1").datetimepicker({
				minView: "month",
				language: 'zh-CN',
				format: 'yyyy-mm-dd',
				autoclose: true,
				todayBtn: true, // 显示今天
				pickerPosition: "bottom-left" // 显示位置
			});
			$(".time2").datetimepicker({
				minView: "month",
				language: 'zh-CN',
				format: 'yyyy-mm-dd',
				autoclose: true,
				todayBtn: true, // 显示今天
				pickerPosition: "top-left" // 显示位置
			});
			// 为阶段的下拉框绑定事件，填写可能性
			$("#create-stage").change(function () {
				var stage = $("#create-stage").val();
				var possibility = json[stage];
				// 为可能性文本框赋值
				$("#create-possibility").val(possibility);
			});

			// 为“市场活动源”的放大镜绑定事件
			$("#openSearchAcvitity").click(function () {
				$("#findMarketActivity").modal("show")
			});
			// 为“市场活动源”搜索模态窗口绑定事件
			$("#aName").keydown(function (event) {
				if (event.keyCode == 13){
					$.ajax({
						url:"workbench/clue/getActivityByName",
						data:{
							"aName":$.trim($("#aName").val()),
						},
						type:"get",
						dataType:"json",
						success:function (data) {
							var html = "";
							$.each(data,function (i,n) {
								html += '<tr>';
								html += '<td><input type="radio" name="activity" value="'+n.id+'"/></td>';
								html += '<td id="'+n.id+'">'+n.name+'</td>';
								html += '<td>'+n.startDate+'</td>';
								html += '<td>'+n.endDate+'</td>';
								html += '<td>'+n.owner+'</td>';
								html += '</tr>';
							});
							$("#activitySearchBody").html(html)
						}
					});
					return false;
				}
			});
			// “市场活动”模态窗口提交按钮绑定事件
			$("#submitActivityBtn").click(function () {
				var id = $("input[name=activity]:checked").val();
				$("#create-activityId").val(id);
				$("#activityName").val($("#"+id).html());
				$("#activitySearchBody").html("");
				$("#aName").val("");
				$("#findMarketActivity").modal("hide")
			});
			// “市场活动”模态窗口取消按钮点击事件
			$("#cancleActivitySubmitBtn").click(function () {
				$("#activitySearchBody").html("");
				$("#aName").val("");
				$("#findMarketActivity").modal("hide")
			});
			/*--------------------------------------------------------*/
			// 为“联系人”名称的放大镜绑定事件
			$("#openSearchContacts").click(function () {
				$("#findContacts").modal("show")
			});
			// 为“联系人”模态窗口搜索框绑定事件
			$("#cName").keydown(function (event) {
				if (event.keyCode == 13){
					$.ajax({
						url:"workbench/transaction/getContactsByName",
						data:{
							"cName":$.trim($("#cName").val()),
						},
						type:"get",
						dataType:"json",
						success:function (data) {
							var html = "";
							$.each(data,function (i,n) {
								html += '<tr>';
								html += '<td><input type="radio" name="contacts" value="'+n.id+'"/></td>';
								html += '<td id="'+n.id+'">'+n.fullname+'</td>';
								html += '<td>'+n.email+'</td>';
								html += '<td>'+n.mphone+'</td>';
								html += '</tr>';
							});
							$("#contactsSearchBody").html(html)
						}
					});
					return false;
				}
			});
			// “联系人”模态窗口提交按钮
			$("#submitContactsBtn").click(function () {
				var id = $("input[name=contacts]:checked").val();
				$("#contactsId").val(id);
				$("#create-contactsName").val($("#"+id).html());
				$("#contactsSearchBody").html("");
				$("#cName").val("");
				$("#findContacts").modal("hide");
			});
			// “联系人”模态窗口取消按钮
			$("#cancleContactsSubmitBtn").click(function () {
				$("#cName").val("");
				$("#contactsSearchBody").html("");
				$("#findContacts").modal("hide");
			})

			// 为保存按钮绑定事件，提交tranForm表单
			$("#saveTranBtn").click(function () {
				$("#tranAddForm").submit();
			})
		})
	</script>

</head>
<body>

	<!-- 查找市场活动 -->	
	<div class="modal fade" id="findMarketActivity" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" id="aName" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable3" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
							</tr>
						</thead>
						<tbody id="activitySearchBody">

						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" id="cancleActivitySubmitBtn" >取消</button>
					<button type="button" class="btn btn-primary" id="submitActivityBtn">提交</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 查找联系人 -->	
	<div class="modal fade" id="findContacts" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找联系人</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" id="cName" class="form-control" style="width: 300px;" placeholder="请输入联系人名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>邮箱</td>
								<td>手机</td>
							</tr>
						</thead>
						<tbody id="contactsSearchBody">

						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" id="cancleContactsSubmitBtn" >取消</button>
					<button type="button" class="btn btn-primary" id="submitContactsBtn">提交</button>
				</div>
			</div>
		</div>
	</div>
	
	
	<div style="position:  relative; left: 30px;">
		<h3>创建交易</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button type="button" class="btn btn-primary" id="saveTranBtn">保存</button>
			<button type="button" class="btn btn-default" onclick="window.location.href='workbench/transaction/index.jsp'">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form action="workbench/transaction/save" id="tranAddForm" method="post" class="form-horizontal" role="form" style="position: relative; top: -30px;">
		<div class="form-group">
			<label for="create-transactionOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-transactionOwner" name="owner">
				  <option></option>
					<c:forEach items="${uList}" var="u">
						<option value="${u.id}" ${u.id eq user.id ?"selected" : ""}>${u.name}</option>
					</c:forEach>
				</select>
			</div>
			<label for="create-amountOfMoney" class="col-sm-2 control-label">金额</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-amountOfMoney" name="money">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-transactionName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-transactionName" name="name">
			</div>
			<label for="create-expectedClosingDate" class="col-sm-2 control-label">预计成交日期<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" readonly  class="form-control time1" id="create-expectedClosingDate" name="expectedDate">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-customerName" class="col-sm-2 control-label">客户名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-customerName" name="customerName" placeholder="支持自动补全，输入客户不存在则新建">
			</div>
			<label for="create-stage" class="col-sm-2 control-label">阶段<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
			  <select class="form-control" id="create-stage" name="stage">
			  	<option></option>
			  	<c:forEach items="${stage}" var="s">
					<option value="${s.value}">${s.text}</option>
				</c:forEach>
			  </select>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-transactionType" class="col-sm-2 control-label">类型</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-transactionType" name="type">
				  <option></option>
					<c:forEach items="${transactionType}" var="t">
						<option value="${t.value}">${t.text}</option>
					</c:forEach>
				</select>
			</div>
			<label for="create-possibility" class="col-sm-2 control-label">可能性</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" readonly class="form-control" id="create-possibility">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-clueSource" class="col-sm-2 control-label">来源</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-clueSource" name="source">
				  <option></option>
					<c:forEach items="${source}" var="s">
						<option value="${s.value}">${s.text}</option>
					</c:forEach>
				</select>
			</div>
			<label for="activityName" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" id="openSearchAcvitity" <%--data-toggle="modal" data-target="#findMarketActivity"--%>><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" readonly class="form-control" id="activityName">
				<input type="hidden" id="create-activityId" name="activityId">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-contactsName" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a href="javascript:void(0);" id="openSearchContacts" ><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" readonly class="form-control" id="create-contactsName">
				<input type="hidden" id="contactsId" name="contactsId">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-describe" class="col-sm-2 control-label">描述</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-describe" name="description"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-contactSummary" name="contactSummary"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" readonly class="form-control time2" id="create-nextContactTime" name="nextContactTime">
			</div>
		</div>
		
	</form>
</body>
</html>