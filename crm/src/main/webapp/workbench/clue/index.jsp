<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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

		$(".time").datetimepicker({
			minView: "month",
			language: 'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true, // 显示今天
			pickerPosition: "top-left" // 显示位置
		});

		// 点击添加按钮打开添加模态窗口
		$("#addBtn").click(function () {
			$.ajax({
				url:"workbench/clue/getUserList",
				type:"get",
				dataType:"json",
				success:function (data) {
					var html= "<option></option>";
					$.each(data,function (i,n) {
						html += "<option value='"+n.id+"'>"+n.name+"</option>"
					});
					$("#create-owner").html(html);
					var id = "${user.id}";
					$("#create-owner").val(id);
				}
			});
			$("#createClueModal").modal("show")
		});
		// 点击修改按钮打开修改模态窗口
		$("#editBtn").click(function () {
			var $xz = $("input[name=xz]:checked");
			if ($xz.length == 0){
				alert("请选择需要修改的线索")
			} else if($xz.length > 1){
				alert("只能选择一条线索进行修改")
			} else {
				var id = $xz.val();
				$.ajax({
					url:"workbench/clue/getUserListAndClue",
					data:{
						"id":id
					},
					type:"get",
					dataType:"json",
					success:function (data) {
						var html = "";
						$.each(data.uList,function (i,n) {
							html += "<option value='"+n.id+"'>"+n.name+"</option>"
						});
						$("#edit-owner").html(html);

						$("#edit-id").val(data.c.id);
						$("#edit-fullname").val(data.c.fullname);
						$("#edit-appellation").val(data.c.appellation);
						$("#edit-owner").val(data.c.owner);
						$("#edit-company").val(data.c.company);
						$("#edit-job").val(data.c.job);
						$("#edit-email").val(data.c.email);
						$("#edit-phone").val(data.c.phone);
						$("#edit-website").val(data.c.website);
						$("#edit-mphone").val(data.c.mphone);
						$("#edit-state").val(data.c.state);
						$("#edit-source").val(data.c.source);
						$("#edit-description").val(data.c.description);
						$("#edit-contactSummary").val(data.c.contactSummary);
						$("#edit-nextContactTime").val(data.c.nextContactTime);
						$("#edit-address").val(data.c.address);
					}
				});
				$("#editClueModal").modal("show")
			}
		});

		$("#saveBtn").click(function () {
			$.ajax({
				url:"workbench/clue/save",
				data:{
					"fullname":$.trim($("#create-fullname").val()),
					"appellation":$.trim($("#create-appellation").val()),
					"owner":$.trim($("#create-owner").val()),
					"company":$.trim($("#create-company").val()),
					"job":$.trim($("#create-job").val()),
					"email":$.trim($("#create-email").val()),
					"phone":$.trim($("#create-phone").val()),
					"website":$.trim($("#create-website").val()),
					"mphone":$.trim($("#create-mphone").val()),
					"state":$.trim($("#create-state").val()),
					"source":$.trim($("#create-source").val()),
					"description":$.trim($("#create-description").val()),
					"contactSummary":$.trim($("#create-contactSummary").val()),
					"nextContactTime":$.trim($("#create-nextContactTime").val()),
					"address":$.trim($("#create-address").val())
				},
				type:"post",
				dataType:"json",
				success:function (data) {
					if(data){
						// 刷新列表
						// 第二个参数表示操作后维持已经设置好的每页展现的记录
						pageList(1
								, $("#cluePage").bs_pagination('getOption', 'rowsPerPage'));
						// 添加成功后，关闭模态窗口，清空模态窗口的数据
						$("#clueAddForm")[0].reset();
						// 关闭模态窗口
						$("#createClueModal").modal("hide")
					}else {
						alert("添加线索失败")
					}
				}
			})
		});

		$("#updateBtn").click(function () {
			$.ajax({
				url:"workbench/clue/update",
				data:{
					"id":$.trim($("#edit-id").val()),
					"fullname":$.trim($("#edit-fullname").val()),
					"appellation":$.trim($("#edit-appellation").val()),
					"owner":$.trim($("#edit-owner").val()),
					"company":$.trim($("#edit-company").val()),
					"job":$.trim($("#edit-job").val()),
					"email":$.trim($("#edit-email").val()),
					"phone":$.trim($("#edit-phone").val()),
					"website":$.trim($("#edit-website").val()),
					"mphone":$.trim($("#edit-mphone").val()),
					"state":$.trim($("#edit-state").val()),
					"source":$.trim($("#edit-source").val()),
					"description":$.trim($("#edit-description").val()),
					"contactSummary":$.trim($("#edit-contactSummary").val()),
					"nextContactTime":$.trim($("#edit-nextContactTime").val()),
					"address":$.trim($("#edit-address").val())
				},
				type:"post",
				dataType:"json",
				success:function (data) {
					if (data){
						pageList($("#cluePage").bs_pagination('getOption', 'currentPage')
								,$("#cluePage").bs_pagination('getOption', 'rowsPerPage'));
						$("#editClueModal").modal("hide");
					}else {
						alert("修改失败")
					}
				}
			})
		});

		// 全选操纵单选
		$("#qx").click(function () {
			$("input[name=xz]").prop("checked",this.checked)
		});
		// 单选操纵全选
		$("#clueBody").on("click",$("input[name=xz]"),function () {
			$("#qx").prop("checked",$("input[name=xz]").length == $("input[name=xz]:checked").length)
		});

		// 删除选择的线索
		$("#deleteBtn").click(function () {
			var $xz = $("input[name=xz]:checked");
			if ($xz.length == 0){
				alert("请选择需要删除的线索")
			}else {
				if (confirm("确定要删除所选择的线索吗")){
					var param = "";
					for(var i=0;i<$xz.length;i++){
						param += "id="+$($xz[i]).val();
						if (i<$xz.length-1){
							param += "&";
						}
					}
					$.ajax({
						url:"workbench/clue/delete",
						data:param,
						type:"post",
						dataType:"json",
						success:function (data) {
							if (data){
								pageList(1
										, $("#cluePage").bs_pagination('getOption', 'rowsPerPage'));
							}else {
								alert("删除线索失败")
							}
						}
					})
				}
			}

		});

		$("#searchBtn").click(function () {
			$("#hidden-fullname").val($("#search-fullname").val());
			$("#hidden-company").val($("#search-company").val());
			$("#hidden-phone").val($("#search-phone").val());
			$("#hidden-source").val($("#search-source").val());
			$("#hidden-owner").val($("#search-owner").val());
			$("#hidden-mphone").val($("#search-mphone").val());
			$("#hidden-state").val($("#search-state").val());

			pageList(1,2);
		});
		$("#resetBtn").click(function () {
			$("#searchFormBtn")[0].reset();
		});
		pageList(1,2);
	});

	function pageList(pageNo,pageSize){
		$("#qx").prop("checked",false);

		$("#search-fullname").val($.trim($("#hidden-fullname").val()));
		$("#search-company").val($("#hidden-company").val());
		$("#search-phone").val($("#hidden-phone").val());
		$("#search-source").val($("#hidden-source").val());
		$("#search-owner").val($("#hidden-owner").val());
		$("#search-mphone").val($("#hidden-mphone").val());
		$("#search-state").val($("#hidden-state").val());

		$.ajax({
			url:"workbench/clue/pageList",
			data:{
				"fullname":$.trim($("#search-fullname").val()),
				"company":$.trim($("#search-company").val()),
				"phone":$.trim($("#search-phone").val()),
				"source":$.trim($("#search-source").val()),
				"owner":$.trim($("#search-owner").val()),
				"mphone":$.trim($("#search-mphone").val()),
				"state":$.trim($("#search-state").val()),
				"pageNo":pageNo,
				"pageSize":pageSize
			},
			type:"get",
			dataType:"json",
			success:function (data) {
				var html = "";
				$.each(data.dataList,function (i,n) {
					html += '<tr class="active">';
					html += '<td><input type="checkbox" name=xz value='+n.id+' /></td>';
					html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/clue/detail?id='+n.id+'\';">'+n.fullname+'</a></td>';
					html += '<td>'+n.company+'</td>';
					html += '<td>'+n.phone+'</td>';
					html += '<td>'+n.mphone+'</td>';
					html += '<td>'+n.source+'</td>';
					html += '<td>'+n.owner+'</td>';
					html += '<td>'+n.state+'</td>';
					html += '</tr>';
				});
				$("#clueBody").html(html);
				// 计算总页数
				var totalPages = data.total%pageSize == 0 ? data.total/pageSize:parseInt(data.total/pageSize)+1;

				// 在pageList处理ajax返回值后，加入分页组件
				$("#cluePage").bs_pagination({
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
	<input type="hidden" id="hidden-fullname">
	<input type="hidden" id="hidden-company">
	<input type="hidden" id="hidden-phone">
	<input type="hidden" id="hidden-source">
	<input type="hidden" id="hidden-owner">
	<input type="hidden" id="hidden-mphone">
	<input type="hidden" id="hidden-state">

	<!-- 创建线索的模态窗口 -->
	<div class="modal fade" id="createClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">创建线索</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form" id="clueAddForm">
					
						<div class="form-group">
							<label for="create-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-owner">

								</select>
							</div>
							<label for="create-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-company">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-appellation" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-appellation">
								  <option></option>
								  <c:forEach items="${appellation}" var="a">
									<option value="${a.value}">${a.text}</option>
								  </c:forEach>
								</select>
							</div>
							<label for="create-fullname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-fullname">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-job">
							</div>
							<label for="create-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone">
							</div>
							<label for="create-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-website">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-mphone">
							</div>
							<label for="create-state" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-state">
								  <option></option>
									<c:forEach items="${clueState}" var="c">
										<option value="${c.value}">${c.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-source">
								  <option></option>
									<c:forEach items="${source}" var="s">
										<option value="${s.value}">${s.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						

						<div class="form-group">
							<label for="create-description" class="col-sm-2 control-label">线索描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control time" id="create-nextContactTime">
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>
						
						<div style="position: relative;top: 20px;">
							<div class="form-group">
                                <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address"></textarea>
                                </div>
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
	
	<!-- 修改线索的模态窗口 -->
	<div class="modal fade" id="editClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">修改线索</h4>
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
							<label for="edit-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-company">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-appellation" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-appellation">
								  <option></option>
									<c:forEach items="${appellation}" var="a">
										<option value="${a.value}">${a.text}</option>
									</c:forEach>
								</select>
							</div>
							<label for="edit-fullname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-fullname">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-job">
							</div>
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone">
							</div>
							<label for="edit-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-website">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mphone">
							</div>
							<label for="edit-state" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-state">
								  <option></option>
									<c:forEach items="${clueState}" var="c">
										<option value="${c.value}">${c.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-source">
								  <option></option>
									<c:forEach items="${source}" var="s">
										<option value="${s.value}">${s.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="edit-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control time" id="edit-nextContactTime">
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address"></textarea>
                                </div>
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
				<h3>线索列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;" id="searchFormBtn">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="search-fullname">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司</div>
				      <input class="form-control" type="text" id="search-company">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司座机</div>
				      <input class="form-control" type="text" id="search-phone">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索来源</div>
					  <select class="form-control" id="search-source">
					  	  <option></option>
						  <c:forEach items="${source}" var="s">
							  <option value="${s.value}">${s.text}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="search-owner">
				    </div>
				  </div>
				  
				  
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">手机</div>
				      <input class="form-control" type="text" id="search-mphone">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索状态</div>
					  <select class="form-control" id="search-state">
					  	<option></option>
						  <c:forEach items="${clueState}" var="c">
							  <option value="${c.value}">${c.text}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>

				  <button type="button" id="searchBtn" class="btn btn-default">查询</button>
				  <button type="button" id="resetBtn" class="btn btn-default">清空</button>

				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 40px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="addBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 50px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="qx"/></td>
							<td>名称</td>
							<td>公司</td>
							<td>公司座机</td>
							<td>手机</td>
							<td>线索来源</td>
							<td>所有者</td>
							<td>线索状态</td>
						</tr>
					</thead>
					<tbody id="clueBody">

					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 60px;">
				<div id="cluePage"></div>
			</div>
		</div>
		
	</div>
</body>
</html>