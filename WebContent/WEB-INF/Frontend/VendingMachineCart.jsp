<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<c:url value="/" var="WEB_PATH"/>
<c:url value="/js" var="JS_PATH"/>
<c:url value="/css" var="CSS_PATH"/>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>販賣機</title>
	<link type="text/css" rel="stylesheet" href="${CSS_PATH}/bootstrap.min.css" />
	<script src="${JS_PATH}/jquery-3.2.1.min.js"></script>
	<script src="${JS_PATH}/popper.min.js"></script>
	<script src="${JS_PATH}/bootstrap.min.js"></script>
	<script type="text/javascript">
	$(document).ready(function(){
		$.ajax({
			url: '${WEB_PATH}MemberAction.do?action=queryCartSize',
 			type: "GET",
 			success: function(cartInfo){
 				$("#showSize").text(cartInfo.cartSize);
 			}
		})
	})
	
	function addCartGoods(goodsID, buyQuantityIdx) {
		console.log("goodsID:", goodsID);
		var buyQuantity = document.getElementsByName("buyQuantity")[buyQuantityIdx].value;
		if(buyQuantity<=0){
			alert("數量必須大於0");
		}else{	
			var addDetail = {
				"goodsID" : goodsID,
				"buyQuantity" : buyQuantity
			}
			$.ajax({
				url: '${WEB_PATH}MemberAction.do?action=addCartGoods',
				type: "POST",
				data: addDetail,
				success: function(success){
					alert("已將 " + buyQuantity + "個 "+success.goodsName+" 加入購物車");
					//更新 購物車() <-括弧內的顯示商品數量
					$.ajax({
						url: '${WEB_PATH}MemberAction.do?action=queryCartSize',
			 			type: "GET",
			 			success: function(cartInfo){
			 				$("#showSize").text(cartInfo.cartSize);
		 
			 			}
					})
				},
				error: function(error){
					alert("AJAX ERROR!!");
				}
			})
		}
	}
	
<%	
	if(null!=request.getParameter("pageNo")){
		pageContext.setAttribute("pageNo", request.getParameter("pageNo"));	
	}else{
		pageContext.setAttribute("pageNo",1);
	}
	if(null!=request.getParameter("searchKeyword")){
		pageContext.setAttribute("searchKeyword", request.getParameter("searchKeyword"));	
	}

	int index =0;
%>
</script>
</head>
<body>
	<div class="container">
		<div class="row" style="padding: 8px;">
			<div calss="col">
				<a class="btn btn-outline-primary" href="LoginAction.do?action=logout">登出</a>
				<a class="btn btn-outline-secondary" href="FrontendAction.do?action=gotoBackend" align="left" >後臺頁面</a>
			</div>
			<div class="col text-right">
				<form action="FrontendAction.do" method="get">
					<input type="hidden" name="action" value="searchGoods"/>
					<input type="hidden" name="pageNo" value="1"/>
					<input type="text" name="searchKeyword" value="${searchKeyword}"/>
					<input class="btn btn-primary" type="submit" value="商品查詢"/>
				</form>
			</div>
		</div>
		<div class="row text-center align-items-center" >
			<div class="col-4" >
				<img src="DrinksImage/coffee.jpg" width="200" height="200" >
				<h1>歡迎光臨，${sessionScope.member.customerName}</h1>
				<br><br>
				<a class="btn btn-primary" href="MemberAction.do?action=queryCartGoods">
					購物車(<span id="showSize">0</span>)
				</a>
			</div>
		
			<div class="col">
				<c:forEach items="${resultTable}" var="row">
				<div class="card-deck">
					<c:forEach items="${row}" var="goods">
					<div class="card text-center" style="width: 18rem;">
						<img class="card-img-top" src="DrinksImage/${goods.goodsImageName}">
						<div class="card-body">
							<h5 class="card-title">${goods.goodsName}</h5>
							<p class="card-text" style="color: grey;">
								${goods.goodsPrice} 元/罐
							</p>
							<input type="hidden" name="goodsID" value="${goods.goodsID}">
							購買<input type="number" name="buyQuantity" min="0" max="${goods.goodsQuantity}" size="5" value="0">罐
							<p class="card-text" <c:if test="${goods.goodsQuantity eq 0}">style="color: red;" 
									</c:if>>(庫存 ${goods.goodsQuantity} 罐)
							</p>
							<button class="btn btn-outline-primary" onclick="addCartGoods(${goods.goodsID},<%=index++%>)" >加入購物車</button>
						</div>
					</div>		
					</c:forEach>
				</div>
				</c:forEach>
			</div>
			<div class="w-100"></div>
			<div class="col-4 text-left">
				
			</div>
			<div class="col" style="padding: 8px;">
				<nav aria-label="Page navigation example">
					<ul class="pagination justify-content-center">
						<li class="page-item <c:if test="${pageNo eq '1'}">disabled</c:if>">
							<a class="page-link" href="FrontendAction.do?action=searchGoods&pageNo=1&searchKeyword=${searchKeyword}">
							<span>第一頁</span>
							</a>
						</li>
						<li class="page-item <c:if test="${pageNo eq '1'}">disabled</c:if>">
							<a class="page-link" href="FrontendAction.do?action=searchGoods&pageNo=${pageNo-1}&searchKeyword=${searchKeyword}">
							<span>上一頁</span>
							</a>
						</li>
						<c:forEach items="${showPageNumber}" var="pn">
							<li class="page-item <c:if test="${pageNo eq pn}">active</c:if>">
								<a class="page-link" href="FrontendAction.do?action=searchGoods&pageNo=${pn}&searchKeyword=${searchKeyword}">
									${pn}
								</a> 
							</li>
						</c:forEach>
						<li class="page-item <c:if test="${pageNo eq TotalPages}">disabled</c:if>">
							<a class="page-link" href="FrontendAction.do?action=searchGoods&pageNo=${pageNo+1}&searchKeyword=${searchKeyword}">
							<span>下一頁</span>
							</a>
						</li>
						<li class="page-item <c:if test="${pageNo eq TotalPages}">disabled</c:if>">
							<a class="page-link" href="FrontendAction.do?action=searchGoods&pageNo=${TotalPages}&searchKeyword=${searchKeyword}">
							<span>最末頁</span>
							</a>
						</li>
					</ul>
				</nav>
			</div>
		</div>
	</div>
</body>
</html>