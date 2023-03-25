<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<c:url value="/js" var="JS_PATH"/>
<c:url value="/css" var="CSS_PATH"/>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>販賣機 - 購物車</title>
	<link type="text/css" rel="stylesheet" href="${CSS_PATH}/bootstrap.min.css" />
	<script src="${JS_PATH}/jquery-3.2.1.min.js"></script>
	<script src="${JS_PATH}/popper.min.js"></script>
	<script src="${JS_PATH}/bootstrap.min.js"></script>

	<script type="text/javascript">
	function clearCartGoods() {
		const
		formData = new FormData();
		formData.append('action', 'clearCartGoods');
		// 送出清空購物車商品請求
		const
		request = new XMLHttpRequest();
		request.open("POST", "MemberAction.do");
		request.send(formData);
	}
	</script>
</head>
<body>
	<div class="container">
		<div class="row" style="padding: 8px;">
			<div class="col">
				<a class="btn btn-outline-primary" href="LoginAction.do?action=logout" align="left">登出</a>
			</div>
			<div class="col text-right">
				<a class="btn btn-primary" href="FrontendAction.do?action=searchGoods">繼續購物</a>
			</div>
		</div>
		<div class="row text-center align-items-center">
			<div class="col-4">
				<img src="DrinksImage/coffee.jpg" width="200" height="200" >	
				<h1>歡迎光臨，${sessionScope.member.customerName}</h1>
				<form action="FrontendAction.do" method="post">
					<input type="hidden" name="action" value="buyGoods"/>	
					<font face="微軟正黑體" size="4" >
						<b>投入:</b>
						<input type="number" name="inputMoney" max="100000" min="0"  size="5" value="0">
						<b>元</b><br/>		
						<b><input class="btn btn-secondary" type="submit" value="送出">	</b>				
						<br/><br/>
					</font>
				</form>
				<c:if test="${not empty reciept}">
				<div class="col" style="border-width:3px;border-style:dashed;border-color:#FFAC55;
						padding:5px;">
					<p style="color: blue;">~~~~~~~ 消費明細 ~~~~~~~</p>
					<p style="margin: 10px;">
						投入金額：${reciept.inputMoney}
					</p>
					<p style="margin: 10px;">
						購買金額：${reciept.buyMoney}
					</p>
					<p style="margin: 10px;">
						找零金額：${reciept.changeMoney}
					</p>
					<c:forEach items="${reciept.goods}" var="detail">
						<p style="margin: 10px;">
							${detail.goodsName}: <fmt:formatNumber type="number" pattern="$ #,###." 
									value="${detail.goodsPrice}"/> * ${detail.goodsQuantity}
						</p>
					</c:forEach>	
				</div>
				</c:if>
			</div>
				<div class="col">
					<c:choose>
						<c:when test="${fn:length(cartGoods) eq '0'}">購物車內沒有商品</c:when>
						<c:otherwise>
						<table class="table table-striped">
							<thead>
								<tr>
									<th scope="col">#</th>
									<th scope="col">商品名稱</th>
									<th scope="col">數量</th>
									<th scope="col">單價</th>
								</tr>
							</thead>
							<c:forEach items="${cartGoods}" var="goods" varStatus="status">
								<tr>
									<th scope="row">${status.index + 1}</th>
									<td>${goods.key.goodsName}</td>
									<td>${goods.value}</td>
									<td>${goods.key.goodsPrice}</td>
								</tr>
							</c:forEach>
							<tr>
								<td colspan="4" align="right"><br>總計： <fmt:formatNumber value="${cartTotal}" type="number" pattern="$ #,###."/></td>
							</tr>
						</table>
						</c:otherwise>
					</c:choose>
			
				</div>
		</div>
		<div class="row">
			<div class="col">
				<a class="btn btn-outline-secondary" href="FrontendAction.do?action=gotoBackend" align="left" >後臺頁面</a>
			</div>
		</div>
	</div>
</body>
</html>