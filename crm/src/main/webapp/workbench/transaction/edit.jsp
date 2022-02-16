<%@ page import="java.util.Set" %>
<%@ page import="java.util.Map" %>
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

	<script type="text/javascript">
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
			$("#edit-customerName").typeahead({
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

			// 页面加载完毕后，通过后台的阶段写入可能性的值
			$("#edit-possibility").val(json[$("#edit-stage").val()]);

			$("#edit-stage").change(function () {
				var stage = $("#edit-stage").val();
				var possibility = json[stage];
				$("#edit-possibility").val(possibility);
			});

			// 市场活动源的放大镜
			$("#openSearchAcvitity").click(function () {
				$("#findMarketActivity").modal("show");
			});
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
			$("#submitActivityBtn").click(function () {
				var id = $("input[name=activity]:checked").val();
				$("#edit-activityId").val(id);
				$("#edit-activityName").val($("#"+id).html());
				$("#aName").val("");
				$("#activitySearchBody").html("");
				$("#findMarketActivity").modal("hide");
			});
			$("#cancleActivitySubmitBtn").click(function () {
				$("#aName").val("");
				$("#activitySearchBody").html("");
				$("#findMarketActivity").modal("hide");
			});
			/*---------------------------------------------------------------*/
			// 联系人名称放大镜
			$("#openSearchContacts").click(function () {
				$("#findContacts").modal("show");
			});
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
			$("#submitContactsBtn").click(function () {
				var id = $("input[name=contacts]:checked").val();
				$("#edit-contactsId").val(id);
				$("#edit-contactsName").val($("#"+id).html());
				$("#cName").val("");
				$("#contactsSearchBody").html("");
				$("#findContacts").modal("hide");
			});
			$("#editTranBtn").click(function () {
				$("#tranEditForm").submit();
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
					<table id="activityTable4" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
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
		<h3>更新交易</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button type="button" class="btn btn-primary" id="editTranBtn">更新</button>
			<button type="button" class="btn btn-default" onclick="window.location.href='workbench/transaction/index.jsp'">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form action="workbench/transaction/update" method="post" id="tranEditForm" class="form-horizontal" role="form" style="position: relative; top: -30px;">
		<input type="hidden" name="id" value="${map.tran.id}">
		<div class="form-group">
			<label for="edit-transactionOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="edit-transactionOwner" name="owner">
					<option></option>
				  <c:forEach items="${map.uList}" var="u">
					  <option value="${u.id}" ${u.id eq map.tran.owner?"selected":""}>${u.name}</option>
				  </c:forEach>
				</select>
			</div>
			<label for="edit-amountOfMoney" class="col-sm-2 control-label">金额</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-amountOfMoney" name="money" value="${map.tran.money}">
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-transactionName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-transactionName" name="name" value="${map.tran.name}">
			</div>
			<label for="edit-expectedClosingDate" class="col-sm-2 control-label">预计成交日期<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" name="expectedDate" class="form-control time1" readonly id="edit-expectedClosingDate" value="${map.tran.expectedDate}">
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-customerName" class="col-sm-2 control-label">客户名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" name="customerName" class="form-control" id="edit-customerName" value="${map.tran.customerId}" placeholder="支持自动补全，输入客户不存在则新建">
			</div>
			<label for="edit-stage" class="col-sm-2 control-label">阶段<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
			  <select class="form-control" id="edit-stage" name="stage">
			  	<option></option>
			  	<c:forEach items="${stage}" var="s">
					<option value="${s.value}" ${s.value eq map.tran.stage ? "selected":""} >${s.text}</option>
				</c:forEach>
			  </select>
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-transactionType" class="col-sm-2 control-label">类型</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="edit-transactionType" name="type">
				  <option></option>
					<c:forEach items="${transactionType}" var="t">
						<option value="${t.value}" ${t.value eq map.tran.type?"selected":""} >${t.text}</option>
					</c:forEach>
				</select>
			</div>
			<label for="edit-possibility" class="col-sm-2 control-label">可能性</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" readonly id="edit-possibility">
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-clueSource" class="col-sm-2 control-label">来源</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="edit-clueSource" name="source">
				  <option></option>
				  <c:forEach items="${source}" var="s">
					  <option value="${s.value}" ${s.value eq map.tran.source?"selected":""}>${s.text}</option>
				  </c:forEach>
				</select>
			</div>
			<label for="edit-activityName" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" id="openSearchAcvitity"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" readonly id="edit-activityName" value="${map.tran.activityId}">
				<input type="hidden" id="edit-activityId" name="activityId">
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-contactsName" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a href="javascript:void(0);" id="openSearchContacts"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" readonly id="edit-contactsName" value="${map.tran.contactsId}">
				<input type="hidden" id="edit-contactsId" name="contactsId">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-describe" class="col-sm-2 control-label">描述</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" name="description" rows="3" id="create-describe">${map.tran.description}</textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" name="contactSummary" rows="3" id="create-contactSummary">${map.tran.contactSummary}</textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" name="nextContactTime" readonly class="form-control time2" value="${map.tran.nextContactTime}" id="create-nextContactTime">
			</div>
		</div>
		
	</form>
</body>
</html>