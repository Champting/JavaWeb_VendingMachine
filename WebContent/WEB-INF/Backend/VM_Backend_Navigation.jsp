<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<c:url value="/js" var="JS_PATH" />
<c:url value="/css" var="CSS_PATH" />
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>販賣機-後臺</title>
<link type="text/css" rel="stylesheet"
	href="${CSS_PATH}/bootstrap.min.css" />
<script src="${JS_PATH}/jquery-3.2.1.min.js"></script>
<script src="${JS_PATH}/popper.min.js"></script>
<script src="${JS_PATH}/bootstrap.min.js"></script>
</head>
<body>
	<nav class="navbar navbar-expand-lg navbar-light bg-light">
	<p class="navbar-brand">販賣機-後臺</p>
	<button class="navbar-toggler" type="button" data-toggle="collapse"
		data-target="#navbarSupportedContent"
		aria-controls="navbarSupportedContent" aria-expanded="false"
		aria-label="Toggle navigation">
		<span class="navbar-toggler-icon"></span>
	</button>

	<div class="collapse navbar-collapse" id="navbarSupportedContent">
		<ul class="navbar-nav mr-auto">
			<li
				class="nav-item <c:if test="${currentPage eq 'list'}"> active</c:if>">
				<a class="nav-link" href="BackendSearch.do?action=queryAllGoods">商品列表
					<span class="sr-only">(current)</span>
				</a>
			</li>
			<li
				class="nav-item <c:if test="${currentPage eq 'repl'}"> active</c:if>">
				<a class="nav-link"
				href="BackendAction.do?action=goodsReplenishmentView">商品維護</a>
			</li>
			<li
				class="nav-item <c:if test="${currentPage eq 'create'}"> active</c:if>">
				<a class="nav-link" href="BackendAction.do?action=goodsCreateView">新增上架</a>
			</li>
			<li
				class="nav-item <c:if test="${currentPage eq 'report'}"> active</c:if>">
				<a class="nav-link"
				href="BackendAction.do?action=goodsSaleReportView">銷售報表</a>
			</li>
			<li class="nav-item"><a class="nav-link text-light bg-dark"
				href="BackendAction.do?action=gotoFrontend">回到前臺</a>
			</li>
<!-- 			<a class="btn btn-secondary float-right" href="BackendAction.do?action=gotoFrontend">回到前臺</a> -->
		</ul>
	</div>
	</nav>
</body>
</html>