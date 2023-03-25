<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<c:url value="/js" var="JS_PATH"/>
<c:url value="/css" var="CSS_PATH"/>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=BIG5">
	<title>登入</title>
	<link type="text/css" rel="stylesheet" href="${CSS_PATH}/bootstrap.min.css" />
	<script src="${JS_PATH}/jquery-3.2.1.min.js"></script>
	<script src="${JS_PATH}/popper.min.js"></script>
	<script src="${JS_PATH}/bootstrap.min.js"></script>
</head>
<body background="./loginBG.jpg">
	<div class="container">
		<div class="col-3 mx-auto mt-5">
			<form action="LoginAction.do" method="post">
				<input type="hidden" name="action" value="login">
					<h1 style="font-weight: bold; text-align: center;">WELCOME!!</h1>
					<h3 class="my-4" style="text-align: center;">請先登入</h3>
					<div class="my-3" style="color: red; text-align: center;">${requestScope.loginMsg}</div>
					UESR
					<input class="form-control mb-4" type="text" name="id">
					PASSWORD
					<input class="form-control mb-4"type="password" name="pwd">
					<input type="submit" class="btn btn-secondary float-right" value="LOG IN" >
<!-- 					<table> -->
<!-- 						<tr><td colspan="2" style="font-weight: bold; font-size: 40px; text-align: center;" ><br>WELCOME!!</td></tr> -->
<!-- 						<tr><td colspan="2" style="font-size: 24px; text-align: center;" ><br>請先登入<br><br></td></tr> -->
<%-- 						<tr><td colspan="2" style="color: red; text-align: center;">${requestScope.loginMsg}</td></tr> --%>
<!-- 						<tr><td style="padding: 5px;">UESR</td><td><input type="text" name="id"></td></tr> -->
<!-- 						<tr><td style="padding: 5px;">PASSWORD</td><td><input type="password" name="pwd"></td></tr>  -->
<!-- 						<tr><td></td><td align=right><input type="submit" value="LOG IN" ></td> -->
<!-- 					</table> -->
			</form>
		</div>
	</div>
</body>
</html>