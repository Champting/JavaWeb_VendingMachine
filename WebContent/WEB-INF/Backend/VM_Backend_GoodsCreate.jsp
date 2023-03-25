<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<c:url value="/" var="WEB_PATH"/>
<c:url value="/js" var="JS_PATH"/>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>販賣機-後臺 商品新增</title>
	<link type="text/css" rel="stylesheet"
		href="${CSS_PATH}/bootstrap.min.css" />
	<script src="${JS_PATH}/jquery-3.2.1.min.js"></script>
	<script src="${JS_PATH}/popper.min.js"></script>
	<script src="${JS_PATH}/bootstrap.min.js"></script>
</head>
<body>
	<div class="container">
	<c:set var="currentPage" value="create"/>
	<%@ include file="VM_Backend_Navigation.jsp" %>
	<div class="row">
		<div class="col my-4"><h2>新增上架</h2></div>
	</div>
	<div class="row">
		<div class="col my-2" style="color: blue; font-weight: bold;">${updateMsg}</div>
		<%session.removeAttribute("updateMsg"); %>
	</div>
	<div class="row">
		<div class="col-4 my-3">
		<form action="BackendAction.do?action=addGoods" enctype="multipart/form-data" method="post">
			<p>
				飲料名稱：
				<input type="text" class="form-control" name="goodsName" size="10"/>
			</p>
			<p>
				設定價格： 
				<input type="number" class="form-control" name="goodsPrice" size="5" value="0" min="0" max="1000"/>
			</p>
			<p>
				初始數量：
				<input type="number" class="form-control" name="goodsQuantity" size="5" value="0" min="0" max="1000"/>
			</p>
			<p>
				商品圖片：
				<input class="form-control-file" type="file" name="goodsImage"/>
			</p>
			<p>
				商品狀態：
				<select class="form-control" name="status">
					<option value="1">上架</option>
					<option value="0">下架</option>				
				</select>
			</p>
			<p>
				<input class="btn btn-outline-secondary float-right" type="submit" value="送出">
			</p>
		</form>
		</div>
	</div>
	</div>
</body>
</html>