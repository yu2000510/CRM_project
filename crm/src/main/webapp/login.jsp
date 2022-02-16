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
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<script>
		$(function () {

			if(window.top != window){
				window.top.location = window.location
			}

			// 页面加载完毕后，将用户的文本框自动清空
			$("#loginAct").val("");
			// 页面加载完毕后，让用户的文本框自动获得焦点
			$("#loginAct").focus();

			// 为登录按钮绑定事件，执行登录操作
			$("#submitBtn").click(function () {
				login()
			});

			$(window).keydown(function (event) {
				if (event.keyCode == 13){ // 如果在当前页面按的是回车键
					login()
				}
			});

		})
		// 登录验证的方法  普通的自定义的方法一定要写在$()的外面
		function login() {
			// alert("登录验证123")
			// 用户名 密码不能为空，使用$.trim()去掉左右空字符串
			var loginAct = $.trim($("#loginAct").val());
			var loginPwd = $.trim($("#loginPwd").val());

			if (loginAct == "" || loginPwd == ""){
				$("#msg").html("用户名或密码不能为空");
				// 如果用户名密码为空，及时强制终于该方法
				return false;
			}
			$.ajax({
				url:"settings/user/login",
				data:{
					"loginAct":loginAct,
					"loginPwd":loginPwd
				},
				type:"post",
				dataType:"json",
				success:function (data) {

					// 如果登录成功
					if (data.sucess){
						window.location.href = "workbench/index.jsp"
					}else{
						$("#msg").html(data.msg)
					}
				}
			})
		}
	</script>
</head>
<body>
	<div style="position: absolute; top: 0px; left: 0px; width: 60%;">
		<img src="image/IMG_7114.JPG" style="width: 100%; height: 90%; position: relative; top: 50px;">
	</div>
	<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
		<div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">CRM &nbsp;<span style="font-size: 12px;">&copy;2017&nbsp;动力节点</span></div>
	</div>
	
	<div style="position: absolute; top: 120px; right: 100px;width:450px;height:400px;border:1px solid #D5D5D5">
		<div style="position: absolute; top: 0px; right: 60px;">
			<div class="page-header">
				<h1>登录</h1>
			</div>
			<form action="workbench/index.jsp" class="form-horizontal" role="form">
				<div class="form-group form-group-lg">
					<div style="width: 350px;">
						<input class="form-control" type="text" placeholder="用户名" id="loginAct">
					</div>
					<div style="width: 350px; position: relative;top: 20px;">
						<input class="form-control" type="password" placeholder="密码" id="loginPwd">
					</div>
					<div class="checkbox"  style="position: relative;top: 30px; left: 10px;">
						
							<span id="msg" style="color: red"></span>
						
					</div>
					<%--该按钮写在form表单中，默认的行为就是提交表单--%>
					<button type="button" id="submitBtn" class="btn btn-primary btn-lg btn-block" style="width: 350px; position: relative;top: 45px;">登录</button>
				</div>
			</form>
		</div>
	</div>
</body>
</html>