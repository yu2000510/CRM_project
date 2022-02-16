<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
String basePath = request.getScheme() + "://" +
request.getServerName() + ":" + request.getServerPort() +
request.getContextPath() + "/";
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

	<link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
	<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>

<script type="text/javascript">

	$(function(){
		$(".time").datetimepicker({
			minView: "month",
			language: 'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true, // 显示今天
			pickerPosition: "top-left" // 显示位置
		});
		
		pageList(1,2);

		$("#qx").click(function x() {
			$("input[name=xz]").prop("checked",this.checked)
		});
		$("#tranBody").on("click",$("input[name=xz]"),function () {
			$("#qx").prop("checked",$("input[name=xz]").length == $("input[name=xz]:checked").length)
		});

		// 携带id跳转到修改页面
		$("#editBtn").click(function () {
			var $xz = $("input[name=xz]:checked");
			if ($xz.length == 0){
				alert("请选择需要修改的交易")
			}else if ($xz.length > 1){
				alert("只能选择一条交易进行修改")
			}else {
				var id = $xz.val();
				window.location.href="workbench/transaction/editPage?id="+id;
			}
		});

		$("#deleteBtn").click(function () {
			var $xz = $("input[name=xz]:checked");
			if ($xz.length == 0){
				alert("请选择需要删除的交易")
			}else {
				if (confirm("是否删除所选择的交易")){
					var param = "";
					for (var i=0;i<$xz.length;i++){
						param += "id="+$xz[i].value;
						if (i<$xz.length-1){
							param += "&"
						}
					}
					$.ajax({
						url:"workbench/transaction/delete",
						data:param,
						type:"post",
						dataType:"json",
						success:function (data) {
							if (data){
								pageList(1
										, $("#tranPage").bs_pagination('getOption', 'rowsPerPage'));
							}else {
								alert("删除线索失败")
							}
						}
					})
				}
			}
		});

		// 查询按钮
		$("#searchBtn").click(function () {
			$("#hidden-owner").val($.trim($("#search-owner").val()));
			$("#hidden-name").val($.trim($("#search-name").val()));
			$("#hidden-customerName").val($.trim($("#search-customerName").val()));
			$("#hidden-stage").val($.trim($("#search-stage").val()));
			$("#hidden-source").val($.trim($("#search-source").val()));
			$("#hidden-type").val($.trim($("#search-type").val()));
			$("#hidden-contactsName").val($.trim($("#search-contactsName").val()));

			pageList(1,2);
		});
		// 清空按钮
		$("#resetBtn").click(function () {
			$("#searchFormBtn")[0].reset();
		})
	});

	function pageList(pageNo,pageSize) {
		$("#qx").prop("checked",false);

		$("#search-owner").val($.trim($("#hidden-owner").val()));
		$("#search-name").val($.trim($("#hidden-name").val()));
		$("#search-customerName").val($.trim($("#hidden-customerName").val()));
		$("#search-stage").val($.trim($("#hidden-stage").val()));
		$("#search-source").val($.trim($("#hidden-source").val()));
		$("#search-type").val($.trim($("#hidden-type").val()));
		$("#search-contactsName").val($.trim($("#hidden-contactsName").val()));

		$.ajax({
			url:"workbench/transaction/pageList",
			data:{
				"name":$.trim($("#search-name").val()),
				"customerName":$.trim($("#search-customerName").val()),
				"stage":$.trim($("#search-stage").val()),
				"source":$.trim($("#search-source").val()),
				"owner":$.trim($("#search-owner").val()),
				"type":$.trim($("#search-type").val()),
				"contactsName":$.trim($("#search-contactsName").val()),
				"pageNo":pageNo,
				"pageSize":pageSize
			},
			type:"get",
			dataType:"json",
			success:function (data) {
				var html = "";
				$.each(data.dataList,function (i,n) {
					html += '<tr>';
					html += '<td><input name="xz" type="checkbox" value="'+n.id+'" /></td>';
					html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/transaction/detail?id='+n.id+'\';">'+n.name+'</a></td>';
					html += '<td>'+n.customerId+'</td>';
					html += '<td>'+n.stage+'</td>';
					html += '<td>'+n.type+'</td>';
					html += '<td>'+n.owner+'</td>';
					html += '<td>'+n.source+'</td>';
					html += '<td>'+n.contactsId+'</td>';
					html += '</tr>';
				});
				$("#tranBody").html(html);
				// 计算总页数
				var totalPages = data.total%pageSize == 0 ? data.total/pageSize:parseInt(data.total/pageSize)+1;

				// 在pageList处理ajax返回值后，加入分页组件
				$("#tranPage").bs_pagination({
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
	<input type="hidden" id="hidden-owner"/>
	<input type="hidden" id="hidden-name"/>
	<input type="hidden" id="hidden-customerName"/>
	<input type="hidden" id="hidden-stage"/>
	<input type="hidden" id="hidden-type"/>
	<input type="hidden" id="hidden-source"/>
	<input type="hidden" id="hidden-contactsName"/>
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>交易列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" id="searchFormBtn" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input id="search-owner" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input id="search-name" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">客户名称</div>
				      <input id="search-customerName" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">阶段</div>
					  <select id="search-stage" class="form-control">
					  	<option></option>
					  	<c:forEach items="${stage}" var="s">
							<option value="${s.value}">${s.text}</option>
						</c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">类型</div>
					  <select id="search-type" class="form-control">
					  	<option></option>
					  	<c:forEach items="${transactionType}" var="t">
							<option value="${t.value}">${t.text}</option>
						</c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">来源</div>
				      <select class="form-control" id="search-source">
						  <option></option>
						  <c:forEach items="${source}" var="s">
							  <option value="${s.value}">${s.text}</option>
						  </c:forEach>
						</select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">联系人名称</div>
				      <input id="search-contactsName" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <button type="button" id="searchBtn" class="btn btn-default">查询</button>
					<button type="button" id="resetBtn" class="btn btn-default">清空</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" onclick="window.location.href='workbench/transaction/addPage';"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" id="editBtn" class="btn btn-default" ><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" id="deleteBtn" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="qx"/></td>
							<td>名称</td>
							<td>客户名称</td>
							<td>阶段</td>
							<td>类型</td>
							<td>所有者</td>
							<td>来源</td>
							<td>联系人名称</td>
						</tr>
					</thead>
					<tbody id="tranBody">

					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 20px;">
				<div id="tranPage"></div>
			</div>
			
		</div>
		
	</div>
</body>
</html>